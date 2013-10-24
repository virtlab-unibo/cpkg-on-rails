class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # https://github.com/plataformatec/devise/issues/2432
  skip_before_filter :verify_authenticity_token
  before_filter :log_omniauth, :check_invitation, :log_if_email

  # email="name.surname@gmail.com" first_name="Name" last_name="Surname" name="Name Surname"
  def google
    #logger.info("using google")
  end

  # email="usrBase@testtest.unibo.it" last_name="Base" name="SSO"
  def shibboleth
    #logger.info("using shibboleth")
  end

  def log_if_email
    oinfo = request.env['omniauth.auth'].info
    user = User.where(:email => oinfo.email.downcase).first
    if user
      logger.info "logging #{user.inspect} with sign_in_and_redirect"
      sign_in_and_redirect user, :event => :authentication    
      #sign_in user
      #redirect_to root_path
    else
      flash[:error] = "User #{oinfo.email} is not allowed. Please contact #{Rails.configuration.support_mail}"
      logger.info "#{oinfo.inspect} not allowed"
      redirect_to guest_courses_path
    end
  end

  def log_omniauth
    logger.info("shibboleth uid = #{request.env['omniauth.auth'].uid}")
    logger.info("shibboleth info = #{request.env['omniauth.auth'].info}")
    logger.info("shibboleth raw_info = #{request.env['omniauth.auth'].extra.raw_info}")
  end
  
  # if invited we create the user and log
  def check_invitation
    if params[:uuid] and Invitation.validate_uuid(params[:uuid], oinfo.email.downcase)
      logger.info("creating user on invitation #{params[:uuid]} #{oinfo.inspect}")
      user = User.create!(:email   => oinfo.email.downcase, 
                          :name    => oinfo.first_name || oinfo.name, 
                          :surname => oinfo.last_name)
      logger.info("created user #{user} on invitation")
    end
  end


  # we an use fake user only if
  # 1) configured in config/initializers
  # 2) have gem 'omniauth-fake' in Gemfile
  # 3) we are in development
  #def fake
  #  if Rails.configuration.ominiauth_simulator and defined?(OmniAuth::Strategies::Fake) and Rails.env.development? 
  #    oinfo = request.env['omniauth.auth'].info

  #    user = User.where(:email => oinfo.username).first
  #    if user
  #      sign_in_and_redirect user, :event => :authentication    
  #    else
  #      raise "#{oinfo} not in database"
  #    end
  #  else
  #    raise "Fake authentication not enabled"
  #  end
  #end
end
