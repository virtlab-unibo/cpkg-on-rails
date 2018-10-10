class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  include DmUniboCommon::Controllers::Helpers

  impersonates :user

  before_action :check_shibboleth_user, :log_current_user, :redirect_unsigned_user, :set_locale

  # if auth is shibboleth and user il logged in apache but not here
  def check_shibboleth_user
    if Rails.configuration.dm_unibo_common[:omniauth_provider] == :shibboleth and session[:shibboleth_checked] == nil
      logger.info("checking shibboleth one time")
      session[:shibboleth_checked] = true
      redirect_to auth_shibboleth_callback_path and return 
    end
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
