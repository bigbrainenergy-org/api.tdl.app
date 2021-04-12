class List < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :restrict_with_exception

  validates :title,
    presence:   true,
    uniqueness: { case_sensitive: false, scope: :user_id }

  validates :order,
    presence: true
end
