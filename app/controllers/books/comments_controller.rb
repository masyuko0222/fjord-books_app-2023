# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable
  before_action :correct_user, only: %i[destroy]

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def correct_user
    unless current_user == @commentable.user
      redirect_to root_path
    end
  end

  def render_commentable_show
    @book = @commentable
    render 'books/show', status: :unprocessable_entity
  end
end
