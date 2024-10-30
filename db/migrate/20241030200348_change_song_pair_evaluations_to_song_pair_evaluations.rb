class ChangeSongPairEvaluationsToSongPairEvaluations < ActiveRecord::Migration[7.0]
  def change
    rename_table :song_pair_evalutions, :song_pair_evaluations
  end
end
