class BlogPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog_post, only: [:show, :edit, :update, :destroy] #except: [:index, :new, :create]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    # @blog_posts = BlogPost.all.order(created_at: :desc)
    
    if params[:query].present?
      @blog_posts = BlogPost.search_by_title(params[:query])
    else
      @blog_posts = BlogPost.all.includes(:comments).order(created_at: :desc)
    end
    
    @pagy, @blog_posts = pagy(@blog_posts)
  end

  def show
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    # @blog_post = BlogPost.new(blog_post_params)
    @blog_post = current_user.blog_posts.build(blog_post_params)
    if @blog_post.save
        redirect_to @blog_post, alert: "Blog post was successfully created."
    else
        render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:blog_post][:remove_featured_image] == "1"
    @blog_post.featured_image.purge
  end

  if params[:blog_post][:featured_image].blank?
    params[:blog_post].delete(:featured_image)
  end

    if @blog_post.update(blog_post_params)
        redirect_to @blog_post, notice: "Blog post updated successfully."
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @blog_post.destroy
      redirect_to root_path
    end
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :featured_image, :remove_featured_image)
  end

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
      rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

    def authorize_user!
    unless @blog_post.user == current_user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  # How it works at the back
  # def authenticate_user!
  #   redirect_to new_user_session_path , alert: "You must sign in to continue" unless user_signed_in?
  # end
end