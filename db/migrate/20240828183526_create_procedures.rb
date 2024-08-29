class CreateProcedures < ActiveRecord::Migration[7.1]
  def change
    create_table :procedures do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :color, null: false
      t.string :icon, null: false

      t.timestamps
    end

    add_index :procedures, [:title, :user_id], unique: true

    create_table :task_procedures do |t|
      t.belongs_to :procedure, null: false, foreign_key: true
      t.belongs_to :task, null: false, foreign_key: true
    end

    add_index :task_procedures, [:procedure_id, :task_id], unique: true
  end
end
