class Subtask < ApplicationRecord
  belongs_to :task
  has_one :list, through: :task
  has_one :user, through: :list
  validates :title, :order,
    presence: true
end
