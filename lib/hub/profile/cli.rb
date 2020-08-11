# frozen_string_literal: true

require "hub/profile/version"
require "hub/profile/util"
require "dry/cli"
require "tty/which"

module Hub
  module Profile
    # Main module containing CLI commands.
    module CLI
      extend Dry::CLI::Registry

      # List command.
      class List < Dry::CLI::Command
        desc "List profiles"

        def call(*)
          # Check if '.hub_credentials' file exist and contains credentials.
          hub_credentials_file = Hub::Profile::Util.hub_credentials_file
          hub_profiles = Hub::Profile::Util.load_hub_credentials_file(hub_credentials_file)
          hub_profiles.each_key { |p| puts p.to_s }
        rescue TomlRB::ParseError, Dry::Struct::Error => e
          # TomlRB::ParseError
          # Dry::Struct::Error
          puts "Error: Unable to parse hub credentials\n#{e.message}"
          exit 1
        rescue SystemCallError, IOError, TomlRB::ParseError => e
          # Errno::ENOENT - Not such file or directory.
          # Errno::EACCES - Permission denied.
          puts "Error: #{e.message}"
          exit 1
        end
      end

      # Version command.
      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          if TTY::Which.exist?("hub")
            Kernel.system "hub version"
          else
            puts "Error: hub not found"
          end
          puts "hub-profile version #{Hub::Profile::VERSION}"
        end
      end
    end
  end
end
