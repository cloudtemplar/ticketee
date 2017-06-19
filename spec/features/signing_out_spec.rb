require 'rails_helper'

RSpec.feature 'Users can sign in' do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
  end

  scenario 'when providing valid details' do
    visit '/'
    click_link 'Sign out'

    expect(page).to have_content 'Signed out successfully'
    expect(page).to_not have_content "Signed in as #{user.email}"
  end
end
