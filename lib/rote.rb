require 'sinatra/base'
require 'sequel/plugins/validation_helpers'
require 'sequel/model/errors'

Thread.current[:rote] ||= Hash.new { |h, k| h[k] = {} }

module Rote
  class Error < StandardError
  end

  module Helper
    def respond(class_name, format = :html)
      logger.measure_info "Processed by #{class_name} as #{format.upcase}" do
        action = Module.const_get("App::Actions::#{class_name}").new(params)
        raise Error, "bad action" unless action.is_a?(Action)
        raise Error, action.errors unless action.valid?
        view = action.respond
        raise Error, "bad view" unless view.is_a?(View)
        raise Error, view.errors unless view.valid?
        view.render(self, format)
      end
    end
  end

  class Base
    include Sequel::Plugins::ValidationHelpers::InstanceMethods

    def initialize
      @context = Thread.current[:rote][self.class.name].dup
      @errors = Sequel::Model::Errors.new
    end

    def model
      return Class.new do
        def initialize(scope)
          @scope = scope
        end
        def db
          @scope
        end
      end.new(self)
    end
    def blank_object?(obj)
      return obj.blank? if obj.respond_to?(:blank?)
      case obj
      when NilClass, FalseClass
        true
      when Numeric, TrueClass
        false
      when String
        obj.strip.empty?
      else
        obj.respond_to?(:empty?) ? obj.empty? : false
      end
    end
    def get_column_value(name)
      @context[name]
    end

    def valid?
      errors.clear
      validate
      # TODO: warn log - show errors
      errors.empty?
    end

    def validate
    end

    def errors
      @errors
    end

    def to_h
      @context
    end

    def logger
      SemanticLogger['RotE']
    end
  end

  class Action < Base
    def self.param(name, default=nil)
      raise Error, "bad action param" unless name.is_a?(Symbol)
      Thread.current[:rote][self.name][name] = default
      define_method(name, ->{ @context[name] })
    end

    def initialize(params={})
      super()
      @context.keys.each do |key|
        next unless params.include?(key)
        @context[key] = params[key]
      end
      @success = true
    end

    def success?
      @success
    end

    def perform(sentence)
      return unless success?
      class_name = sentence.split.map(&:capitalize).join
      service = Module.const_get("App::Services::#{class_name}").new(self.to_h)
      raise Error, "bad service" unless service.is_a?(Service)
      raise Error, service.errors unless service.valid?
      if @success &&= service.perform
        raise Error, service.errors unless service.valid?
        # TODO: debug log what got created or updated
        @context.merge!(service.to_h)
      end
    end

    def render(class_name)
      view = Module.const_get("App::Views::#{class_name}").new(self.to_h)
      raise Error, "bad view" unless view.is_a?(View)
      raise Error, view.errors unless view.valid?
      view
    end
  end

  class Service < Base
    def self.argument(name, default=nil)
      raise Error, "bad service argument" unless name.is_a?(Symbol)
      Thread.current[:rote][self.name][name] = default
      define_method(name, ->{ @context[name] })
    end

    def self.result(name, default=nil)
      raise Error, "bad service result" unless name.is_a?(Symbol)
      Thread.current[:rote][self.name][name] = default
      define_method(name, ->{ @context[name] })
      define_method("#{name}=", ->(value){ @context[name] = value })
      instance_eval { private "#{name}=" }
    end

    def initialize(arguments={})
      super()
      @context.keys.each do |key|
        next unless arguments.include?(key)
        @context[key] = arguments[key]
      end
      @performed = false
    end

    def perform
      raise Error, "cannot perform twice" if @performed
      logger.info "Perform #{self.class.name.gsub('App::Services::', '')}"
      @performed = true
      # TODO: warn log if service fails
      # TODO: wrap this with an alias somehow so we don't need super
    end

    def validate
      validate_arguments
      validate_results if @performed
    end
  end

  class View < Base
    def self.template(name)
      raise Error, "bad view template" unless name.is_a?(Symbol)
      Thread.current[:rote][self.name + "_template"] = name
    end

    def self.local(name, default=nil)
      raise Eror, "bad view local" unless name.is_a?(Symbol)
      Thread.current[:rote][self.name][name] = default
      define_method(name, ->{ @context[name] })
    end

    def initialize(locals)
      super()
      @context.keys.each do |key|
        next unless locals.include?(key)
        @context[key] = locals[key]
      end
      @template = Thread.current[:rote][self.class.name + "_template"]
    end

    def render(scope, format)
      logger.measure_info "Rendered #{self.class.name.gsub('App::Views::', '')}" do
        case format
        when :html
          scope.haml(@template, { scope: self })
        when :json
          scope.jbuilder(@template, { scope: self })
        else
          scope.error(406)
        end
      end
    end
  end
end

module Sinatra
  helpers Rote::Helper
end
