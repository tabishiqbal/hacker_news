module HackerNewsServices
  class CreateStories

    # Expects an array of item ids
    def initialize(payload)
      @payload = payload
      @created_stories = []
    end

    def call
      begin
        Story.transaction do
          @payload.each do |story_id|
            # Check if the story already exists in the DB using the hn_id as a unique identifier
            # index the hn_id column in the DB
            next if Story.exists?(hn_id: story_id)

            # Fetch the story from the API - this will be called each time and could be optimized
            result = HackerNewsServices::GetItem.new(story_id).call

            if result.success?
              item = result.payload
              
              # Create the story in the DB and add it to the array of created stories
              story = Story.create(
                hn_id: item['id'],
                title: item['title'],
                url: item['url'],
                by: item['by'],
                score: item['score'],
                time: item['time'],
                kids: item['kids'] || []
              )

              @created_stories << story
            else
              Rails.logger.error "An error occurred: #{result.message}"
            end
          end
        end
        
        message = @created_stories.empty? ? "No stories created." : "Successfully created stories."
        OpenStruct.new(success?: true, stories: @created_stories, message: message)

      rescue StandardError => e
        Rails.logger.error "An error occurred: #{e.message}"
        OpenStruct.new(success?: false, stories: [], message: "An error occurred: #{e.message}")
      end
    end
  end
end