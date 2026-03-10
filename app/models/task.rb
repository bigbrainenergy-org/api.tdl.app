class Task < ApplicationRecord
  belongs_to :list
  belongs_to :status, optional: true

  has_many :pre_relationships,
    class_name:  'TaskDependency',
    inverse_of:  :post,
    foreign_key: :second_id,
    dependent:   :destroy

  has_many :post_relationships,
    class_name:  'TaskDependency',
    inverse_of:  :pre,
    foreign_key: :first_id,
    dependent:   :destroy

  has_many :procedure_relationships,
    class_name: 'TaskProcedure',
    foreign_key: :task_id,
    dependent: :destroy

  has_many :prereqs,
    class_name: 'Task',
    through:    :pre_relationships,
    source:     :pre

  has_many :postreqs,
    class_name: 'Task',
    through:    :post_relationships,
    source:     :post

  has_many :procedures,
    class_name: 'Procedure',
    through: :procedure_relationships,
    source: :procedure

  has_one :user,
    through: :list

  has_many :subtasks,
    dependent: :destroy

  validates :title, :order,
    presence: true

  validates :mental_energy_required, :physical_energy_required,
    presence:     true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to:    100
    }

  def all_prereqs
    recursive_relationship_find(
      klass:       Task,
      join_table:  'task_relationships',
      join_type:   'TaskDependency',
      starting_id: id,
      finding:     :first
    )
  end

  def all_postreqs
    recursive_relationship_find(
      klass:       Task,
      join_table:  'task_relationships',
      join_type:   'TaskDependency',
      starting_id: id,
      finding:     :second
    )
  end

  def all_prereqs_excl_completed
    recursive_relationship_find_excl_completed(
      klass:       Task,
      join_table:  'task_relationships',
      join_type:   'TaskDependency',
      starting_id: id,
      finding:     :first
    )
  end

  def all_postreqs_excl_completed
    recursive_relationship_find_excl_completed(
      klass:       Task,
      join_table:  'task_relationships',
      join_type:   'TaskDependency',
      starting_id: id,
      finding:     :second
    )
  end
end
