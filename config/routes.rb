Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  if defined?(Sidekiq)
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end


  resources :stories, only: [:index, :show]
  get "/top-stories" => "stories#top_stories", as: :top_stories
  get "/story/:id/comments" => "stories#comments", as: :story_comments

  # Defines the root path route ("/")
  root "stories#index"
end
