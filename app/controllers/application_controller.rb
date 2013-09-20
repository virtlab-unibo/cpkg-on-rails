class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  impersonates :user

  before_filter :handle_guest, :set_locale

  def handle_guest
    devise_controller? and return true
    user_signed_in? or redirect_to guest_courses_path
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

  # FIXME
  # for shibboleth
  private

  # Overwriting the sign_out redirect path method
  #def after_sign_out_path_for(resource_or_scope)
  # ActionController::Base.helpers.asset_path('greencheck.gif')
  #end
end
