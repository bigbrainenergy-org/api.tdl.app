class WaitingFor < ApplicationRecord
  has_many :prereqs
  has_many :postreqs
end
