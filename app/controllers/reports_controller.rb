# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: [:show]
  before_action :set_users_own_report, only: [:edit, :update, :destroy]

  def index
    @reports = Report.all.page(params[:page])
  end

  def show
    @comments = @report.comments
                       .includes(user: { avatar_attachment: :blob })
                       .order(created_at: :asc)
                       .page(params[:page])
                       .per(10)
    @comment = @report.comments.build
  end

  def new
    @report = current_user.reports.build
  end

  def edit
  end

  def create
    @report = current_user.reports.build(report_params)

    if @report.save
      redirect_to @report, notice: t("view.report.notice.create")
    else
      render :new
    end
  end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: t("view.report.notice.update")
    else
      render :edit
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_url, notice: t("view.report.notice.destroy")
  end

  private
    def set_report
      @report = Report.find(params[:id])
    end

    def set_users_own_report
      @report = Report.find_by(id: params[:id], user: current_user)
    end

    def report_params
      params.require(:report).permit(:title, :description)
    end
end
