class Project < ApplicationRecord
  belongs_to :user

  has_many :next_actions, dependent: :restrict_with_exception

  has_many :superprojects
  has_many :subprojects

  has_many :prereqs
  has_many :postreqs

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
