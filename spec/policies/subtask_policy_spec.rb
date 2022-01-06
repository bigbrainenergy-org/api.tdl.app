require 'rails_helper'

RSpec.describe SubtaskPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Subtask).resolve
    end

    let!(:other_subtask) { create :subtask }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_subtask) }
    end

    context 'when a user' do
      let(:user) { create :user }
      let(:next_action) { create :next_action, user: user }
      let(:subtask) { create :subtask, next_action: next_action }

      it { should include(subtask) }
      it { should_not include(other_subtask) }
    end
  end

  describe 'permitted_attributes' do
    # TODO: What's the ideal way to test permitted attributes?
    # For reference, see: https://github.com/chrisalley/pundit-matchers#testing-the-mass-assignment-of-attributes-for-particular-actions
  end

  describe 'actions' do
    subject { described_class.new(user, subtask) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:subtask) { create :subtask }

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
      let(:next_action) { create :next_action, user: user }
      let(:subtask) { create :subtask, next_action: next_action }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end
  end
end
