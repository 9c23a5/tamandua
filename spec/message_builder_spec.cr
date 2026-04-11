require "./spec_helper.cr"
require "../src/message_builder.cr"

describe Tamandua::MessageBuilder do
  describe ".from_appointments" do
    it "builds a message with each appointment's date and tags user" do
      appointments = [
        Tamandua::Appointment.new(Time.utc(2026, 1, 1, 9, 50, 30)),
        Tamandua::Appointment.new(Time.utc(2026, 1, 3, 15, 30, 0)),
        Tamandua::Appointment.new(Time.utc(2026, 1, 7, 16, 0, 0)),
      ]
      message = Tamandua::MessageBuilder.from_appointments(appointments)

      message.should eq(
        "Available appointments:\n" +
        "- 2026-01-01 09:50:30 UTC\n" +
        "- 2026-01-03 15:30:00 UTC\n" +
        "- 2026-01-07 16:00:00 UTC\n" +
        ":cat2: There may be a new appointment <@sample_user_id>"
      )
    end

    context "with an empty string" do
      it "infroms there's no appointments" do
        appointments = [] of Tamandua::Appointment
        message = Tamandua::MessageBuilder.from_appointments(appointments)

        message.should eq(
          "No appointments available"
        )
      end
    end
  end
end
