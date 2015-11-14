SitemapGenerator::Interpreter.send :include, PostHelper

SitemapGenerator::Sitemap.default_host = 'http://www.nick-cherry.com'
SitemapGenerator::Sitemap.create do
  add '/blog', changefreq: :daily, priority: 1
  Post.all.each do |post|
    path = post_path(post)
    add path, changefreq: :daily, priority: 0.5
  end
end
