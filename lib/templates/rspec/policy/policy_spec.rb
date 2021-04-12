require 'rails_helper'
<% class_string = class_name.to_s.underscore %>
RSpec.describe <%= class_name %>Policy do
  describe 'scope' do
    subject(:resolved_scope) do
      described_class::Scope.new(user, <%= class_name %>).resolve
    end

    let!(:other_<%= class_string %>) { create :<%= class_string %> }

    context 'for a visitor' do
      let(:user) { nil }

      it { should_not include(other_<%= class_string %>) }
    end

    context 'for a user' do
      let(:user) { create :user }
      let(:<%= class_string %>) { create :<%= class_string %>, user: user }

      it { should include(<%= class_string %>) }
      it { should_not include(other_<%= class_string %>) }
    end
  end

  describe 'actions' do
    subject { described_class.new(user, <%= class_string %>) }

    let(:crud_actions) { [:show, :create, :update, :destroy] }
    let(:user) { create :user }
    let(:<%= class_string %>) { create :<%= class_string %> }

    context 'for a visitor' do
      let(:user) { nil }

      it { should forbid_action(:index) }
      it { should forbid_actions(crud_actions) }
    end

    context 'for another user' do
      it { should permit_action(:index) }
      it { should forbid_actions(crud_actions) }
    end

    context 'for the record user' do
      let(:<%= class_string %>) { create :<%= class_string %>, user: user }

      it { should permit_action(:index) }
      it { should permit_actions(crud_actions) }
    end
  end
end
