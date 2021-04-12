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
      let(:task) { create :task, user: user }

      it { should include(task) }
      it { should_not include(other_task) }
    end
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
      it { should forbid_action(:sync_ordering) }
    end

    context 'when another user' do
      it { should permit_action(:index) }
      it { should forbid_actions(crud_actions) }
      it { should permit_action(:sync_ordering) }
    end

    context 'when the record user' do
      let(:task) { create :task, user: user }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
      it { should permit_action(:sync_ordering) }
    end
  end
end
