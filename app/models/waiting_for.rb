class WaitingFor < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  validates :title, :delegated_to, :order,
    presence: true
end
