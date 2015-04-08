class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include DmCommonHelper 

  impersonates :user

  before_filter :handle_guest, :set_locale

  def handle_guest
    devise_controller? and return true
    if user_signed_in? 
      logger.info("Current user: #{current_user.upn}")
    else
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

  # for unibo shibboleth
  private

  def after_sign_out_path_for(resource_or_scope)
    cookies.each do |c|
      cookies.delete(c[0].to_sym)
    end
    reset_session
    logger.info("called after_sign_out_path_for")
    '/greencheck.gif'
  end
end
