Rails.application.routes.draw do

  namespace :api do
    resources :posts, only: [:index, :show]
  end

  get 'feed', controller: 'api/posts', action: :feed
  get 'sitemap', controller: 'sitemaps', action: :sitemap

  get 'examples/:name/:instance', controller: 'examples', action: :index

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root controller: :home, action: :index
  get '/*path', controller: :home, action: :index

end
