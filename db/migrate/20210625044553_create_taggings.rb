class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag,   null: false, foreign_key: true
      t.belongs_to :task,  null: false, foreign_key: true
      t.integer    :order, null: false, default: 0

      t.timestamps
    end
  end
end
