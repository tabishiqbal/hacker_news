# Purpose of this file is to create the comments for a story
# it will call the service to create the comments in the DB for a story.

module HackerNews
  class CreateStoryCommentsJob < ApplicationJob
    queue_as :default

    # This job will retry 3 times with a 2 minute wait between each retry
    # if the job fails due to a record not found error
    rescue_from(ActiveRecord::RecordNotFound) do |exception|
      retry_job(wait: 2.minutes, retry_count: arguments.last) if arguments.last < 3
    end

    def perform(story_id, retry_count = 0)
      # If the story cannot be found it will raise an ActiveRecord::RecordNotFound error
      story = Story.find(story_id)

      # Exit early if the story doesn't exist or if comments already exist.
      # This is to prevent duplicate comments from being created.
      # However, can be refactored further to ensure that new comments are created...
      return if story.nil? || story.comments.exists?
      
      begin
        # Ensure to pass the DB id of the story to the service
        HackerNewsServices::CreateComments.new(story.id).call
      rescue StandardError => e
        Rails.logger.error "An error occurred: #{e.message}"
      end
    end

    private

      def retry_job(wait:, retry_count:)
        self.class.set(wait: wait).perform_later(*arguments[0...-1], retry_count + 1)
      end
  end
end