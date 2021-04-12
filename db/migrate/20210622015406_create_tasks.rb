class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :user,  null: false, foreign_key: true
      t.belongs_to :list,  null: false, foreign_key: true
      t.string     :title, null: false
      t.integer    :order, null: false, default: 0
      t.string     :notes

      t.datetime :completed_at
      t.datetime :deadline_at
      t.datetime :prioritize_at
      t.datetime :remind_me_at
      t.datetime :review_at

      t.timestamps
    end

    add_index :tasks, [:title, :user_id], unique: true
  end
end
