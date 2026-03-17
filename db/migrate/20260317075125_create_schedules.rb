class CreateSchedules < ActiveRecord::Migration[7.1]
  def up
    create_table :schedules do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :default, null: false, default: false
      t.jsonb :blocks, null: false, default: []
      t.timestamps
    end
    add_index :schedules, [:title, :user_id], unique: true

    add_reference :tasks, :schedule, null: true, foreign_key: true
    add_reference :lists, :schedule, null: true, foreign_key: true
  end

  def down
    remove_reference :lists, :schedule, foreign_key: true
    remove_reference :tasks, :schedule, foreign_key: true
    drop_table :schedules
  end
end
