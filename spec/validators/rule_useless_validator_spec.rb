require 'rails_helper'

RSpec.describe RuleUselessValidator do
  subject(:validator) { validator_model_mock }

  let!(:user) { create :user }
  let!(:list) { create :list, user: user }

  describe 'task instance tests' do
    context 'when two tasks exist: A and B' do
      let!(:a) { create :task, title: 'a', user: user, list: list }
      let!(:b) { create :task, title: 'b', user: user, list: list }

      context 'when rule is comprised of different task' do
        let!(:ab) { create :rule, pre: a, post: b }

        it 'creates the rule' do
          expect(ab).to be_persisted
        end
      end

      context 'when rule pre and post are the same' do
        it 'raises an error' do
          expect { create :rule, pre: a, post: a }.to raise_error(ActiveRecord::RecordInvalid, /#{I18n.t('validators.rule.pre_and_post_cant_be_same')}/)
        end
      end
    end
  end
end
