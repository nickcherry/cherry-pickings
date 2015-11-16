class SitemapsController < ApplicationController
  layout false

  before_filter :set_format

  def sitemap
    @posts = Post.all
  end

protected

  def set_format
    request.format = 'xml'
  end
end
