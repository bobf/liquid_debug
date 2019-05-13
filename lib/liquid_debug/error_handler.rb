# frozen_string_literal: true

module LiquidDebug
  class ErrorHandler
    def initialize(error, stack, output = LiquidDebug.output)
      @error = error
      @stack = stack
      @output = output
    end

    def print(limit = 10)
      report(limit)
    end

    def backtrace(limit = 10)
      @backtrace ||= trace(limit)
    end

    private

    # rubocop:disable Metrics/AbcSize
    def report(limit)
      return nil if backtrace.empty?

      @output.puts("\n" + red(@error.to_s))
      @output.puts(message(limit, backtrace))
      if backtrace.size > 1
        backtrace[0...-1].each { |frame| @output.puts("   #{frame}") }
      end

      @output.puts(open_highlight + backtrace[-1] + close_highlight)
      @output.puts("\n")
    end
    # rubocop:enable Metrics/AbcSize

    def trace(limit)
      @stack.last(limit).map { |frame| format(frame) }.compact
    end

    def format(frame)
      return nil if frame[:tag_name].nil? && frame[:markup].nil?

      tag = frame[:tag_name]
      return variable_tag(frame) if tag.nil?

      standard_tag(frame, tag)
    end

    def variable_tag(frame)
      "#{open_var} #{markup(frame[:markup])} #{close_var}"
    end

    def standard_tag(frame, tag)
      "#{open_tag} #{tag_name(tag)} #{markup(frame[:markup])}#{close_tag}"
    end

    def open_tag
      Paint['{%', :cyan]
    end

    def close_tag
      Paint['%}', :cyan]
    end

    def open_var
      Paint['{{', :cyan]
    end

    def close_var
      Paint['}}', :cyan]
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
      Paint[text, :cyan, :bright].strip
    end

    def message(_limit, _backtrace)
      Paint['Backtrace:', :white] + "\n\n"
    end

    def red(text)
      Paint[text, :red]
    end
  end
end
