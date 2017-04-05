class PostsController < ApplicationController

  before_action :require_user, only: [:new, :create]
  before_action :fetch_post, only: [:edit, :destroy, :update]

  def index
    if params[:user_id].present?
      @posts = Post.ordered.by_user(params[:user_id]).page(params[:page]).per 5
    else
      @posts = Post.published.ordered.page(params[:page]).per 5
    end
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
    @post = Post.includes(:comments).find params[:id]
    @comments = @post.comments.ordered
  end

  def destroy
    authorize! :destroy, @post
    @post.destroy
    redirect_to root_path, notice: "successfully destroyed"
  end

  def edit
    authorize! :edit, @post
  end

  def update
    authorize! :edit, @post
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post successfully edited"
    else
      render :new
    end
  end

  def by_tag
    tag = Tag.find_by_name params[:tag]
    @posts = tag.posts.published.ordered.page(params[:page]).per 5
    render :index
  end

  private

  def post_params
    params.require(:post).permit!
  end

  def fetch_post
    @post = Post.find params[:id]
  end

end
