# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.uri_base = URI.parse("https://api.openai.com/v1/chat/completions") # Optional
  #  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID") # Optional.
end
