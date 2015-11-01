module Api
  class PostsController < BaseController

    def index
      @posts = Post.published.recent.limit(10)
    end

    def show
      @post = Post.find params[:id]
    end

    def feed
      @posts = Post.published.recent.limit(200)
      render formats: [:atom], handlers: :builder, layout: false
    end

  end
end
