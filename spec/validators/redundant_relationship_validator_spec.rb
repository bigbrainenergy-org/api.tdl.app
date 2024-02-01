require 'rails_helper'

RSpec.describe RedundantRelationshipValidator do
  subject(:validator) { validator_model_mock }
  let!(:user) { create(:user) }

  let!(:list) { create(:list, user: user) }

  let!(:task_a) { create(:task, list: list, completed: false, title: "Task A") }
  let!(:task_b) { create(:task, list: list, completed: false, title: "Task B") }
  let!(:task_c) { create(:task, list: list, completed: false, title: "Task C") }

  context 'when A --> B --> C and try to add A --> C' do
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:bc) { create(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }
    # let(:value) { nil }
    # let(:value) { build(:task_hard_requisite, first_id: task_a.id, second_id: task_c.id) }
    let(:value) { build(:task_hard_requisite, first_id: task_a.id, second_id: task_c.id) }
    
    it 'adds validation error due to redundancy' do
      expect(value.valid?).to be_falsy
      expect(value.errors[:base].include?(
        I18n.t(
          'validators.redundant_relationship.invalid',
          first_title: :pre,
          second_title: :post,
          relationship: :pre
        )
      )).to be_truthy
      expect(value.errors[:base].include?(
        I18n.t(
          'validators.redundant_relationship.invalid',
          first_title: :post,
          second_title: :pre,
          relationship: :post
        )
      )).to be_truthy
    end
    # it { should have_validation_error(I18n.t('validators.redundant_relationship.invalid', first_title:  task_a.title,
    # second_title: task_c.title,
    # relationship: value)) }
  end

  context 'when A --> B --> C and complete B, then try to add A --> C' do
    let!(:task_b) { create(:task, list: list, completed: true, title: "Task B") }
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:bc) { create(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }
    let(:value) { build(:task_hard_requisite, first_id: task_a.id, second_id: task_c.id) }
    
    it 'adds the rule without error because B, a prereq, is completed and its rules are NULL AND VOIDDDD' do
      expect(value.valid?).to be_truthy
    end
    # it { should be_valid }
  end

  context 'when A --> B and complete B, then try to add B --> C' do
    let!(:task_b) { create(:task, list: list, completed: true, title: "Task B") }
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:value) { build(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }

    it 'adds the rule despite the fact that one of the tasks is already done' do
      expect(value.valid?).to be_truthy
    end
  end

  context 'when A --> B and complete B and C, then try to add B --> C' do
    let!(:task_b) { create(:task, list: list, completed: true, title: "Task B") }
    let!(:task_c) { create(:task, list: list, completed: true, title: "Task C") }
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:value) { build(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }

    it 'adds the rule despite the fact that both of the tasks are already done' do
      expect(value.valid?).to be_truthy
    end
  end

  context 'when A --> B --> C and complete B, then try to add unrelated rule A --> D' do
    let!(:task_b) { create(:task, list: list, completed: true, title: "Task B") }
    let!(:task_d) { create(:task, list: list, completed: false, title: "Task D") }
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:bc) { create(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }
    let(:value) { build(:task_hard_requisite, first_id: task_a.id, second_id: task_d.id) }
    
    it 'adds the rule without error because B does not conflict with the new rule A --> D' do
      expect(value.valid?).to be_truthy
    end
    # it { should be_valid }
  end

  context 'when A --> B --> C --> D --> E --> F, then try to add A --> F' do
    let!(:task_d) { create(:task, list: list, completed: false, title: "Task D") }
    let!(:task_e) { create(:task, list: list, completed: false, title: "Task E") }
    let!(:task_f) { create(:task, list: list, completed: false, title: "Task F") }
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:bc) { create(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }
    let!(:cd) { create(:task_hard_requisite, first_id: task_c.id, second_id: task_d.id) }
    let!(:de) { create(:task_hard_requisite, first_id: task_d.id, second_id: task_e.id) }
    let!(:ef) { create(:task_hard_requisite, first_id: task_e.id, second_id: task_f.id) }
    let(:value) { build(:task_hard_requisite, first_id: task_a.id, second_id: task_f.id) }
    it 'errors because rule is redundant' do
      expect(value.valid?).to be_falsy
    end
  end

  context 'when A --> B --> C --> D --> E --> F, then complete C, then try to add A --> F' do
    let!(:task_d) { create(:task, list: list, completed: false, title: "Task D") }
    let!(:task_e) { create(:task, list: list, completed: false, title: "Task E") }
    let!(:task_f) { create(:task, list: list, completed: false, title: "Task F") }
    let!(:task_c) { create(:task, list: list, completed: true, title: "Task C") }
    let!(:ab) { create(:task_hard_requisite, first_id: task_a.id, second_id: task_b.id) }
    let!(:bc) { create(:task_hard_requisite, first_id: task_b.id, second_id: task_c.id) }
    let!(:cd) { create(:task_hard_requisite, first_id: task_c.id, second_id: task_d.id) }
    let!(:de) { create(:task_hard_requisite, first_id: task_d.id, second_id: task_e.id) }
    let!(:ef) { create(:task_hard_requisite, first_id: task_e.id, second_id: task_f.id) }
    let(:value) { build(:task_hard_requisite, first_id: task_a.id, second_id: task_f.id) }
    it 'allows the rule because there is no path between A and F that does not contain completed tasks' do
      expect(value.valid?).to be_truthy
    end
  end
end