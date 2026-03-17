class Schedule < ApplicationRecord
  belongs_to :user

  has_many :tasks,
    dependent: :restrict_with_exception

  has_many :lists,
    dependent: :restrict_with_exception

  validates :title,
    presence:   true,
    uniqueness: { case_sensitive: false, scope: :user_id }

  validates :blocks,
    schedule_blocks: true
end
