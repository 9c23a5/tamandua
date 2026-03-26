require "http/client"

require "./helpers"
require "../error"

module Tamandua
  module Askelpios
    struct FetchError < Error
      def error_description : String
        "Failed to fetch appointments from Asklepios"
      end
    end

    class Client
      def self.get_appointments : String | FetchError
        asklepios_request_params = URI::Params.encode(
          {
            "q"                 => "teaser",
            "from"              => DateFormatter.to_uri(Time.utc),
            "to"                => DateFormatter.to_uri(Time.utc + 1.year),
            "insurance_id"      => "public",
            "event_category_id" => "178737",
            "event_type_id"     => "468279",
          }
        )

        response = HTTP::Client.get(
          URI.new(
            "https",
            "www.asklepios.com",
            path: "/details/sprechstunde/samediRenderer/content/0/fieldsets/09/fields/0/fields/teaser.json",
            query: asklepios_request_params
          ),
          HTTP::Headers{
            "Accept"       => "application/json",
            "Content-Type" => "application/json",
            "Connection"   => "close",
            "Host"         => "www.asklepios.com",
            "User-Agent"   => Tamandua::USER_AGENT,
          },
        )

        if response.success?
          return response.body
        else
          return FetchError.new(response.body)
        end
      end
    end
  end
end
