require 'rails_helper'

RSpec.describe TaskPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Task).resolve
    end

    let!(:other_task) { create :task }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_task) }
    end

    context 'when a user' do
      let(:user) { create :user }
      let(:list) { create :list, user: user }
      let(:task) { create :task, list: list }

      it { should include(task) }
      it { should_not include(other_task) }
    end
  end

  describe 'permitted_attributes' do
    # TODO: What's the ideal way to test permitted attributes?
    # For reference, see: https://github.com/chrisalley/pundit-matchers#testing-the-mass-assignment-of-attributes-for-particular-actions
  end

  describe 'actions' do
    subject { described_class.new(user, task) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:task) { create :task }

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
      let(:list) { create :list, user: user }
      let(:task) { create :task, list: list }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end
  end
end
