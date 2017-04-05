class CommentsController < ApplicationController

  before_action :fetch_comment, only: [:edit, :update, :destroy]

  def create
    authorize! :create, Comment

    @comment = current_user.comments.new comment_params
    @comment.post_id = params[:post_id]

    if @comment.save
      redirect_to :back, notice: "Comment successfully saved"
    else
      redirect_to :back, notice: "Please, fill comment text"
    end
  end

  def edit
    authorize! :edit, @comment
  end

  def update
    authorize! :edit, @comment
    @comment.update comment_params
  end

  def destroy
    authorize! :delete, @comment
    @comment.destroy
    redirect_to @comment.post, notice: "Comment successfully deleted"
  end

  private

  def comment_params
    params.require(:comment).permit!
  end

  def fetch_comment
    @comment = Comment.find params[:id]
  end

end
