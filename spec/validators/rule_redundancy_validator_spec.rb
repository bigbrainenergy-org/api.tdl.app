require 'rails_helper'

RSpec.describe RuleRedundancyValidator do
  subject(:validator) { validator_model_mock }

  let!(:user) { create :user }
  let!(:list) { create :list, user: user }

  describe 'task instance tests' do
    let(:a) { create :task, title: 'a', user: user, list: list }
    let(:b) { create :task, title: 'b', user: user, list: list }
    let(:c) { create :task, title: 'c', user: user, list: list }

    # FIXME: maybe increase memoized helpers max, state context is required to
    # test DAG logic
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when A --> B' do
      let!(:ab) { create :rule, pre: a, post: b }

      it 'creates A --> B' do
        expect(ab).to be_persisted
      end

      context 'when A --> B --> C' do
        before { create :rule, pre: b, post: c }

        # FIXME: we'll talk
        # rubocop:disable RSpec/NestedGroups
        context 'when a redundant rule A --> C is attempted' do
          it 'raises error when A --> C is attempted' do
            expect { create :rule, pre: a, post: c }.to raise_error(ActiveRecord::RecordInvalid, /#{I18n.t('validators.rule.redundant_rule', task_i_title: c.title, task_ii_title: a.title)}/)
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
