class AddTaskReferenceToSubtasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :subtasks, :next_action_id
    add_reference :subtasks, :task, null: false, foreign_key: true
  end
end
