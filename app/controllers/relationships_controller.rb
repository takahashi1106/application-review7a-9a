class RelationshipsController < ApplicationController
  # フォローするとき
  def create #user_relationships post
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy#user_relationships delete
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end


def follower #follower一覧
    user = User.find(params[:id])
    @followers = user.following_users
    # .follower_userメソッド ：Userモデルで定義済
end

def followed #followed一覧 
    user = User.find(params[:id])
    @followeds = user.follower_users
    # .follower_userメソッド ：Userモデルで定義済
end
end
