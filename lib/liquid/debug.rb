# frozen_string_literal: true

require 'liquid_debug'

module LiquidDebug
  module TagTracker
    def render(*_args)
      LiquidDebug.track(@tag_name, @markup)
      super
    end
  end

  module VariableTracker
    def render(*_args)
      LiquidDebug.track(nil, @markup)
      super
    end
  end

  module ContextErrorHandler
    def handle_error(error, *args)
      LiquidDebug::ErrorHandler.new(error, LiquidDebug.stack).print
      LiquidDebug.reset
      super
    end
  end
end

require 'liquid'

unless ENV.key?('LIQUID_DEBUG_DISABLE')
  Liquid::Context.prepend LiquidDebug::ContextErrorHandler
  ObjectSpace.each_object(Class)
             .select { |class_| class_ < Liquid::Tag }
             .each { |class_| class_.prepend(LiquidDebug::TagTracker) }
  Liquid::Variable.prepend(LiquidDebug::VariableTracker)
end
