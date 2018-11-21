class UsersController < ApplicationController
  before_action :user_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new   
    @user = User.new
  end 

  def create
    @user = User.new(params[:user], as: :admin)
    if @user.save
      flash[:notice] = I18n.t 'user_crtd_ok'
      redirect_to users_path
    else
      render action: :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.courses.empty? and @user.packages.empty?
      @user.destroy
    end
    redirect_to users_path
  end
end

