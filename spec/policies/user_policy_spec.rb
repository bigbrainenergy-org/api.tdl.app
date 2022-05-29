require 'rails_helper'

RSpec.describe UserPolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(current_user, User).resolve
    end

    let!(:other_user) { create :user }

    context 'when a visitor' do
      let(:current_user) { nil }

      it { should_not include(other_user) }
    end

    context 'when a user' do
      let(:current_user) { create :user }
      let(:user) { current_user }

      it { should include(user) }
      it { should_not include(other_user) }
    end
  end

  describe 'permitted_attributes' do
    # TODO: What's the ideal way to test permitted attributes?
    # For reference, see: https://github.com/chrisalley/pundit-matchers#testing-the-mass-assignment-of-attributes-for-particular-actions
  end

  describe 'actions' do
    subject { described_class.new(current_user, user) }

    let(:crud_actions) { [:show, :update] }
    let(:current_user) { create :user }
    let(:user) { create :user }

    context 'when a visitor' do
      let(:current_user) { nil }

      it { should forbid_actions(crud_actions) }
    end

    context 'when another user' do
      it { should forbid_actions(crud_actions) }
    end

    context 'when the record user' do
      let(:user) { current_user }

      it { should permit_actions(crud_actions) }
    end
  end
end
