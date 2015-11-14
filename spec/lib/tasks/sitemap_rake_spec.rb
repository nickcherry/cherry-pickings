require 'rails_helper'
include PostHelper

describe 'sitemap:refresh' do

  let!(:posts) { 3.times {|i| FactoryGirl.create(:post, title: "Post #{ i }") } }

  let(:expected_path) { File.join(Rails.root, 'public', 'sitemap.xml.gz') }
  let(:sitemap) { Hash.from_xml ActiveSupport::Gzip.decompress(File.read(expected_path)) }
  let!(:google_req) { stub_request(:get, %r{http://www.google.com/webmasters/tools/ping}).to_return(status: 200) }
  let!(:bing_req) { stub_request(:get, %r{http://www.bing.com/webmaster/ping.aspx}).to_return(status: 200) }

  def sitemap_node(url_regex)
    sitemap['urlset']['url'].find {|node| node['loc'] =~ url_regex }
  end

  it 'generates a sitemap' do
    rake 'sitemap:refresh', '-s'
    expect(File).to exist(expected_path)
    expect(sitemap_node(/\/blog$/)).to be_present
    Post.all.each do |post|
      expect(sitemap_node(Regexp.new(post_path(post)))).to be_present
    end
    expect(google_req).to have_been_made.once
    expect(bing_req).to have_been_made.once
  end

end
