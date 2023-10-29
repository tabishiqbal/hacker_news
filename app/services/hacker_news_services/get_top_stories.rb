# Purpose: Fetches the top stories from the Hacker News API.
# Returns: An array of item ids (type: story).

module HackerNewsServices
  class GetTopStories

    BASE_URL = "https://hacker-news.firebaseio.com/v0"

    def self.call
      # Can be refactored to have OpenStruct
      response = HTTParty.get("#{BASE_URL}/topstories.json")
      # response.parsed_response
      OpenStruct.new(success?: true, payload: response.parsed_response)
    rescue StandardError => e
      Rails.logger.error "An error occurred: #{e.message}"
      OpenStruct.new(success?: false, message: e.message)
    end
  end
end
