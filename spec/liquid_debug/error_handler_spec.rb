# frozen_string_literal: true

RSpec.describe LiquidDebug::ErrorHandler do
  subject(:error_handler) { described_class.new(error, stack, output) }

  let(:error) {}
  let(:stack) { [{ tag_name: 'tag', markup: 'some markup' }] }
  let(:output) { double }

  describe '#print' do
    subject(:print) { error_handler.print }

    it 'prints a report' do
      expect(output).to receive(:puts).at_least(:once)
      error_handler.print
    end
  end

  describe '#backtrace' do
    subject(:backtrace) { error_handler.backtrace }

    it { is_expected.to be_an Array }
    it { is_expected.to_not be_empty }
    its(:first) { is_expected.to include 'tag' }
    its(:first) { is_expected.to include 'some markup' }
  end
end
