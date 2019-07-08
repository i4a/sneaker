# frozen_string_literal: true

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
