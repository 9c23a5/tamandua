module Tamandua
  abstract struct Error
    property message

    def initialize(@message : String)
    end

    def to_s
      "#{error_description}: #{@message}"
    end

    abstract def error_description : String
  end
end
