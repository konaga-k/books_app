# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  include CommentsConcern

  before_action :set_commentable
  before_action :set_new_comment, only: :create
  before_action :set_comment, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: t("view.report/comment.notice.create")
    else
      @comments = @commentable.comments
                         .includes(user: { avatar_attachment: :blob })
                         .order(created_at: :asc)
                         .page(params[:page])
                         .per(10)
      @report = @commentable
      render "reports/show"
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @commentable, notice: t("view.report/comment.notice.update")
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @commentable, notice: t("view.report/comment.notice.destroy")
  end
end
