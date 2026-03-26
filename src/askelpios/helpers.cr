module Tamandua
  module Askelpios
    module DateFormatter
      def self.from_json(pull : JSON::PullParser) : Time
        Time.unix_ms(pull.read_string.to_i64)
      end

      def self.to_uri(value : Time) : String
        value.to_unix_ms.to_s
      end
    end
  end
end
