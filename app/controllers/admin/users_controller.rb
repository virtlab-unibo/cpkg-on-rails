# -*- coding:  utf-8 -*-
class Admin::UsersController < ApplicationController
  before_filter :user_admin!

  def index
    @users = User.all
  end

  def new   
    @user = User.new
  end 

  def create
    @user = User.new(params[:user], :as => :admin)
    if @user.save
      flash[:notice] = I18n.t 'user_crtd_ok'
      redirect_to admin_users_path
    else
      render :action => :new
    end
  end

  def destroy
    # FIXME: we need to carefully think about this.
    flash[:notice] = I18n.t 'user_del_ok'
    redirect_to admin_users_path
  end

end

