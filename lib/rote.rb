require 'sinatra/base'
require 'sequel/plugins/validation_helpers'
require 'sequel/model/errors'

Thread.current[:rote] ||= Hash.new { |h, k| h[k] = {} }

class RoteError < StandardError
end

module Sinatra
  module RoteHelper
    def respond(class_name, format = :html)
      logger.info "Processing by #{class_name} as #{format.upcase}"
      action = Module.const_get("App::Actions::#{class_name}").new(params)
      raise RoteError, "bad action" unless action.is_a?(RoteAction)
      raise RoteError, action.errors unless action.valid?
      view = action.respond
      raise RoteError, "bad view" unless view.is_a?(RoteView)
      raise RoteError, view.errors unless view.valid?
      view.render(self, format)
    end
  end
  helpers RoteHelper
end

class RoteBase
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

  def logger
    SemanticLogger['RotE']
  end
end

class RoteAction < RoteBase
  def self.param(name, default=nil)
    raise RoteError, "bad action param" unless name.is_a?(Symbol)
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
    raise RoteError, "bad service" unless service.is_a?(RoteService)
    raise RoteError, service.errors unless service.valid?
    if @success &&= service.perform
      raise RoteError, service.errors unless service.valid?
      @context.merge!(service.to_h)
    end
  end

  def render(class_name)
    view = Module.const_get("App::Views::#{class_name}").new(self.to_h)
    raise RoteError, "bad view" unless view.is_a?(RoteView)
    raise RoteError, view.errors unless view.valid?
    view
  end
end

class RoteService < RoteBase
  def self.argument(name, default=nil)
    raise RoteError, "bad service argument" unless name.is_a?(Symbol)
    Thread.current[:rote][self.name][name] = default
    define_method(name, ->{ @context[name] })
  end

  def self.result(name, default=nil)
    raise RoteError, "bad service result" unless name.is_a?(Symbol)
    Thread.current[:rote][self.name][name] = default
    define_method(name, ->{ @context[name] })
    define_method("#{name}=", ->(value){ @context[name] = value })
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
    logger.info "Perform #{self.class.name.gsub('App::Services::', '')}"
    @performed = true
  end

  def validate
    validate_arguments
    validate_results if @performed
  end
end

class RoteView < RoteBase
  def self.template(name)
    raise RoteError, "bad view template" unless name.is_a?(Symbol)
    Thread.current[:rote][self.name + "_template"] = name
  end

  def self.local(name, default=nil)
    raise RoteEror, "bad view local" unless name.is_a?(Symbol)
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
    logger.info "Render #{self.class.name.gsub('App::Services::', '')}"
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
