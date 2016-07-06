class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include DmUniboCommon::Controllers::Helpers

  impersonates :user

  before_filter :log_current_user, :handle_guest, :set_locale

  def handle_guest
    devise_controller? and return true
    if ! user_signed_in? 
      redirect_to guest_courses_path and return
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def user_admin!
    current_user.admin or raise "NO ADMIN"
  end

end
