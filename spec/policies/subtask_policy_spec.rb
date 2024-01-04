require 'rails_helper'

RSpec.describe SubtaskPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Subtask).resolve
    end

    let!(:other_subtask) { create(:subtask) }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_subtask) }
    end

    context 'when a user' do
      let(:user) { create(:user) }
      let(:list) { create(:list, user: user) }
      let(:task) { create(:task, list: list) }
      let!(:subtask) { create(:subtask, task: task) }

      it { should include(subtask) }
      it { should_not include(other_subtask) }
    end
  end

  describe 'actions' do
    subject { described_class.new(user, subtask) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create(:user) }
    let(:subtask) { create(:subtask) }

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
      let(:task) { create(:task, user: user) }
      let(:subtask) { create(:subtask, task: task) }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end
  end
end
