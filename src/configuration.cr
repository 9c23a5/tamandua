require "uri"

module Tamandua
  module Configuration
    class MissingEnvException < Exception
      def initialize(var_name : String)
        super("The following environment variable is not set: #{var_name}")
      end
    end

    def self.discord_webhook_uri : URI
      URI.parse(ENV["WEBHOOK_URL"]? || raise(MissingEnvException.new("WEBHOOK_URL")))
    end

    def self.discord_user_id : String | Nil
      ENV["USER_ID"]?
    end
  end
end
