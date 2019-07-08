# frozen_string_literal: true

require 'tty-table'
require 'tty-cursor'
require 'pastel'

module Sneaker
  class Presentation
    class CSV < Presentation
      private

      def output_lines
        @results.size
      end

      def draw
        @results.each do |result|
          puts result.join(',')
        end
      end
    end
  end
end
