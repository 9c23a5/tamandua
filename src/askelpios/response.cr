require "json"
require "./helpers"

module Tamandua
  module Askelpios
    class AppointmentData
      include JSON::Serializable

      @[JSON::Field(key: "timestamp", converter: DateFormatter)]
      getter date : Time
    end

    class TimeSlot
      include JSON::Serializable

      @[JSON::Field(key: "times")]
      getter appointment_data : Array(AppointmentData)
    end

    class Response
      include JSON::Serializable

      @[JSON::Field(key: "morning")]
      getter morning_times : TimeSlot

      @[JSON::Field(key: "lunch")]
      getter lunch_times : TimeSlot

      @[JSON::Field(key: "afternoon")]
      getter afternoon_times : TimeSlot

      def timeslots
        [morning_times, lunch_times, afternoon_times].map do |timeslot|
          timeslot.appointment_data
        end.flatten
      end
    end
  end
end
