# frozen_string_literal: true

require "dry-struct"

module Hub
  module Profile
    # Credentials: Represents the credentials associated with a profile.
    class Credentials < Dry::Struct
      # Throw an error when unknown keys provided.
      schema schema.strict
      # Convert string keys to symbols.
      transform_keys(&:to_sym)
      # Attributes.
      attribute :host, Dry.Types::String.default("github.com")
      attribute :user, Dry.Types::String
      attribute :oauth_token, Dry.Types::String
      attribute :protocol, Dry.Types::String.default("https")
    end
  end
end
