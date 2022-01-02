# TODO: Single-table inheritance (STI) is horrible, refactor this ASAP.
class NextActionRelationship < ApplicationRecord
  belongs_to :first,
    class_name: 'NextAction',
    foreign_key: :first_id

  belongs_to :second,
    class_name: 'NextAction',
    foreign_key: :second_id

  # Is this necessary? Or can it be simplified to the last uniqueness check on kind?
  # validates :first, uniqueness: { scope: [:second_id, :kind] }
  # validates :second, uniqueness: { scope: [:first_id, :kind] }
  # validates :kind, uniqueness: { scope: [:first_id, :second_id] }
end
