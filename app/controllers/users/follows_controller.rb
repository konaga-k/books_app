class Users::FollowsController < ApplicationController
  def create
    @follow = current_user.active_user_follows.build(following_id: params[:user_id])

    if @follow.save
      redirect_to @follow.following, notice: t("view.user/follow.notice.create")
    else
      @user = @follow.following
      render "users/show"
    end
  end

  def destroy
    @follow = current_user.active_user_follows.find(params[:id])
    if @follow.destroy
      redirect_to @follow.following, notice: t("view.user/follow.notice.destroy")
    else
      @user = @follow.following
      render "users/show"
    end
  end
end
