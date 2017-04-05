class UsersController < ApplicationController

  before_action :fetch_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to Blog, #{@user.email}!"
    else
      render :new
    end
  end

  def edit
    authorize! :edit, @user
  end

  def update
    authorize! :edit, @user
    if @user.authenticate params[:user][:current_password]
      update_user
    else
      flash.now.alert = "Invalid current_password"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :password_confirmation
  end

  def fetch_user
    @user = User.find params[:id]
  end

  def update_user
    if @user.update user_params
      redirect_to edit_user_path(@user), notice: "Password Successfully Updated"
    else
      render :edit
    end
  end

end
