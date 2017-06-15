require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'is invalid with name shorter than 3 characters' do
    project = Project.new(name: 'Yo', description: 'Random stuff')
    expect(project).to be_invalid
  end
end
