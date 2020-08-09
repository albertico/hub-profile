# frozen_string_literal: true

require "hub/profile/version"
require "dry/cli"
require "mkmf"

module Hub
  module Profile
    # Main module containing CLI commands.
    module CLI
      extend Dry::CLI::Registry

      # Version command.
      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          if MakeMakefile.find_executable0 "hub"
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
