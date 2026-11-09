# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.includes(:mentioned_reports).order(mentioned_reports: { id: :desc }).find(params[:id])
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    begin
      ActiveRecord::Base.transaction do
        @report.save!
        @report.mentioning_report_ids = scan_mention_ids(params[:report][:content])
      end
    rescue StandardError
      render :new, status: :unprocessable_entity
    else
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      @report.mentioning_report_ids = scan_mention_ids(params[:report][:content])
    end
  rescue StandardError
    render :edit, status: :unprocessable_entity
  else
    redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
  end

  def destroy
    @report.destroy!

    redirect_to reports_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.expect(report: %i[user_id title content])
  end

  def scan_mention_ids(content)
    content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq
  end
end
