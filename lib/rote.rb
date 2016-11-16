require 'sinatra/base'
require 'sequel/plugins/validation_helpers'
require 'sequel/model/errors'

Thread.current[:rote] ||= Hash.new { |h, k| h[k] = {} }

module Rote
  class Error < StandardError
  end

  module Helper
    def respond(action_class, format: :html, template: nil)
      logger.info "Processing by #{action_class.name.gsub('App::Actions::', '')} as #{format.upcase}"
      logger.trace "Parameters: #{params}"
      action = action_class.new(params)
      raise Error, "bad action" unless action.is_a?(Action)
      raise Error, action.errors unless action.valid?
      view = action.respond
      raise Error, "bad view" unless view.is_a?(View)
      raise Error, view.errors unless view.valid?
      view.render(self, template, format)
    end
  end

  Model = Class.new(Sequel::Model)
  class Model
    plugin :validation_helpers

    def validate
    end

    def logger
      SemanticLogger['Rote::Model']
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
  end

  class Action < Base
    def self.param(name, default=nil)
      raise Error, "bad action param" unless name.is_a?(Symbol)
      Thread.current[:rote][self.name][name] = default
      define_method(name, ->{ @context[name] })
    end

    def self.decorate_methods
      return unless instance_methods.include?(:respond)
      return if Thread.current[:rote][self.name][:decorated]
      Thread.current[:rote][self.name][:decorated] = true
      original_method = instance_method(:respond)
      define_method(:respond) do
        raise Error, "cannot respond twice" if @responded
        @responded = true
        logger.measure_info "Responded #{self.class.name.gsub('App::Actions::', '')}" do
          original_method.bind(self).call
        end
      end
    end

    def initialize(params={})
      super()
      @context.keys.each do |key|
        next unless params[key]
        @context[key] = params[key]
      end
      @success = true
      @responded = false
      self.class.decorate_methods
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
        @context.merge!(service.to_h)
      end
    end

    def render(view_class)
      view = view_class.new(self.to_h)
      raise Error, "bad view" unless view.is_a?(View)
      raise Error, view.errors unless view.valid?
      view
    end

    def logger
      SemanticLogger['Rote::Action']
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

    def self.decorate_methods
      return unless instance_methods.include?(:perform)
      return if Thread.current[:rote][self.name][:decorated]
      Thread.current[:rote][self.name][:decorated] = true
      original_method = instance_method(:perform)
      define_method(:perform) do
        raise Error, "cannot perform twice" if @performed
        @performed = true
        logger.measure_info "Performed #{self.class.name.gsub('App::Services::', '')}" do
          original_method.bind(self).call
        end
      end
    end

    def initialize(arguments={})
      super()
      @context.keys.each do |key|
        next unless arguments[key]
        @context[key] = arguments[key]
      end
      @performed = false
      self.class.decorate_methods
    end

    def validate
      validate_arguments
      validate_results if @performed
    end

    def logger
      SemanticLogger['Rote::Service']
    end
  end

  class View < Base
    def self.template(name)
      name = name.to_sym if name.is_a?(String)
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
        next unless locals[key]
        @context[key] = locals[key]
      end
      @template = Thread.current[:rote][self.class.name + "_template"]
      @sinatra = nil
    end

    def render(sinatra, template, format)
      @sinatra = sinatra
      logger.measure_info "Rendered #{self.class.name.gsub('App::Views::', '')}" do
        case format
        when :html
          sinatra.slim(template || @template, { scope: self })
        when :json
          sinatra.jbuilder(template || @template, { scope: self })
        else
          sinatra.error(406)
        end
      end
    end

    def logger
      SemanticLogger['Rote::View']
    end

    def script(name)
      if Sinatra::Base.development?
        @sinatra.slim("script(src='//localhost:8080/#{name}')")
      else
        @sinatra.slim("script(src='#{name}')")
      end
    end
  end
end

module Sinatra
  helpers Rote::Helper
end
