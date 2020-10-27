class Users::FollowingsController < ApplicationController
  def index
    @followings = User.find(params[:user_id]).followings.page(params[:page])
  end
end
