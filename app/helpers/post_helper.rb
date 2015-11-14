module PostHelper

  def post_path(post)
    File.join 'blog', post.public_id
  end

  def post_url(post)
    File.join root_url, post_path(post)
  end
end
