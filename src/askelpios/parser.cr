require "../error"
require "../appointment"
require "./response"

module Tamandua
  module Askelpios
    struct ParseError < Error
      def error_description : String
        "Failed to parse JSON"
      end
    end

    class Parser
      def initialize(body : String)
        @body = body
      end

      def appointments : Array(Appointment) | ParseError
        begin
          parsed_response = Response.from_json(@body)

          parsed_response
            .timeslots
            .map do |appointment_data|
              Appointment.new(appointment_data.date)
            end
        rescue ex : ArgumentError | JSON::ParseException
          ParseError.new(ex.message.to_s)
        end
      end
    end
  end
end
