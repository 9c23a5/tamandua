require "http/client"

require "../error"

module Tamandua
  module Discord
    struct WebhookError < Error
      def error_description : String
        "Failed to send message to Discord"
      end
    end

    class WebhookClient
      getter url : URI

      def initialize(@url : URI)
      end

      def send_message(message : String) : Nil | WebhookError
        response = HTTP::Client.post(
          url,
          headers: HTTP::Headers{
            "Content-Type" => "application/json",
            "User-Agent"   => Tamandua::USER_AGENT,
          },
          body: {
            content:          message,
            allowed_mentions: {users: [Configuration.discord_user_id]},
          }.to_json
        )

        return WebhookError.new(response.body) unless response.success?
      end
    end
  end
end
