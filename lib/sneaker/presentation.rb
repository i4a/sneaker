# frozen_string_literal: true

require 'tty-table'
require 'tty-cursor'
require 'pastel'

module Sneaker
  class Presentation
    def initialize(stages)
      @table = []
      @stages = stages.sort
      @cursor = TTY::Cursor
      @pastel = Pastel.new

      @stages.each do |stage|
        @table << [formatted_stage(stage), @pastel.inverse('loading...')]
      end

      draw
    end

    def set(stage, result)
      set_in_table(stage, result)

      redraw
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

    def set_in_table(stage, result)
      @table.each do |row|
        row[1] = formatted_result(result) if row.first == formatted_stage(stage)
      end
    end

    def redraw
      clear
      draw
    end

    def clear
      print @cursor.up(@tty_table.rows_size + 2)
      print @cursor.clear_line_after
    end

    def draw
      @tty_table = TTY::Table.new(@table)
      puts @tty_table.render(:unicode)
    end
  end
end
