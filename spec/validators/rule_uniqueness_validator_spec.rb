require 'rails_helper'

RSpec.describe RuleUniquenessValidator do
  subject(:validator) { validator_model_mock }

  let!(:user) { create :user }
  let!(:list) { create :list, user: user }

  describe 'task instance tests' do
    let(:a) { create :task, title: 'a', user: user, list: list }
    let(:b) { create :task, title: 'b', user: user, list: list }
    let(:c) { create :task, title: 'c', user: user, list: list }

    # FIXME: IDK how I would fix this unless I used creates instead of lets
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when A --> B --> C' do
      let!(:ab) { create :rule, pre: a, post: b }
      let!(:bc) { create :rule, pre: b, post: c }

      it 'creates A --> B' do
        expect(ab).to be_persisted
      end

      it 'creates B --> C' do
        expect(bc).to be_persisted
      end

      it 'raises an error upon dupe rule A --> B' do
        expect { create :rule, pre: a, post: b }.to raise_error(
          ActiveRecord::RecordInvalid,
          /#{I18n.t('validators.rule.duplicate_rule')}/
        )
      end

      it 'raises an error upon dupe rule B --> C' do
        expect { create :rule, pre: b, post: c }.to raise_error(
          ActiveRecord::RecordInvalid,
          /#{I18n.t('validators.rule.duplicate_rule')}/
        )
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
