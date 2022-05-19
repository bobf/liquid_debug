# frozen_string_literal: true

require 'liquid'
require 'liquid/debug'

RSpec.describe 'liquid debug' do
  let(:template) do
    Liquid::Template.parse(load_fixture(fixture), error_mode: :strict).render!(
      {},
      strict_variables: true,
      strict_filters: true
    )
  end

  let(:output) do
    Class.new do
      def initialize
        @content = []
      end

      def puts(input)
        @content << input
      end

      def content
        @content.join
      end
    end.new
  end

  def load_fixture(name)
    File.read(
      File.expand_path(
        File.join(__dir__, '..', 'fixtures', "#{name}.liquid")
      )
    )
  end

  context 'undefined variable' do
    before { allow(LiquidDebug).to receive(:output) { output } }
    let(:fixture) { 'undefined_variable' }

    it 'generates debug report before re-raising' do
      expect { template }.to raise_error Liquid::UndefinedVariable
      expect(output.content).to include 'Liquid error: undefined variable foo'
    end
  end

  context 'undefined variable' do
    before { allow(LiquidDebug).to receive(:output) { output } }
    let(:fixture) { 'variable_eval_error' }

    it 'handles both {% tags %} and {{ variables }}' do
      expect { template }.to raise_error Liquid::UndefinedVariable
      expect(output.content).to include 'Liquid error: undefined variable bar'
    end
  end
end
