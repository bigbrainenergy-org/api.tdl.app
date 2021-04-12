class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.belongs_to :user,  null: false, foreign_key: true
      t.string     :title, null: false
      t.string     :color, null: false
      t.integer    :order, null: false, default: 0

      t.timestamps
    end

    add_index :tags, [:title, :user_id], unique: true
  end
end
