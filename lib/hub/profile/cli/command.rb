# frozen_string_literal: true

require "hub/profile/version"
require "hub/profile/util"
require "tty/file"
require "tty/which"
require "tty/command"
require "tty/prompt"

module Hub
  module Profile
    module CLI
      # Module that contains methods to include and reuse across command instances.
      module Command
        def print_hub_version(prompt)
          if TTY::Which.exist?(Hub::Profile::Util::HUB_CMD)
            cmd = TTY::Command.new(:printer => :quiet)
            cmd.run(Hub::Profile::Util::HUB_VERSION_CMD)
          else
            prompt.say "Error: hub command not found"
          end
        end

        def print_hub_profile_version(prompt)
          prompt.say "hub-profile version #{Hub::Profile::VERSION}"
        end

        def print_profiles_in_hub_credentials(prompt, hub_credentials)
          hub_credentials.each_key do |p|
            prompt.say p.to_s
          end
        end

        def print_error_and_exit(prompt, exception)
          prompt.say "Error: #{exception.message}"
          exit 1
        end

        def print_hub_credentials_parse_error_and_exit(prompt, exception)
          prompt.say "Error: Unable to parse hub credentials\n#{exception.message}"
          exit 1
        end
      end
    end
  end
end
