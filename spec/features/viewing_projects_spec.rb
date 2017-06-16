require 'rails_helper'

RSpec.feature "Users can view projects" do
  scenario "with the project details" do
    project = FactoryGirl.create(:project, name: "Catbook")

    visit '/'
    click_link 'Catbook'
    expect(page.current_url).to eq project_url(project)
  end
end
