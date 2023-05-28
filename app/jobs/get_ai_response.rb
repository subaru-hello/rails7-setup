# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

class GetAiResponse
  include Sidekiq::Worker

  def perform(chat_id)
    chat = Chat.find(chat_id)
    call_openai(chat)
  end

  private

  def call_openai(chat)
    uri = URI.parse("https://api.openai.com/v1/chat/completions")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    # request["Authorization"] = "Bearer #{ENV.fetch('OPENAI_ACCESS_TOKEN')}"
    request["Authorization"] = "Bearer #{ENV['OPENAI_ACCESS_TOKEN']}"
    request.body = JSON.dump({
                               "model" => "gpt-3.5-turbo",
                               "messages" => [{ "role" => "user", "content" => chat.messages.last.content }],
                               "temperature" => 0.1
                             })

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    data = JSON.parse(response.body)
    Rails.logger.info "-------------------------------OpenAI response: #{data}"

    ai_message = if data["choices"]
                   data["choices"].first["message"]["content"]
                 else
                   "データを取得できませんでした"
                 end
    chat.messages.create(role: "assistant", content: ai_message)
  end
end
