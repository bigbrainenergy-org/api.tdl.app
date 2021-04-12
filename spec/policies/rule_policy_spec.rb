require 'rails_helper'

RSpec.describe RulePolicy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, Rule).resolve
    end

    let!(:other_rule) { create :rule }

    context 'when a visitor' do
      let(:user) { nil }

      it { should_not include(other_rule) }
    end

    context 'when a user' do
      let(:user) { create :user }
      let(:pre) { create :task, user: user }
      let(:post) { create :task, user: user }
      let(:rule) { create :rule, pre: pre, post: post }

      it { should include(rule) }
      it { should_not include(other_rule) }
    end
  end

  describe 'actions' do
    subject { described_class.new(user, rule) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:rule) { create :rule }

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
      let(:pre) { create :task, user: user }
      let(:post) { create :task, user: user }
      let(:rule) { create :rule, pre: pre, post: post }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end

    context 'when two different users' do
      let(:pre) { create :task, user: user }
      let(:post) { create :task }
      let(:rule) { create :rule, pre: pre, post: post }

      it { should permit_action(:index) }
      it { should forbid_actions(crud_actions) }
    end
  end
end
