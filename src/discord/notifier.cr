require "./webhook_client"

module Tamandua
  module Discord
    class Notifier
      def self.notify(message : String)
        client.send_message(message)
      end

      private def self.client : WebhookClient
        WebhookClient.new(Configuration.discord_webhook_uri)
      end
    end
  end
end
