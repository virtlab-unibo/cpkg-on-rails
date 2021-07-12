class ApplicationController < DmUniboCommon::ApplicationController
  before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :set_locale, :redirect_unsigned_user
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]

  def set_locale
    if params[:locale] and I18n.config.available_locales.inspect.include?(params[:locale])
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
