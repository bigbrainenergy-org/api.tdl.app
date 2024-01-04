class UndoGtd < ActiveRecord::Migration[7.0]
  def up
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string     :title, null: false
      t.string     :color, null: false
      t.string     :icon, null: false
      t.integer    :order, null: false, default: 0

      t.timestamps
    end
    add_index :lists, [:title, :user_id], unique: true

    create_table :statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.string     :title, null: false
      t.string     :color, null: false
      t.string     :icon, null: false
      t.integer    :order, null: false, default: 0

      t.timestamps
    end
    add_index :statuses, [:title, :user_id], unique: true

    remove_reference :next_actions, :context
    remove_reference :next_actions, :project
    remove_reference :next_actions, :user
    rename_table :next_action_relationships, :task_relationships
    rename_table :next_actions, :tasks
    add_reference :tasks, :list, null: false
    add_reference :tasks, :status, null: false
    add_column :tasks, :delegated, :boolean
    add_column :tasks, :status_last_changed_at, :datetime
    add_column :tasks, :deadline_at, :datetime
    add_column :tasks, :task_duration_in_minutes, :integer

    drop_table :inbox_items
    drop_table :waiting_fors
    drop_table :contexts
    drop_table :project_relationships
    drop_table :projects
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
      'Implementing the inverse of this isn\'t worth the effort at time of ' \
      'writing. Update the down and run again if needed.'
  end
end
