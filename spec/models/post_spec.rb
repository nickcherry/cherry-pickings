require 'rails_helper'

RSpec.describe Post, type: :model do

  it { should validate_presence_of :public_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body_markdown }
  it { should have_many :tags }

  describe '#published_at' do
    context 'post is not published' do
      let(:post) { FactoryGirl.create(:post, published: false) }

      it 'should be updated to the current time when published' do
        expect{
          post.update published: true
        }.to change {
          post.published_at.try(:to_date)
        }.from(nil).to(Time.now.utc.to_date)
      end
    end

    context 'post was published last week' do
      let(:post) { FactoryGirl.create(:post, published_at: Time.now - 7.days) }

      it 'should not be updated on save' do
        expect{
          post.update published: true
        }.not_to change { post.published_at }
      end

      it 'should be nilified when unpublished' do
        expect{
          post.update published: false
        }.to change { post.published_at }.to(nil)
      end
    end
  end

  describe '#body_html' do
    let(:post) { FactoryGirl.create(:post, body_markdown: "Welcome!") }

    it 'should be generated on create' do
      expect(post.body_html).to match(%r{<p>Welcome!</p>})
    end
    it 'should be updated when the body markdown changes' do
      post.update body_markdown: 'Greetings!'
      expect(post.body_html).to match(%r{<p>Greetings!</p>})
    end
  end

  describe '#public_id' do
    let(:post) { FactoryGirl.create(:post, public_id: 'In 2001, Björk Guðmundsdóttir was writing    Pagan Poetry!')}

    it 'should dasherize the public id on save' do
      expect(post.public_id).to eq 'in-2001-bjork-gudmundsdottir-was-writing-pagan-poetry'
      post.update public_id: 'bjork_bjork!@#$%^&*()+='
      expect(post.public_id).to eq 'bjork_bjork'
    end
  end
end
