require 'net/http'

namespace :sitemaps do

  desc 'Notify Google and Bing about new sitemap'
  task :notify => :environment do

    SITEMAP_URL = 'http://www.nick-cherry.com/sitemap.xml'

    uri = URI('http://www.google.com/webmasters/sitemaps/ping')
    uri.query = URI.encode_www_form(sitemap: SITEMAP_URL)
    Net::HTTP.get(uri)

    uri = URI('http://www.bing.com/webmaster/ping.aspx')
    uri.query = URI.encode_www_form(siteMap: SITEMAP_URL)
    Net::HTTP.get(uri)
  end
end
