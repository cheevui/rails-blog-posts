class CommentsController < ApplicationController
    before_action :authenticate_user!

  def create
    @blog_post = BlogPost.find(params[:blog_post_id])
    @comment = @blog_post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @blog_post, notice: "Comment added!"
    else
      redirect_to @blog_post, alert: "Comment cannot be blank."
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @blog_post = @comment.blog_post

    if @comment.user == current_user
      @comment.destroy
      redirect_to @blog_post, notice: "Comment deleted successfully."
    else
      redirect_to @blog_post, alert: "You can only delete your own comments."
    end 
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
