require 'rails_helper'

RSpec.describe Rule do
  subject(:record) { build :rule }

  let!(:user) { create :user }
  let!(:list) { create :list, user: user }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:pre) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:pre).scoped_to(:post_id) }
    it { should validate_uniqueness_of(:post).scoped_to(:pre_id) }

    pending 'FIXME: create regex pattern for ActiveRecord::validator'
    # it { should validate_with_rule_acyclic_validator }
    # it { should validate_with_rule_redundancy_validator }
  end

  describe 'instance method tests' do
    context 'when rule is added that makes others redundant' do
      # FIXME: state needs to be defined for these tests. may need to increase
      # max MemoizedHelpers
      # rubocop:disable RSpec/MultipleMemoizedHelpers
      context 'when there are tasks A, B, and C' do
        let!(:a) { create :task, title: 'a', user: user, list: list }
        let!(:b) { create :task, title: 'b', user: user, list: list }
        let!(:c) { create :task, title: 'c', user: user, list: list }

        # FIXME: yo dawg, heard you like nesting.
        # rubocop:disable RSpec/NestedGroups
        context 'when A --> C' do
          let!(:ac) { create :rule, pre: a, post: c }

          it 'A --> C generates a rule and persists' do
            expect(ac).to be_persisted
          end

          context 'when A --> C and B --> C' do
            let!(:bc) { create :rule, pre: b, post: c }

            it 'B --> C generates a rule and persists' do
              expect(bc).to be_persisted
            end

            context 'when A --> B is created' do
              let!(:ab) { create :rule, pre: a, post: b }

              it 'A --> B generates a rule and persists' do
                expect(ab).to be_persisted
              end
              # FIXME: mark redundant instead of prune
              # it 'should remove redundant rule A --> C' do
              #   expect(ac).not_to be_persisted
              #   expect(ac).to be_invalid
              # end
            end
          end

          context 'when A --> C and A --> B' do
            let!(:ab) { create :rule, pre: a, post: b }

            it 'A --> B generates a rule and persists' do
              expect(ab).to be_persisted
            end

            context 'when B --> C is created' do
              let(:bc) { create :rule, pre: b, post: c }

              it 'B --> C generates a rule and persists' do
                expect(bc).to be_persisted
              end
              # FIXME: mark redundant instead of prune
              # it 'should remove redundant rule A --> C' do
              #   expect(ac).not_to be_persisted
              #   expect(ac).to be_invalid
              # end
            end
          end
        end
        # rubocop:enable RSpec/NestedGroups
      end
      # rubocop:enable RSpec/MultipleMemoizedHelpers
    end
  end
end
