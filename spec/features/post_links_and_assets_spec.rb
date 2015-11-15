require 'rake'
require 'rails_helper'

describe 'Post internal links and assets', type: :feature, js: true do

  before :each do
    stub_request(:get, /^((?!(localhost|127\.0\.0\.1)).)*$/).to_return(status: 200)
  end

  it 'should all return healthy status codes' do
    rake 'posts:sync'
    expect(Post.count).to be > 0 # sanity check
    Post.all.each do |post|
      URI.extract(post.body_html, ['http', 'https']).each do |link|
        expect(Net::HTTP.get_response(URI(link)).code).to match /^(2|3)/
      end
    end
  end

end
