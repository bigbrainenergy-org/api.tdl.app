require 'rails_helper'

RSpec.describe RuleAcyclicValidator do
  subject(:validator) { validator_model_mock }

  let!(:user) { create :user }
  let!(:list) { create :list, user: user }

  describe 'task instance tests' do
    # FIXME: is there a better way to write this so that memos don't flip out?
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when tasks exist A, B, C, and D' do
      let(:a) { create :task, title: 'a', user: user, list: list }
      let(:b) { create :task, title: 'b', user: user, list: list }
      let(:c) { create :task, title: 'c', user: user, list: list }
      let(:d) { create :task, title: 'd', user: user, list: list }

      context 'when A --> B' do
        let!(:ab) { create :rule, pre: a, post: b }

        it 'creates the rule between two unrelated tasks, A --> B' do
          expect(ab).to be_persisted
        end

        # FIXME: more debate needed
        # rubocop:disable RSpec/NestedGroups
        context 'when A --> B, C --> D, and A --> C' do
          let(:cd) { create :rule, pre: c, post: d }
          let(:ac) { create :rule, pre: a, post: c }

          it 'creates rule C --> D' do
            expect(cd).to be_persisted
          end

          it 'creates rule A --> C' do
            expect(ac).to be_persisted
          end
        end

        context 'when A --> B --> C' do
          before { create :rule, pre: b, post: c }

          it 'raises an error when C --> A is attempted' do
            expect { create :rule, pre: c, post: a }.to raise_error(ActiveRecord::RecordInvalid, /#{I18n.t('validators.rule.redundant_rule', task_i_title: c.title, task_ii_title: a.title)}/)
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
      # rubocop:enable RSpec/MultipleMemoizedHelpers
    end
  end
end
