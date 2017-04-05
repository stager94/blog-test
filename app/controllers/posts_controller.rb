class PostsController < ApplicationController

  before_action :require_user, only: [:new, :create]
  before_action :fetch_post, only: [:show, :edit, :destroy, :update]

  def index
    @posts = Post.published.page(params[:page]).per 5
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new post_params
    if @post.save
      redirect_to root_path, notice: "A new post successfully created"
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: "successfully destroyed"
  end

  def edit
  end

  def update
    if @post.save
      redirect_to post_path(@post), notice: "Post successfully edited"
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit!
  end

  def fetch_post
    @post = Post.find params[:id]
  end

end
