# frozen_string_literal: true

require "hub/profile/credentials"
require "hub/profile/host"
require "toml-rb"
require "safe_yaml"

module Hub
  module Profile
    # Class with utility/helper methods.
    module Util
      # Constants.
      HUB_CONFIG_FILENAME = "hub"
      HUB_CREDENTIALS_FILENAME = ".hub_credentials"
      HUB_CMD = "hub"
      HUB_VERSION_CMD = "hub version"
      # Configure SafeYAML.
      SafeYAML::OPTIONS[:default_mode] = :safe

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

      def parse_hub_config(hub_config)
        hosts = {}
        hub_config.each do |d, h|
          hosts[d] = Hub::Profile::Host.new(h[0])
        end
        hosts
      end

      def load_hub_config_file(file)
        # Load file.
        data = YAML.load_file(file)
        Hub::Profile::Util.parse_hub_config(data)
      end

      def dump_hub_config(hub_config)
        # TODO: Validate schema.
        hosts = {}
        hub_config.each do |d, h|
          hosts[d] = [h]
        end
        YAML.dump(hosts)
      end

      def dump_hub_config_to_file(hub_config, file)
        data_yaml = Hub::Profile::Util.dump_hub_config(hub_config)
        TTY::File.create_file(file, data_yaml, force: true, verbose: false)
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

      def parse_hub_credentials(hub_credentials)
        profiles = {}
        hub_credentials.each do |p, c|
          profiles[p] = Hub::Profile::Credentials.new(c)
        end
        profiles
      end

      def load_hub_credentials_file(file)
        # Load file.
        data = TomlRB.load_file(file)
        Hub::Profile::Util.parse_hub_credentials(data)
      end

      def dump_hub_credentials(hub_credentials)
        # TODO: Validate schema.
        profiles = {}
        hub_credentials.each do |p, c|
          profiles[p] = c.to_hash
        end
        TomlRB.dump(profiles)
      end

      def dump_hub_credentials_to_file(hub_credentials, file)
        data_toml = Hub::Profile::Util.dump_hub_credentials(hub_credentials)
        TTY::File.create_file(file, data_toml, force: true, verbose: false)
      end

      def host_is_contained_in_hub_credentials?(domain, host, hub_credentials)
        profile = hub_credentials.select do |_, c|
          c.host == domain && c.user == host.user && c.oauth_token == host.oauth_token && c.protocol == host.protocol
        end
        !profile.empty?
      end

      module_function :hub_config_file, :parse_hub_config, :load_hub_config_file,
                      :dump_hub_config, :dump_hub_config_to_file,
                      :hub_credentials_file, :parse_hub_credentials, :load_hub_credentials_file,
                      :dump_hub_credentials, :dump_hub_credentials_to_file,
                      :host_is_contained_in_hub_credentials?
    end
  end
end
