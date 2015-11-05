#encoding: UTF-8

atom_feed do |feed|
  feed.title 'Cherry Pickings'
  feed.updated @posts.first.try(:updated_at)
  @posts.each do |post|
    feed.entry post, id: post.public_id, url: post_url(post) do |entry|
      entry.title post.title
      entry.author {|author| author.name('Nick Cherry') }
      entry.content post.body_html, type: 'html'
      if post.image
        entry.link href: asset_url(post.image), rel: 'enclosure', type: 'image'
      end
    end
  end
end
