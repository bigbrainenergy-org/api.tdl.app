class Subtask < ApplicationRecord
  belongs_to :next_action

  validates :title, :order,
    presence: true
end
