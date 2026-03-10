class RenameTaskHardRequisiteToTaskDependency < ActiveRecord::Migration[7.0]
  def up
    add_column :task_relationships, :degree, :integer

    execute <<-SQL.squish
      UPDATE task_relationships
      SET type = 'TaskDependency'
      WHERE type = 'TaskHardRequisite'
    SQL
  end

  def down
    execute <<-SQL.squish
      UPDATE task_relationships
      SET type = 'TaskHardRequisite'
      WHERE type = 'TaskDependency'
    SQL

    remove_column :task_relationships, :degree
  end
end
