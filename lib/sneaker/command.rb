# frozen_string_literal: true

require 'sneaker/presentation'
require 'sneaker/stage'

module Sneaker
  class Command
    def initialize(command)
      @command = command
    end

    def execute
      if stage?
        single_execute
      else
        multiple_execute
      end
    end

    private

    def stage
      @stage ||= Stage.find(ENV['stage'])
    end

    def stage?
      !stage.nil?
    end

    def single_execute
      puts stage.execute(@command)
    end

    def multiple_execute
      stages = Stage.all
      presentation = Presentation.new(stages.map(&:name))
      threads = []
      mutex = Mutex.new

      stages.each do |stage|
        thread = Thread.new do
          result = stage.execute @command

          mutex.synchronize do
            presentation.set(stage.name, result)
          end
        end

        threads.push(thread)
      end

      # Wait for threads to finish
      threads.each(&:join)
    end
  end
end
