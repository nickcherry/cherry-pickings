require 'rails_helper'

describe 'sitemaps:notify' do

  let(:sitemap_url) { 'http://www.nick-cherry.com/sitemap.xml' }

  let!(:google_request) { stub_request(:get, %r{http://www.google.com/webmasters/sitemaps/ping}).
    with(query: { sitemap: sitemap_url }).to_return(status: 200)
  }

  let!(:bing_request) { stub_request(:get, %r{http://www.bing.com/webmaster/ping.aspx}).
    with(query: { siteMap: sitemap_url }).to_return(status: 200)
  }

  it 'notifies Google and Bing about the sitemap' do
    rake 'sitemaps:notify'
    expect(google_request).to have_been_made.once
    expect(bing_request).to have_been_made.once
  end

end
