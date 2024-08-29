class TaskProcedure < TaskRelationship
  belongs_to :task,
    class_name: 'Task',
    foreign_key: :task_id

  belongs_to :procedure,
    class_name: 'Procedure',
    foreign_key: :procedure_id

  validates_with SameUsersRelationshipValidator,
    first: :task,
    second: :procedure

  validates_with UniqueRelationshipValidator,
    first: :task,
    second: :procedure
end