# Purpose: Service to create comments for a story

module HackerNewsServices
  class CreateComments

    # Story id is the db id of the story
    def initialize(story_id)
      @story_id = story_id
      @created_comments = []
    end

    def call
      begin
        # find the story in the db
        @story = Story.find(@story_id)
        return if @story.nil?

        # Check if the story already has comments
        # normally you would add more new comments to the story
        return if @story.comments.exists?
        
        # array of item ids (type: comment)
        kids = @story.kids

        kids.each do |comment_id|
          
          # If you were adding more comments to a story...
          # Check if the comment already exists in the DB using the hn_id as a unique identifier
          # next if Comment.exists?(hn_id: comment_id)

          # Fetch the comment from the API - this will be called each time and could be optimized
          response = HackerNewsServices::GetItem.new(comment_id).call

          if response.success?
            item = response.payload
            
            comment = Comment.create(
              story_id: @story_id,
              hn_id: item['id'],
              body: item['text'],
              by: item['by'],
              time: item['time'],
              parent: item['parent']
            )
            @created_comments << comment
          else
            Rails.logger.error "An error occurred: #{response.message}"
          end
        end

        OpenStruct.new(success?: true, comments: @created_comments, message: "Successfully created comments.")
      rescue StandardError => e
        Rails.logger.error "An error occurred: #{e.message}"
        OpenStruct.new(success?: false, comments: [], message: "An error occurred: #{e.message}")
      end
    end
  end
end