# TODO: Single-table inheritance (STI) is horrible, refactor this ASAP.
class TaskRelationship < ApplicationRecord
  # self.abstract_class = true

  # belongs_to :first,
  #   class_name: 'NextAction',
  #   foreign_key: :first_id

  # belongs_to :second,
  #   class_name: 'NextAction',
  #   foreign_key: :second_id
end
