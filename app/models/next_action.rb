class NextAction < ApplicationRecord
  belongs_to :context

  has_many :prereqs
  has_many :postreqs
end
