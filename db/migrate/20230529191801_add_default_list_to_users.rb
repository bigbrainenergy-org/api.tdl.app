class AddDefaultListToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.belongs_to :default_list
    end
  end
end
