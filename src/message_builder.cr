require "./appointment"
require "./configuration"

module Tamandua
  module MessageBuilder
    def self.from_appointments(appointments : Array(Appointment)) : String
      if appointments.empty?
        "No appointments available"
      else
        "Available appointments:\n" + appointments.map { |appointment| "- #{appointment.date}" }.join("\n") +
          "\n:cat2: There may be a new appointment" +
          (Configuration.discord_user_id ? " <@#{Configuration.discord_user_id}>" : "")
      end
    end
  end
end
