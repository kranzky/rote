require 'sinatra/base'

module Sinatra
  module RoteHelper
    def handler(class_name)
      action = Module.const_get("App::Actions::#{class_name}").new(params)
      raise unless action.is_a?(RoteAction)
      action.validate
      view = action.handle
      raise unless view.is_a?(RoteView)
      view.validate
      view.html(self)
    end
  end
  helpers RoteHelper
end

Thread.current[:rote] ||= Hash.new { |h, k| h[k] = {} }

class RoteAction
  def self.param(name, default=nil)
    raise unless name.is_a?(Symbol)
    Thread.current[:rote][self.name][name] = default
    define_method(name, ->{ @context[name] })
  end

  def initialize(params={})
    @context = Thread.current[:rote][self.class.name].dup
    @context.keys.each do |key|
      next unless params.include?(key)
      @context[key] = params[key]
    end
    @success = true
  end

  def perform(sentence)
    return unless @success
    class_name = sentence.split.map(&:capitalize).join
    service = Module.const_get("App::Services::#{class_name}").new(self.to_h)
    raise unless service.is_a?(RoteService)
    service.validate_args
    if @success &&= service.perform
      service.validate_results
      @context.merge!(service.to_h)
    end
    @success
  end

  def success?
    @success
  end

  def build(class_name)
    view = Module.const_get("App::Views::#{class_name}").new(self.to_h)
    raise unless view.is_a?(RoteView)
    view.validate
    view
  end

  def to_h
    @context
  end

  def validate
  end
end

class RoteService
  def self.argument(name, default=nil)
    raise unless name.is_a?(Symbol)
    Thread.current[:rote][self.name][name] = default
    define_method(name, ->{ @context[name] })
  end

  def self.result(name, default=nil)
    raise unless name.is_a?(Symbol)
    Thread.current[:rote][self.name][name] = default
    define_method(name, ->{ @context[name] })
    define_method("#{name}=", ->(value){ @context[name] = value })
  end

  def initialize(arguments={})
    @context = Thread.current[:rote][self.class.name].dup
    @context.keys.each do |key|
      next unless arguments.include?(key)
      @context[key] = arguments[key]
    end
    @success = true
  end

  def to_h
    @context
  end

  def validate_args
  end

  def validate_results
  end
end

# declare which template to use
# declare the locals the template expects
# implement helper methods
# can render html (hamlit) or json (roar)
class RoteView
  def self.template(name)
    raise unless name.is_a?(Symbol)
    Thread.current[:rote][self.name + "_template"] = name
  end

  def self.local(name, default=nil)
    raise unless name.is_a?(Symbol)
    Thread.current[:rote][self.name][name] = default
    define_method(name, ->{ @context[name] })
  end

  def initialize(locals)
    @template = Thread.current[:rote][self.class.name + "_template"]
    @context = Thread.current[:rote][self.class.name].dup
    @context.keys.each do |key|
      next unless locals.include?(key)
      @context[key] = locals[key]
    end
  end

  def html(renderer)
    renderer.haml(@template, { scope: self })
  end

  def json
  end

  def to_h
    @context
  end

  # raises
  def validate
  end
end
