require 'rails_helper'

RSpec.describe WaitingForPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, WaitingFor).resolve
    end

    let!(:other_waiting_for) { create :waiting_for }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_waiting_for) }
    end

    context 'when a user' do
      let(:user) { create :user }
      let(:waiting_for) { create :waiting_for, user: user }

      it { should include(waiting_for) }
      it { should_not include(other_waiting_for) }
    end
  end

  describe 'permitted_attributes' do
    # TODO: What's the ideal way to test permitted attributes?
    # For reference, see: https://github.com/chrisalley/pundit-matchers#testing-the-mass-assignment-of-attributes-for-particular-actions
  end

  describe 'actions' do
    subject { described_class.new(user, waiting_for) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:waiting_for) { create :waiting_for }

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
      let(:waiting_for) { create :waiting_for, user: user }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end
  end
end
