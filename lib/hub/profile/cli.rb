# frozen_string_literal: true

require "hub/profile/cli/command"
require "dry/cli"

module Hub
  module Profile
    # Main module containing CLI commands.
    module CLI
      extend Dry::CLI::Registry

      # List command.
      class List < Dry::CLI::Command
        include Hub::Profile::CLI::Command

        desc "List profiles"

        def call(*)
          prompt = TTY::Prompt.new
          # Load '.hub_credentials' file.
          hub_credentials_file = Hub::Profile::Util.hub_credentials_file
          hub_credentials = Hub::Profile::Util.load_hub_credentials_file(hub_credentials_file)
          # Print profiles found in '.hub_credentials'.
          print_profiles_in_hub_credentials(prompt, hub_credentials)
        rescue TomlRB::ParseError, Dry::Struct::Error => e
          # TomlRB::ParseError - Expected if an error occurs when parsing '.hub_credentials'.
          # Dry::Struct::Error - Expected if attributes from a profile don't match the credentials schema.
          print_hub_credentials_parse_error_and_exit(prompt, e)
        rescue SystemCallError, IOError, TomlRB::ParseError => e
          # Errno::ENOENT - Not such file or directory.
          # Errno::EACCES - Permission denied.
          print_error_and_exit(prompt, e)
        end
      end

      # Version command.
      class Version < Dry::CLI::Command
        include Hub::Profile::CLI::Command

        desc "Print version"

        def call(*)
          prompt = TTY::Prompt.new
          print_hub_version(prompt)
          print_hub_profile_version(prompt)
        end
      end
    end
  end
end
