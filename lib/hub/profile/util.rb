# frozen_string_literal: true

require "hub/profile/credentials"
require "toml-rb"

module Hub
  module Profile
    # Class with utility/helper methods.
    module Util
      HUB_CONFIG_FILENAME = "hub"
      HUB_CREDENTIALS_FILENAME = ".hub_credentials"

      # As per hub's documentation, the configuration file path is first determined by
      # the HUB_CONFIG environment variable. Else, if $XDG_CONFIG_HOME is present, the
      # default is $XDG_CONFIG_HOME/hub; otherwise it's $HOME/.config/hub.
      def hub_config_file
        if ENV["HUB_CONFIG"]
          File.expand_path(ENV["HUB_CONFIG"])
        elsif ENV["XDG_CONFIG_HOME"]
          File.expand_path(HUB_CONFIG_FILENAME, ENV["XDG_CONFIG_HOME"])
        elsif ENV["HOME"]
          File.expand_path(HUB_CONFIG_FILENAME, "#{ENV['HOME']}/.config")
        else
          File.expand_path(HUB_CONFIG_FILENAME, "~/.config")
        end
      end

      # Keeping the .hub_credentials file in the same path as hub's config.
      def hub_credentials_file
        if ENV["HUB_CONFIG"]
          hub_config_dir = File.dirname(File.expand_path(ENV["HUB_CONFIG"]))
          File.expand_path(HUB_CREDENTIALS_FILENAME, hub_config_dir)
        elsif ENV["XDG_CONFIG_HOME"]
          File.expand_path(HUB_CREDENTIALS_FILENAME, ENV["XDG_CONFIG_HOME"])
        elsif ENV["HOME"]
          File.expand_path(HUB_CREDENTIALS_FILENAME, "#{ENV['HOME']}/.config")
        else
          File.expand_path(HUB_CREDENTIALS_FILENAME, "~/.config")
        end
      end

      def load_hub_credentials_file(file)
        # Load file.
        c = TomlRB.load_file(file)
        Hub::Profile::Util.parse_hub_credentials(c)
      end

      def parse_hub_credentials(hub_credentials)
        hub_profiles = {}
        hub_credentials.each do |p, c|
          hub_profiles[p] = Hub::Profile::Credentials.new(c)
        end
        hub_profiles
      end

      module_function :hub_config_file, :hub_credentials_file,
                      :load_hub_credentials_file, :parse_hub_credentials
    end
  end
end
