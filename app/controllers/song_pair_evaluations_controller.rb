class SongPairEvaluationsController < ApplicationController
  def create
    @song_pair = SongPair.find(params[:song_pair_id])
    current_user.song_pair_evaluation(@song_pair)
  end

  def destroy
    @song_pair = current_user.song_pair_evaluations.find(params[:id]).song_pair
    current_user.song_pair_unevaluation(@song_pair)
  end
end
