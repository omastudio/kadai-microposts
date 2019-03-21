class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.add_to_favorite(micropost)
    flash[:success] = '投稿をお気に入りに追加しました。'
    redirect_to favorites_user_path(current_user)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.remove_favorite(micropost)
    flash[:success] = '投稿のお気に入りを解除しました。'
    redirect_to favorites_user_path(current_user)
  end
end
