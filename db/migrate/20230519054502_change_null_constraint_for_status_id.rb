class ChangeNullConstraintForStatusId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tasks, :status_id, true
  end
end
