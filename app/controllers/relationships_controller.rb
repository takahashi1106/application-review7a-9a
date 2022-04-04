class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  # フォローするとき
  def create #user_relationships post
    user=User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy#user_relationships delete
    user = User.find(params[:user_id])
    current_user.unfollow(user)
		redirect_to request.referer
  end


def followings #exists? データベースからデータを取得する前に、データが存在しているかどうか
    user = User.find(params[:user_id])
    @users = user.followings
    # ：Userモデルで定義済
end

def followers #exists? データベースからデータを取得する前に、データが存在しているかどうか
    user = User.find(params[:user_id])
    @users = user.followers
    # ：Userモデルで定義済
end
end
