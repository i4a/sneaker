# frozen_string_literal: true

require 'tty-table'
require 'pastel'

module Sneaker
  class Presentation
    class Table < Presentation
      def initialize(stages)
        @pastel = Pastel.new

        super
      end

      private

      def formatted_stage(stage)
        @pastel.bold(stage)
      end

      def formatted_result(result)
        return @pastel.on_red('!error') if result == :error
        return @pastel.red(result)      if result == 'false'
        return @pastel.green(result)    if result == 'true'

        result
      end

      def output_lines
        @tty_table.rows_size + 2
      end

      def draw
        @tty_table = TTY::Table.new(results_table)
        puts @tty_table.render(:unicode)
      end

      def results_table
        @results.reduce([]) do |results_table, stage_with_result|
          results_table << [
            formatted_stage(stage_with_result.first),
            stage_with_result.last
          ]
        end
      end
    end
  end
end
