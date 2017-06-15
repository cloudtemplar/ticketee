require 'rails_helper'

RSpec.feature "Users can create new projects" do
  scenario "with valid attributes" do
    visit "/"

    click_link "New Project"

    fill_in "Name", with: "Catbook"
    fill_in "Description", with: "Facebook for cats"
    click_button "Create Project"

    expect(page).to have_content "Project has been created."
  end
end