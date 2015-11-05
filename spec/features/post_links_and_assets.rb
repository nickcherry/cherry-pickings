require 'rake'
require 'rails_helper'

describe 'Post Links and Assets', type: :feature do

  before do
    load File.join(Rails.root, 'lib', 'tasks', 'posts.rake')
    Rake::Task.define_task(:environment)
    Rake::Task['posts:sync'].invoke
  end

  it 'should all return healthy status codes' do
    expect(Post.count).to be > 0 # sanity check
    Post.all.each do |post|
      URI.extract(post.body_html, ['http', 'https']).each do |link|
        expect(Net::HTTP.get_response(URI(link)).code).to match /^(2|3)/
      end
    end
  end

end
