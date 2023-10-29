class StoriesController < ApplicationController
  def index
  end

  def show
    @story = Story.find(params[:id])
  end

  def top_stories
    if Story.any?
      @top_10_stories = fetch_top_stories
    else
      # On initial load no stories will be in the DB, so fetch from API
      fetch_and_create_stories_from_api
    end
  end

  def comments
    # Can be refactored if there are no comments and you want to check 
    # if new comments have been added since adding story to DB
    @story = Story.find(params[:id])

    sleep 0.5
    @comments = @story.comments.where.not(body: nil)
  end

  private

  def fetch_top_stories
    sleep 0.5 # Used to show skeleton on index page. Remove if not needed
    Story.order(created_at: :asc).limit(10)
  end

  def fetch_and_create_stories_from_api
    stories_data_response = HackerNewsServices::GetTopStories.call

    if stories_data_response.success?
      # only take the first 10 stories
      top_10_stories_data = stories_data_response.payload.first(10)
      result = HackerNewsServices::CreateStories.new(top_10_stories_data).call

      if result.success?
        handle_successful_story_creation(result)
      else
        handle_failed_story_creation(result)
      end
    else
      render turbo_stream: turbo_stream.replace("top-stories", partial: "stories/error", locals: { message: stories_data_response.message })
    end
  end

  def handle_successful_story_creation(result)
    @top_10_stories = result.stories

    # For each story, call a separate job to get the comments
    @top_10_stories.each do |story|
      HackerNews::CreateStoryCommentsJob.perform_later(story.id)
    end

    # Replace the top-stories frame with the partial
    render turbo_stream: turbo_stream.replace("top-stories", partial: "stories/stories", locals: { top_10_stories: @top_10_stories })
  end

  def handle_failed_story_creation(result)
    # Handle error by updating the turbo_stream and showing a message
    render turbo_stream: turbo_stream.replace("top-stories", partial: "stories/error", locals: { message: result.message })
  end
end