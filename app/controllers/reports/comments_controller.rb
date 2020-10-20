# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  before_action :set_report
  before_action :set_comment, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @report, notice: t("view.report/comment.notice.create")
    else
      @comments = @report.comments
                         .includes(user: { avatar_attachment: :blob })
                         .order(created_at: :asc)
                         .page(params[:page])
                         .per(10)
      render "reports/show"
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @report, notice: t("view.report/comment.notice.update")
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @report, notice: t("view.report/comment.notice.destroy")
  end

  private
    def set_report
      @report = Report.find(params[:report_id])
    end

    def set_comment
      @comment = @report.comments.find_by(id: params[:id], user: current_user)
    end

    def comment_params
      params.require(:report_comment).permit(:body)
    end
end
