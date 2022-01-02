# TODO: Single-table inheritance (STI) is horrible, refactor this ASAP.
class ProjectRelationship < ApplicationRecord
  belongs_to :first,
    class_name: 'Project',
    foreign_key: :first_id
  belongs_to :second,
    class_name: 'Project',
    foreign_key: :second_id
end
