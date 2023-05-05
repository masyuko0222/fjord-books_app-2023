# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  before_action :set_commentable
  before_action :correct_user, only: %i[destroy]

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def correct_user
    unless current_user == @commentable.user
      redirect_to root_path
    end
  end

  def render_commentable_show
    @report = @commentable
    render 'reports/show', status: :unprocessable_entity
  end
end
