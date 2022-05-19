# frozen_string_literal: true

require 'paint'

require 'liquid_debug/version'
require 'liquid_debug/error_handler'

module LiquidDebug
  class Error < StandardError; end

  def self.track(tag_name, markup)
    stack.push(tag_name: tag_name, markup: markup)
  end

  def self.reset
    stack.clear
  end

  def self.stack
    @stack ||= []
  end

  def self.output
    $stdout
  end
end
