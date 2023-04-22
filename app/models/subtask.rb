class Subtask < ApplicationRecord
  belongs_to :task
  has_one :user, through: :task
  validates :title, :order,
    presence: true
end
