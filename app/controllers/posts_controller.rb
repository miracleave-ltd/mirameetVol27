class PostsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]

  def index
    @posts = Post.includes(:user).order("created_at DESC").page(params[:page]).per(5)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(image: post_params[:image], text: post_params[:text], user_id: current_user.id)
    if @post.save
      redirect_to posts_path and return
    end
    respond_to do |format|
      format.html { render :new }
      format.js { render 'layouts/errors' }
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
      redirect_to posts_path and return
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id && @post.update(post_params)
      redirect_to posts_path and return
    end
    respond_to do |format|
      format.html { render :edit }
      format.js { render 'layouts/errors' }
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user)
  end

  private
  def post_params
    params.require(:post).permit(:image, :text)
  end

  def move_to_index
    redirect_to action: index unless user_signed_in?
  end

end
