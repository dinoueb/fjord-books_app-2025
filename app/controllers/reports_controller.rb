# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  # GET /reports or /reports.json
  def index
    @reports = Report.order(:id).page(params[:page])
  end

  # GET /reports/1 or /reports/1.json
  def show; end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    if @report.update(report_params)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy!

    redirect_to reports_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.expect(report: %i[title content])
  end
end
