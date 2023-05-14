# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      add_records_to_mentions_table(@report)
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      add_records_to_mentions_table(@report)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  REPORT_ID_REGEXP = /http:\/\/localhost:3000\/reports\/(\d+)/.freeze

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end


  def add_records_to_mentions_table(report)
    report.mentioning_reports.destroy_all if report.mentioning_reports.any?

    scan_mentioning_report_ids(report).each do |id|
      mentioning_report = Report.find(id)

      unless report.mentioning_reports.include?(mentioning_report)
        report.mentioning_reports << mentioning_report
      end
    end
  end

  def scan_mentioning_report_ids(report)
    ids = report.content.scan(REPORT_ID_REGEXP).flatten

    ids.map(&:to_i)
  end
end
