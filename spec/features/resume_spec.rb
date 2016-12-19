require 'rails_helper'

describe 'Resume', type: :feature, js: true do
  before(:each) { visit '/resume' }

  it 'renders the content and handles the back button correctly' do
    expect(page).to have_content 'Résumé'
    click_link 'Cherry Pickings'
    expect(current_path).to eq '/blog'
    expect(page).to have_content 'Coming soon!'
    page.evaluate_script 'window.history.back()'
    expect(current_path).to eq '/resume'
    expect(page).to have_content 'Résumé'
  end
end
