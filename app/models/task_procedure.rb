class TaskProcedure < ApplicationRecord
  belongs_to :task,
    class_name:  'Task'

  belongs_to :procedure,
    class_name:  'Procedure'

  validates_with SameUsersRelationshipValidator,
    first:  :task,
    second: :procedure

  validates_with UniqueRelationshipValidator,
    first:  :task,
    second: :procedure
end
