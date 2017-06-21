require 'rails_helper'

RSpec.describe AttachmentPolicy do
  context 'permissions' do
    subject { AttachmentPolicy.new(user, attachment) }

    let(:user)       { FactoryGirl.create(:user) }
    let(:project)    { FactoryGirl.create(:project) }
    let(:ticket)     { FactoryGirl.create(:ticket, project: project,
                                      author: FactoryGirl.create(:user)) }
    let(:attachment) { FactoryGirl.create(:attachment, ticket: ticket) }

    context 'for anonymous users' do
      let(:user) { nil }
      it { is_expected.to_not permit_action :show }
    end

    context 'for viewers of the project' do
      before { assign_role!(user, :viewer, project) }
      it { is_expected.to permit_action :show }
    end

    context 'for editors of the project' do
      before { assign_role!(user, :editor, project) }
      it { is_expected.to permit_action :show }
    end

    context 'for managers of the project' do
      before { assign_role!(user, :manager, project) }
      it { is_expected.to permit_action :show }
    end

    context 'for viewers of the project' do
      before do
        assign_role!(user, :viewer, FactoryGirl.create(:project))
      end
      it { is_expected.to_not permit_action :show }
    end

    context 'for administrators' do
      let(:user) { FactoryGirl.create(:user, :admin) }
      it { is_expected.to permit_action :show }
    end
  end
end
