# frozen_string_literal: true

class CommentsController < ApplicationController
  # 拡張性を持たせるために、before_actionを利用している。
  before_action :set_commentable, only: %i[create destroy]
  before_action :correct_user, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      # Books#showのComment.newで生成された、空のインスタンスが残ってしまっているためreloadする。
      @comments = @commentable.reload.comments

      render_commentable_show
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def correct_user
    return if current_user == @commentable.user

    redirect_to root_path
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
