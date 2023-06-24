# frozen_string_literal: true

require 'paint'

require 'liquid_debug/version'
require 'liquid_debug/error_handler'

module LiquidDebug
  class Error < StandardError; end

  def self.track_reference(tag_name: nil, markup: nil)
    reference_stack.push({ tag_name: tag_name, markup: markup })
  end

  def self.track_template(template: nil)
    template_stack.push(template)
  end

  def self.reset
    reference_stack.clear
    template_stack.clear
  end

  def self.reference_stack
    @reference_stack ||= []
  end

  def self.template_stack
    @template_stack ||= []
  end

  def self.output
    $stdout
  end
end
