ENV["DISCORD_WEBHOOK_URI"] = "https://discord.com/api/webhooks/channel_id/secret"
ENV["USER_ID"] = "sample_user_id"

require "spec"

# require "../src/tamandua"

def load_fixture(filename : String) : String
  File.read("spec/fixtures/#{filename}")
end
