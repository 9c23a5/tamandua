require "http"
require "json"
require "dotenv/load"

EXPECTED_KEYS = %w[morning lunch afternoon]

$http = HTTP.headers(
  content_type: "application/json",
  user_agent: "tamandua/0.1 (Ruby #{RUBY_VERSION})"
).accept(:json)

def webhook(message, error: false)
  message = ":warning: #{message} <@#{user_id}>" if error
  $http.post(
    webhook_url,
    body: { content: message, allowed_mentions: { users: [user_id] }}.to_json
  )
end

def build_message(data)
  unless data.keys.all? { EXPECTED_KEYS.include?(it) }
    return webhook("Unexpected keys: #{data.keys}", error: true)
  end

  $ping_user = false

  message = "Available appointments:\n"
  EXPECTED_KEYS.each do |key|
    message += "- #{key.capitalize}: "

    times = data.dig(key, "times") || []
    if times.empty?
      message << "No appointments available\n"
    else
      $ping_user = true
      message += times.map do |time_object|
        "#{safe_parse(time_object["time"]).to_time.to_s} (unix: #{time_object["timestamp"]})"
      end.join(", ") + "\n"
    end
  end

  $ping_user ? "#{message}\n:cat2: There may be a new appointment <@#{user_id}>!" : message
end

def safe_parse(date_string)
  DateTime.parse(date_string)
rescue ArgumentError
  date_string
end

def in_custom_unix_time(date_time)
  # Aklepios uses some weird unix timestamp where it has three extra digits?
  # We're gonna add 000 at the end to match their format

  "#{date_time.to_time.to_i}000"
end

def from_custom_unix_time(custom_unix_time)
  Time.at(custom_unix_time.to_i / 1000).to_time
end

def webhook_url = ENV["WEBHOOK_URL"] || raise("WEBHOOK_URL environment variable is not set")

def user_id = ENV["USER_ID"] || raise("USER_ID environment variable is not set")

response = $http.get(
  "https://www.asklepios.com/details/sprechstunde/samediRenderer/content/0/fieldsets/09/fields/0/fields/teaser.json",
  params: {
    q: "teaser",
    from: in_custom_unix_time(DateTime.now),
    to: in_custom_unix_time(DateTime.now.next_year),
    insurance_id: "public",
    event_category_id: 178737,
    event_type_id: 468279
  }
)

if response.status.success?
  begin
    data = JSON.parse(response.body.to_s)
    webhook(build_message(data))
  rescue JSON::ParserError => e
      webhook("Failed to parse JSON: #{e.message}", error: true)
  end
else
  webhook("Failed to fetch data: #{response.status}", error: true)
end
