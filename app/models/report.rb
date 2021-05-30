# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validate :more_than_one_report_cannot_be_submitted_on_the_same_day, on: :create

  def reported_on
    created_at&.to_date
  end

  private
    def more_than_one_report_cannot_be_submitted_on_the_same_day
      reports_on_the_same_day = Report.where("created_at BETWEEN ? AND ?", Time.current.beginning_of_day, Time.current.end_of_day)
      if reports_on_the_same_day.exists?
        errors.add(:base, :more_than_one_report_cannot_be_submitted_on_the_same_day)
      end
    end
end
