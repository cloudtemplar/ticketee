require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it 'gets destroyed if its parent Project is destroyed' do
    author = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    FactoryGirl.create(:ticket, project: project, author: author)

    expect { project.destroy }.to change { Ticket.count }.by(-1)
  end
end
