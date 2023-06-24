# frozen_string_literal: true

require 'liquid_debug'

module LiquidDebug
  module TagTracker
    def render(*_args)
      LiquidDebug.track_reference(tag_name: @tag_name, markup: @markup)
      super
    end
  end

  module VariableTracker
    def render(*_args)
      pp _args
      LiquidDebug.track_reference(markup: @markup)
      super
    end
  end

  module TemplateTracker
    def parse(*args)
      LiquidDebug.track_template(template: args.first)
      super
    end
  end

  module ContextErrorHandler
    def handle_error(error, *args)
      LiquidDebug::ErrorHandler.new(error, LiquidDebug.reference_stack, LiquidDebug.template_stack).print
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
  Liquid::Template.prepend(LiquidDebug::TemplateTracker)
end
