class Project < ApplicationRecord
  belongs_to :user

  has_many :next_actions, dependent: :restrict_with_exception

  has_many :superproject_relationships,
    class_name: 'ProjectNesting',
    inverse_of: :subproject,
    foreign_key: :second_id,
    dependent: :destroy
  has_many :subproject_relationships,
    class_name: 'ProjectNesting',
    inverse_of: :superproject,
    foreign_key: :first_id,
    dependent: :destroy

  has_many :hard_pre_relationships,
    class_name: 'ProjectHardRequisite',
    inverse_of: :post,
    foreign_key: :second_id,
    dependent: :destroy
  has_many :hard_post_relationships,
    class_name: 'ProjectHardRequisite',
    inverse_of: :pre,
    foreign_key: :first_id,
    dependent: :destroy

  has_many :superprojects,
    class_name: 'Project',
    through: :superproject_relationships,
    source: :superproject
  has_many :subprojects,
    class_name: 'Project',
    through: :subproject_relationships,
    source: :subproject

  has_many :hard_prereqs,
    class_name: 'Project',
    through: :hard_pre_relationships,
    source: :pre
  has_many :hard_postreqs,
    class_name: 'Project',
    through: :hard_post_relationships,
    source: :post

  validates :title,
    presence:   true,
    uniqueness: { case_sensitive: false, scope: :user_id }

  validates :order, :status,
    presence: true

  enum status: {
    active: 'active',
    paused: 'paused',
    completed: 'completed'
  }

  def all_superprojects
    recursive_relationship_find(
      klass: Project,
      join_table: 'project_relationships',
      join_type: 'ProjectNesting',
      starting_id: id,
      finding: :first
    )
  end

  def all_subprojects
    recursive_relationship_find(
      klass: Project,
      join_table: 'project_relationships',
      join_type: 'ProjectNesting',
      starting_id: id,
      finding: :second
    )
  end

  def all_hard_prereqs
    recursive_relationship_find(
      klass: Project,
      join_table: 'project_relationships',
      join_type: 'ProjectHardRequisite',
      starting_id: id,
      finding: :first
    )
  end

  def all_hard_postreqs
    recursive_relationship_find(
      klass: Project,
      join_table: 'project_relationships',
      join_type: 'ProjectHardRequisite',
      starting_id: id,
      finding: :second
    )
  end
end
