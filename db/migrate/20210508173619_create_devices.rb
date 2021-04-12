class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.belongs_to :user,          null: false, foreign_key: true
      t.string     :push_endpoint, null: false
      t.string     :push_p256dh,   null: false
      t.string     :push_auth,     null: false
      t.string     :user_agent,    null: false
      t.datetime   :last_seen_at,  null: false
      t.string     :name

      t.timestamps
    end
  end
end
