# frozen_string_literal: true

module LiquidDebug
  class ErrorHandler
    def initialize(error, reference_stack, template_stack, output = LiquidDebug.output)
      @error = error
      @reference_stack = reference_stack
      @template_stack = template_stack
      @output = output
    end

    def print(limit = 10)
      report(limit)
      template_report
    end

    def backtrace(limit = 10)
      @backtrace ||= trace(limit)
    end

    private

    # rubocop:disable Metrics/AbcSize
    def report(limit)
      @output.puts("\n#{red(@error&.to_s || 'Unexpected error')}")
      return nil if backtrace.empty?

      @output.puts(message(limit, backtrace))
      backtrace[0...-1].each { |frame| @output.puts("   #{frame}") } if backtrace.size > 1

      @output.puts(open_highlight + backtrace[-1] + close_highlight)
      @output.puts("\n")
    end
    # rubocop:enable Metrics/AbcSize


    def template_report
      return nil if matched_template_location.nil?

      first = [matched_template_location - 5, 0].max
      last = [matched_template_location + 5, template_lines.size].min
      template_lines[first...last]
    end

    def matched_template_location
      pp template_lines
      pp matched_template_locations
      byebug if template_lines.size
      matched_template_locations.size == 1 ? matched_template_locations.first : nil
    end

    def matched_template_locations
      @matched_template_locations ||= template_lines.each
                                                    .with_index
                                                    .select { |line, index| line == @reference_stack.last }
    end

    def template_lines
      @template_lines ||= @template_stack.last&.split("\n")&.map(&:chomp) || []
    end

    def trace(limit)
      @reference_stack.last(limit).map { |frame| format(frame) }.compact
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
      "#{Paint['Backtrace:', :white]}\n\n"
    end

    def red(text)
      Paint[text, :red]
    end
  end
end
