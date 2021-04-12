require 'rails_helper'

RSpec.describe ListPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, List).resolve
    end

    let!(:other_list) { create :list }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_list) }
    end

    context 'when a user' do
      let(:user) { create :user }
      let(:list) { create :list, user: user }

      it { should include(list) }
      it { should_not include(other_list) }
    end
  end

  describe 'actions' do
    subject { described_class.new(user, list) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:list) { create :list }

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
      let(:list) { create :list, user: user }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
      it { should permit_action(:sync_ordering) }
    end
  end
end
