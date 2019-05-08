# frozen_string_literal: true

module LiquidDebug
  class ErrorHandler
    def initialize(error, stack)
      @error = error
      @stack = stack
    end

    def print(limit = 10)
      report(limit)
    end

    private

    # rubocop:disable Metrics/AbcSize
    def report(limit)
      backtrace = trace(limit)
      return nil if backtrace.empty?

      puts("\n" + red(@error.to_s))
      puts(message(limit, backtrace))
      if backtrace.size > 1
        backtrace[0...-1].each { |frame| puts("   #{frame}") }
      end

      puts(open_highlight + backtrace[-1] + close_highlight)
      puts("\n")
    end
    # rubocop:enable Metrics/AbcSize

    def trace(limit)
      @stack.last(limit).map { |frame| format(frame) }.compact
    end

    def format(frame)
      return nil if frame[:tag_name].nil? && frame[:markup].nil?

      tag = frame[:tag_name]
      "#{open_tag} #{tag_name(tag)} #{markup(frame[:markup])}#{close_tag}"
    end

    def open_tag
      Paint['{%', :cyan]
    end

    def close_tag
      Paint['%}', :cyan]
    end

    def open_highlight
      Paint['=> ', :red, :bright]
    end

    def close_highlight
      Paint[' <=', :red, :bright]
    end

    def tag_name(name)
      Paint[name, :yellow]
    end

    def markup(text)
      Paint[text, :cyan, :bright]
    end

    def message(_limit, _backtrace)
      Paint['Backtrace:', :white] + "\n\n"
    end

    def red(text)
      Paint[text, :red]
    end
  end
end
