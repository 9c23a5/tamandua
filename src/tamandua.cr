require "./askelpios/client"
require "./askelpios/parser"

require "./appointment"
require "./configuration"
require "./discord/notifier"
require "./message_builder"

module Tamandua
  VERSION    = "0.1.0"
  USER_AGENT = "tamandua/#{VERSION} (Crystal #{Crystal::VERSION})"

  response = Askelpios::Client.get_appointments
  handle_error(response) if response.is_a?(Askelpios::FetchError)

  appointments = Askelpios::Parser.new(response).appointments

  handle_error(appointments) if appointments.is_a?(Askelpios::ParseError)

  message = MessageBuilder.from_appointments(appointments)

  res = Discord::Notifier.notify(message)

  handle_error(res) if res.is_a?(Discord::WebhookError)

  def self.handle_error(error : Error)
    response = Discord::Notifier.notify(":warning: #{error.message} <@#{Configuration.discord_user_id}>")

    failsafe_error(error, response) if response.is_a?(Discord::WebhookError)

    exit 1
  end

  def self.failsafe_error(original_error : Error, notification_error : Error)
    raise("Failed to notify discord of error #{original_error.message}. Response from discord: #{notification_error.message}")
  end
end
