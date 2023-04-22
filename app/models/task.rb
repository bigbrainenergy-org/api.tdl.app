class Task < ApplicationRecord
  belongs_to :list
  belongs_to :status
  
  has_many :hard_pre_relationships,
    class_name:  'TaskHardRequisite',
    inverse_of:  :post,
    foreign_key: :second_id,
    dependent:   :destroy

  has_many :hard_post_relationships,
    class_name:  'TaskHardRequisite',
    inverse_of:  :pre,
    foreign_key: :first_id,
    dependent:   :destroy

  has_many :hard_prereqs,
    class_name: 'Task',
    through: :hard_pre_relationships,
    source: :pre

  has_many :hard_postreqs,
    class_name: 'Task',
    through: :hard_post_relationships,
    source: :post

  has_one :user,
    through: :list

  validates :title, :order,
    presence: true

  validates :mental_energy_required, :physical_energy_required,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    }

  def all_hard_prereqs
    recursive_relationship_find(
      klass: Task,
      join_table: 'task_relationships',
      join_type: 'TaskHardRequisite',
      starting_id: id,
      finding: :first
    )
  end

  def all_hard_postreqs
    recursive_relationship_find(
      klass: Task,
      join_table: 'task_relationships',
      join_type: 'TaskHardRequisite',
      starting_id: id,
      finding: :second
    )
  end
end
