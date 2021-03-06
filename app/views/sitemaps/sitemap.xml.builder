xml.instruct!
xml.urlset(
  'xmlns'.to_sym => "http://www.sitemaps.org/schemas/sitemap/0.9",
  'xmlns:image'.to_sym => "http://www.google.com/schemas/sitemap-image/1.1"
) do

  xml.url do
    xml.loc root_url
    xml.changefreq 'daily'
    xml.priority 1
  end

  xml.url do
    xml.loc "#{ root_url }blog"
    xml.changefreq 'daily'
    xml.priority 1
  end

  xml.url do
    xml.loc "#{ root_url }resume"
    xml.changefreq 'monthly'
    xml.priority 1
  end

  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.strftime("%F")
      xml.changefreq 'weekly'
      xml.priority 0.5
      if post.image?
        xml.image :image do
          xml.image :loc, asset_url(post.image)
        end
      end
    end
  end
end
