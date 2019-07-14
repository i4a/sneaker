# frozen_string_literal: true

require 'spec_helper'

require 'sneaker/command'

RSpec.describe 'Integration commands' do
  let(:fixture_folder) { File.join(__dir__, 'fixtures', 'deploy') }
  let(:execute_command) do
    allow_any_instance_of(Sneaker::Stage).to receive(:`) do |stage|
      case stage.name
      when 'production'
        `exit 0`
        '20'
      when 'staging'
        `exit 0`
        '1'
      when 'broken'
        `exit 1`
        'this command failed!'
      end
    end

    Sneaker::Command.new('User.count').execute
  end

  before { stub_const('Sneaker::Stage::DIRECTORY', fixture_folder) }

  describe 'Single stage command' do
    around do |example|
      ENV['stage'] = stage

      example.run

      ENV.delete('stage')
    end

    context 'when selecting production stage' do
      let(:stage) { 'production' }

      it 'outputs the result of production only' do
        expect { execute_command }.to output("20\n").to_stdout
      end
    end

    context 'when selecting broken stage only' do
      let(:stage) { 'broken' }

      it 'outputs the result of production only' do
        expect { execute_command }.to output("error\n").to_stdout
      end
    end
  end

  describe 'Multi stage command' do
    context 'Table Presentation' do
      let(:pastel) { Pastel.new }

      it 'outputs the expected result for production' do
        production = Regexp.quote(pastel.bold('production'))
        expect { execute_command }.to output(/#{ production }\\|20/).to_stdout
      end

      it 'outputs the expected result for staging' do
        staging = Regexp.quote(pastel.bold('staging'))
        expect { execute_command }.to output(/#{ staging }\\|1/).to_stdout
      end

      it 'outputs the expected result for broken stage' do
        broken = Regexp.quote(pastel.bold('broken'))
        expect { execute_command }.to output(/#{ broken }\\|\!error/).to_stdout
      end
    end

    context 'CSV Presentation' do
      around do |example|
        ENV['format'] = 'csv'

        example.run

        ENV.delete('format')
      end

      it 'outputs the stages result in CSV format' do
        expect { execute_command }
          .to output(/broken,error\nproduction,20\nstaging,1/).to_stdout
      end
    end
  end
end
