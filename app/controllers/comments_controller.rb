# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: "Comment was sucessfully created."
    else
      flash.now[:alert] = "Comment couldn't be created. Please check the errors below."
      render 'books/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
