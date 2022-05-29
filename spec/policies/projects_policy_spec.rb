require 'rails_helper'

RSpec.describe ProjectPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Project).resolve
    end

    let!(:other_project) { create :project }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_project) }
    end

    context 'when a user' do
      let(:user) { create :user }
      let(:project) { create :project, user: user }

      it { should include(project) }
      it { should_not include(other_project) }
    end
  end

  describe 'permitted_attributes' do
    # TODO: What's the ideal way to test permitted attributes?
    # For reference, see: https://github.com/chrisalley/pundit-matchers#testing-the-mass-assignment-of-attributes-for-particular-actions
  end

  describe 'actions' do
    subject { described_class.new(user, project) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:project) { create :project }

    context 'when a visitor' do
      let(:user) { nil }

      it { should forbid_action(:index) }
      it { should forbid_actions(crud_actions) }
    end

    context 'when another user' do
      it { should permit_action(:index) }
      it { should forbid_actions(crud_actions) }
    end

    context 'when the record user' do
      let(:project) { create :project, user: user }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end
  end
end
