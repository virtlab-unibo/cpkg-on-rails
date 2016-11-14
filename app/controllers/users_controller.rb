class UsersController < ApplicationController
  skip_before_action :handle_guest

  def impersonate
    if true_user.is_admin?
      user = User.find(params[:id])
      impersonate_user(user)
    end
    redirect_to root_path
  end

  # do not require admin for this method if access control
  # is performed on the current_user instead of true_user
  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end
end

