# Purpose of this file is to create the stories in the DB
# it expects to receive an array of ids.

module HackerNews
  class CreateStoriesJob < ApplicationJob
    queue_as :default

    def perform(stories_data)
      begin
        HackerNewsServices::CreateStories.new(stories_data).call
      rescue StandardError => e
        Rails.logger.error "An error occurred: #{e.message}"
      end
    end
  end
end