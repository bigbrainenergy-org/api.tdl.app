class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # Name
      t.string :given_name,  null: false
      t.string :family_name, null: false
      # Preferences
      t.string :time_zone, null: false, default: 'UTC'
      t.string :locale,    null: false, default: 'en'
      # Account information
      t.string :username, null: false
      t.string :email,    null: false
      # Sorcery - Password (argon2 hash)
      t.string :password_digest
      # Sorcery - Activity Monitoring Module
      t.datetime :last_login_at
      t.datetime :last_logout_at
      t.datetime :last_activity_at
      t.string   :last_login_from_ip_address
      # Sorcery - Brute Force Protection Module
      t.integer   :failed_logins_count, default: 0, null: false
      t.datetime  :lock_expires_at
      t.string    :unlock_token
      # Track the last time a user accepted the terms
      t.datetime :terms_and_conditions, null: false

      t.timestamps
    end
  end
end
