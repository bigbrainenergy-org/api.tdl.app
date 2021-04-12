class CreateAccessRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :access_requests do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :reason_for_interest, null: false
      t.string :version, null: false

      t.timestamps
    end

    add_index :access_requests, :email, unique: true
  end
end
