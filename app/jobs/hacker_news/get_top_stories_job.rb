# Purpose of this file is to get the top stories from Hacker News
# it will return an array of integers [123, 456, 789]

module HackerNews
  class GetTopStoriesJob < ApplicationJob
    queue_as :default

    def perform(*args)
      begin
        HackerNewsServices::GetTopStories.call
      rescue StandardError => e
        Rails.logger.error "An error occurred: #{e.message}"
      end
    end
  end
end
