require 'rails_helper'

RSpec.feature 'Users can edit existing projects' do
  let!(:project) { FactoryGirl.create(:project, name: 'Catbook') }

  before do
    visit '/'
    click_link 'Catbook'
    click_link 'Edit Project'
  end

  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Kittybook'
    click_button 'Update Project'

    expect(page).to have_content 'Project has been updated.'
    expect(page.current_url).to eq project_url(project)
    expect(page).to have_content 'Kittybook'
  end

  scenario 'when passing invalid attributes' do
    fill_in 'Name', with: ""
    click_button "Update Project"

    expect(page).to have_content "Project has not been updated."
  end
end
