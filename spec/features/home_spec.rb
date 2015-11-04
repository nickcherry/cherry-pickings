require 'rails_helper'

describe 'Homepage', type: :feature, js: true do
  describe 'GET #index' do

    before :all do
      FactoryGirl.create(:post, title: 'Hola Mundo', body_markdown: 'Lorem Españolum', tags: [FactoryGirl.create(:tag, name: 'spanish')], published_at: Date.yesterday )
      FactoryGirl.create(:post, title: 'Hello World', body_markdown: 'Lorem Englishum', tags: [FactoryGirl.create(:tag, name: 'english')], published_at: Date.today)
      FactoryGirl.create(:post, title: '你好，世界', body_markdown: 'Lorem 中国um', tags: [FactoryGirl.create(:tag, name: 'chinese')], published_at: Date.tomorrow)
    end

    before(:each) { visit '/' }

    it 'renders the navigation' do
      expect(page).to have_content 'Cherry Pickings'
    end

    it 'renders the posts, sorted by most recently published' do
      def find_post(child)
        page.find(".post:nth-of-type(#{ child })")
      end

      within find_post(1) do
        expect(page).to have_content '你好，世界'
        expect(page).to have_content 'Lorem 中国um'
        expect(page).to have_content '#chinese'
      end

      within find_post(2) do
        expect(page).to have_content 'Hello World'
        expect(page).to have_content 'Lorem Englishum'
        expect(page).to have_content '#english'
      end

      within find_post(3) do
        expect(page).to have_content 'Hola Mundo'
        expect(page).to have_content 'Lorem Españolum'
        expect(page).to have_content '#spanish'
      end
    end

    it 'links to posts' do
      click_link 'Hola Mundo'
      expect(current_path).to eq('/blog/hola-mundo')
    end
  end
end
