require 'rails_helper'

describe Api::PostsController, type: :controller do
  render_views

  describe 'GET #index' do

    def random_published_at
      Time.now - rand(0..20).days
    end

    def published_at(post_json)
      DateTime.parse(post_json['published_at'])
    end

    let!(:posts) { 15.times.map { FactoryGirl.create(:post, published_at: random_published_at) }}
    let(:response_json) { JSON.parse(response.body) }
    let(:response) { get :index }

    it { expect(response.status).to eq 200 }
    it 'should return the 10 most recently published posts' do
      expect(response_json.count).to eq(10)
      response_json.reduce(Date.tomorrow) do |last_published_at, post_json|
        published_at(post_json).tap do |published_at|
          expect(published_at).to be <= last_published_at
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:post) { FactoryGirl.create(:post) }
    let(:response_json) { JSON.parse(response.body) }
    let(:response) { get :show, id: post.public_id }
    it { expect(response.status).to eq 200 }
    it 'should return the post' do
      expect(response_json['title']).to eq post.title
      expect(response_json['body_html']).to eq post.body_html
      expect(response_json['tags']).to be_a_kind_of(Array)
    end
  end

  describe 'GET #feed' do
    let!(:post) { FactoryGirl.create(:post) }
    let(:response_xml) { Hash.from_xml(response.body) }
    let(:response) { get :feed }
    it 'should include the post information' do
      feed = response_xml['feed']
      expect(feed['title']).to eq 'Cherry Pickings'
      entry = feed['entry']
      expect(entry['author']['name']).to eq 'Nick Cherry'
      expect(entry['title']).to eq post.title
      expect(entry['content']).to eq post.body_html
      expect(entry['link']['href']).to eq "#{ base_url }/blog/#{ post.public_id }"
    end
  end
end
