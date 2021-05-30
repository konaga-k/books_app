# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
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

  private
  def set_commentable
    resource, id = request.path.split("/")[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def set_new_comment
    @comment = @commentable.comments.build(comment_params)
  end

  def set_comment
    @comment = @commentable.comments.find_by(id: params[:id], user: current_user)
    redirect_back(fallback_location: root_path) if @comment.blank?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
