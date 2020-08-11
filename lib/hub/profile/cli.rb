# frozen_string_literal: true

require "hub/profile/version"
require "hub/profile/util"
require "dry/cli"
require "tty/which"
require "tty/command"
require "tty/prompt"

module Hub
  module Profile
    # Main module containing CLI commands.
    module CLI
      extend Dry::CLI::Registry

      # List command.
      class List < Dry::CLI::Command
        desc "List profiles"

        def call(*)
          prompt = TTY::Prompt.new
          # Load '.hub_credentials' file.
          hub_credentials_file = Hub::Profile::Util.hub_credentials_file
          hub_profiles = Hub::Profile::Util.load_hub_credentials_file(hub_credentials_file)
          # Print profiles found in '.hub_credentials'.
          hub_profiles.each_key { |p| prompt.say p.to_s }
        rescue TomlRB::ParseError, Dry::Struct::Error => e
          # TomlRB::ParseError - Expected if an error occurs when parsing '.hub_credentials'.
          # Dry::Struct::Error - Expected if attributes from a profile don't match the credentials schema.
          prompt.say "Error: Unable to parse hub credentials\n#{e.message}"
          exit 1
        rescue SystemCallError, IOError, TomlRB::ParseError => e
          # Errno::ENOENT - Not such file or directory.
          # Errno::EACCES - Permission denied.
          prompt.say "Error: #{e.message}"
          exit 1
        end
      end

      # Version command.
      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          prompt = TTY::Prompt.new
          if TTY::Which.exist?("hub")
            cmd = TTY::Command.new(:printer => :quiet)
            cmd.run("hub version")
          else
            prompt.say "Error: hub command not found"
          end
          prompt.say "hub-profile version #{Hub::Profile::VERSION}"
        end
      end
    end
  end
end
