class ChangeUserIdToAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :song_pairs, :user_id, true
  end
end
