module ApplicationHelper

  def post_url(post)
    File.join(root_url, 'blog', post.public_id)
  end

end
