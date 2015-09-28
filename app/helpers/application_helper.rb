module ApplicationHelper

  def post_url(post)
    File.join(root_url, 'posts', post.id.to_s)
  end

end
