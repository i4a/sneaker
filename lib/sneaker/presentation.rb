# frozen_string_literal: true

require 'tty-cursor'

require 'sneaker/presentation/csv'
require 'sneaker/presentation/table'

module Sneaker
  class Presentation
    def self.create(stages)
      klass = case ENV.fetch('format', '').downcase
              when 'csv'
                CSV
              else
                Table
              end

      klass.new(stages)
    end

    def initialize(stages)
      @stages = stages.sort
      @cursor = TTY::Cursor

      initialize_results
      draw
    end

    def set(stage, result)
      @results[stage] = formatted_result(result)

      redraw
    end

    private

    def initialize_results
      @results = {}

      @stages.each do |stage|
        @results[stage] = empty_result
      end
    end

    def empty_result
      '⏳'
    end

    def formatted_result(result)
      result
    end

    def redraw
      clear
      draw
    end

    def clear
      print @cursor.up(output_lines)
      print @cursor.clear_line_after
    end
  end
end
