# frozen_string_literal: true

require 'English'
require 'yaml'

module Sneaker
  class Stage
    DIRECTORY = File.join('config', 'deploy')
    STAGES_FILE = File.join(DIRECTORY, 'stages.yml')

    RAILS_RUNNER_ENV = 'RUBY_GC_TUNE_VERBOSE=0'.freeze

    def self.files
      @files ||=
        Dir[File.join(DIRECTORY, '**rb')]
    end

    def self.list
      @list ||= build_list
    end

    def self.find(name)
      list.find { |stage| stage.name == name }
    end

    def self.build_list
      list =
        files.map do |file|
          new file
        end

      list.reject { |stage| ignored_stages.include?(stage.name) }
    end

    def self.ignored_stages
      stages_hash['ignore'] || []
    end

    def self.stages_hash
      @stages_hash ||= File.exist?(STAGES_FILE) ? YAML.load_file(STAGES_FILE) : {}
    end

    private_class_method :build_list

    class << self
      alias all list
    end

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def name
      @name ||=
        File.basename(file)[0...-3]
    end

    def server
      @server ||=
        server_line[/server '([\.\d\w]+)'/, 1]
    end

    def user
      @user ||=
        server_line[/user: '([\w-]+)'/, 1]
    end

    def name_application
      @name_application ||=
        name_application_line[/:name_application, '([\w-]+)'/, 1]
    end

    def execute(rails_command)
      rails_command = "Account.current = Account.where(name: '#{name_application}').first; print proc { #{rails_command} }.call"
      escaped_rails_command = escape_single_quotes(rails_command)

      shell_command = "#{RAILS_RUNNER_ENV} bundle exec rails r '#{escaped_rails_command}'"
      escaped_shell_command = escape_single_quotes(shell_command)

      server_command = "cd app/current; bash --login -c '#{escaped_shell_command}'"
      escaped_server_command = escape_single_quotes(server_command)

      result = `ssh #{force_keys} #{user}@#{server} '#{escaped_server_command}' #{debug}`

      $CHILD_STATUS.exitstatus.positive? ? :error : result
    end

    private

    def server_line
      file_grep(/^server/).first
    end

    def name_application_line
      file_grep(/^set :name_application/).first
    end

    def file_grep(pattern)
      File.open(file).grep(pattern)
    end

    # In shell, a ' character within a 'example' argument must be escaped as '"'"
    #
    # :reek:UtilityFunction really need to move to String class?
    def escape_single_quotes(string)
      string.gsub("'", %q('"'"'))
    end

    def force_keys
      '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' if ENV['force_keys']
    end

    def debug
      '2>/dev/null' if !ENV['debug']
    end
  end
end
