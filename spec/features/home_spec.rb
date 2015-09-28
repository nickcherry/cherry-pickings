require 'rails_helper'

describe 'Homepage', type: :feature, js: true do
  describe 'GET #index' do
    it 'renders the page' do
      visit '/'
      expect(page).to have_content 'Cherry Pickings'
    end
  end
end
