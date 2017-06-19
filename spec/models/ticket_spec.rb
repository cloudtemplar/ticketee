require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it 'gets destroyed if its parent Project is destroyed' do
    project = FactoryGirl.create(:project)
    FactoryGirl.create(:ticket, project: project)

    expect { project.destroy }.to change { Ticket.count }.by(-1)
  end
end
