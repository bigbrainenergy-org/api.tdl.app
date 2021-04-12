class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.belongs_to :user,  null: false, foreign_key: true
      t.string     :title, null: false
      t.integer    :order, null: false, default: 0

      t.timestamps
    end

    add_index :lists, [:title, :user_id], unique: true
  end
end
