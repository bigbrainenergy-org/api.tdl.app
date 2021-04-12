class CreateRules < ActiveRecord::Migration[6.1]
  def change
    create_table :rules do |t|
      t.belongs_to :pre,  null: false
      t.belongs_to :post, null: false

      t.timestamps
    end

    add_index :rules, [:pre_id, :post_id], unique: true
  end
end
