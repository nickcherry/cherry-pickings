require 'rails_helper'
include PostHelper

describe SitemapsController, type: :controller do
  render_views

  describe 'GET sitemap.xml' do

    def sitemap_node(url_regex)
      response_xml['urlset']['url'].find {|node| node['loc'] =~ url_regex }
    end

    let!(:posts) { 3.times {|i| FactoryGirl.create(:post, title: "Post #{ i }") } }
    let(:response_xml) { Hash.from_xml(response.body) }
    let(:response) { get 'sitemap' }

    it { expect(response.status).to eq 200 }
    it 'should render a sitemap' do
      expect(sitemap_node(/\/blog$/)).to be_present
      Post.all.each do |post|
        expect(sitemap_node(Regexp.new(post_path(post)))).to be_present
      end
    end

  end
end
