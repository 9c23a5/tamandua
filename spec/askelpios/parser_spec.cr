require "../spec_helper"
require "../../src/askelpios/parser"

describe Tamandua::Askelpios::Parser do
  describe "#appointments" do
    it "parses valid JSON and returns appointments" do
      appointments = Tamandua::Askelpios::Parser.new(load_fixture("askelpios/one_appointment.json")).appointments

      appointments.should be_a(Array(Tamandua::Appointment))
      appointments.as(Array(Tamandua::Appointment)).size.should eq(1)
      appointments.as(Array(Tamandua::Appointment)).first.date.should eq(Time.utc(2025, 3, 25, 10, 15, 30))
    end

    context "with multiple appointments" do
      it "parses all of them" do
        appointments = Tamandua::Askelpios::Parser.new(load_fixture("askelpios/three_appointments.json"))
          .appointments.as(Array(Tamandua::Appointment))

        appointments.size.should eq(3)
        appointments[0].date.should eq(Time.utc(2025, 3, 25, 10, 15, 30))
        appointments[1].date.should eq(Time.utc(2025, 3, 26, 12, 45, 20))
        appointments[2].date.should eq(Time.utc(2025, 3, 27, 16, 20, 0))
      end
    end

    context "with badly formatted json" do
      it "returns a ParseError" do
        Tamandua::Askelpios::Parser.new(load_fixture("askelpios/not_a_json.json"))
          .appointments.should be_a(Tamandua::Askelpios::ParseError)
      end
    end

    context "when input doesn't match schema" do
      it "returns a ParseError" do
        Tamandua::Askelpios::Parser.new(load_fixture("askelpios/invalid_schema.json"))
          .appointments.should be_a(Tamandua::Askelpios::ParseError)
      end
    end

    context "when timestamp can't be converted to i64" do
      it "returns a ParseError" do
        Tamandua::Askelpios::Parser.new(load_fixture("askelpios/appointment_with_invalid_timestamp.json"))
          .appointments.should be_a(Tamandua::Askelpios::ParseError)
      end
    end
  end
end
