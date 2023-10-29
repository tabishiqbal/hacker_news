# Stories, comments, jobs, etc are all an item in Hacker News
# depending on what ID you pass in, you will get a different item

module HackerNewsServices
  class GetItem
    def initialize(id)
      @id = id
      @url = "https://hacker-news.firebaseio.com/v0"
    end

    def call
      response = HTTParty.get("#{@url}/item/#{@id}.json")
      OpenStruct.new(success?: true, payload: response.parsed_response, message: "Successfully fetched item.")

    rescue StandardError => e
      Rails.logger.error "An error occurred: #{e.message}"
      OpenStruct.new(success?: false, message: "An error occurred fetching item: #{e.message}")
    end
  end
end