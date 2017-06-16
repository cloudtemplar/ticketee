require 'rails_helper'

RSpec.feature 'Users can delete projects' do
  scenario 'successfully' do
    FactoryGirl.create(:project, name: 'Catbook')

    visit '/'
    click_link 'Catbook'
    click_link 'Delete Project'

    expect(page).to have_content 'Project has been deleted'
    expect(page.current_url).to eq projects_url
    expect(page).to have_no_content 'Catbook'
  end
end
