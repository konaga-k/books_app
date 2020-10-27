# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @follow = current_user.active_user_follows.find_or_initialize_by(following: @user)
  end
end
