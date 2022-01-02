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

  validates :order,
    presence: true

  enum status: {
    active: 'active',
    paused: 'paused',
    completed: 'completed'
  }
end
