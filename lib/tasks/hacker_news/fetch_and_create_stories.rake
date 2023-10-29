namespace :hacker_news do
  desc "Fetch top stories and comments from Hacker News and save to the database."
  task fetch_and_create_stories: :environment do
    begin
      Rails.logger.info "Fetching top 10 stories from Hacker News..."

      stories_data_response = HackerNewsServices::GetTopStories.call
      
      if stories_data_response.success?
        top_10_stories_data = stories_data_response.payload.first(10)

        # Don't want to create new stories if the array is empty.
        return unless top_10_stories_data.present?
        
        Rails.logger.info "Creating stories in the database..."
        
        ActiveRecord::Base.transaction do
          result = HackerNewsServices::CreateStories.new(top_10_stories_data).call

          if result.success?
            top_stories = result.stories
      
            # Just need the id's for the next step
            top_stories_ids = top_stories.map(&:id)

            Rails.logger.info "Fetching and creating comments for each story..."
            top_stories_ids.each do |id|
              # We can put this in a job as there will be more comments per story
              HackerNews::CreateStoryCommentsJob.perform_later(id)
            end
          else
            Rails.logger.error "An error occurred: #{result.message}"
          end
        end

      else
        Rails.logger.warn "No stories data returned from Hacker News."
      end
    rescue StandardError => e
      Rails.logger.error "Exception occurred: #{e.message}. Backtrace: #{e.backtrace.join("\n")}"
    end
  end
end
