class CommentsController < ApplicationController
  def create
    @comment = Comment.new(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
    if @comment.save
      redirect_to post_path @comment.post.id and return
    end
    respond_to do |format|
      format.html { redirect_to post_path comment_params[:post_id] }
      format.js { render 'layouts/errors' }
    end
  end

  private
  def comment_params
    params.permit(:post_id).merge(params.require(:comment).permit(:text))
  end
end