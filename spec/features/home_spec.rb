require 'rails_helper'

describe 'Homepage', type: :feature, js: true do
  before(:each) do
    FactoryGirl.create(:post, title: 'Hola Mundo', body_markdown: 'Lorem Españolum', tags: [FactoryGirl.create(:tag, name: 'spanish')], published_at: Time.now.utc - 1.day )
    FactoryGirl.create(:post, title: 'Hello World', body_markdown: 'Lorem Englishum', tags: [FactoryGirl.create(:tag, name: 'english')], published_at: Time.now.utc)
    FactoryGirl.create(:post, title: '你好，世界', body_markdown: 'Lorem 中国um', tags: [FactoryGirl.create(:tag, name: 'chinese')], published_at: Time.now.utc + 1.day)
    visit '/'
  end

  it 'renders the navigation' do
    expect(page).to have_content 'Cherry Pickings'
  end

  it 'renders the posts, sorted by most recently published' do
    def find_post(child)
      page.find(".list-post:nth-of-type(#{ child })")
    end

    within find_post(1) do
      expect(page).to have_content '你好，世界'
      expect(page).to have_content '#chinese'
    end

    within find_post(2) do
      expect(page).to have_content 'Hello World'
      expect(page).to have_content '#english'
    end

    within find_post(3) do
      expect(page).to have_content 'Hola Mundo'
      expect(page).to have_content '#spanish'
    end
  end

  it 'links to posts' do
    click_link 'Hello World'
    expect(current_path).to eq('/blog/hello-world')
    expect(page).to have_content 'Lorem Englishum'
    expect(page).to have_content '#english'
  end
end
