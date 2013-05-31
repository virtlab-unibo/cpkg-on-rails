class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # FIXME FIXME FIXME
  skip_before_filter :verify_authenticity_token

  # email="donapieppo@gmail.com" first_name="Pieppo" last_name="Dona" name="Pieppo Dona"
  def google
    logger.info("google uid = #{request.env['omniauth.auth'].uid}")
    logger.info("google info = #{request.env['omniauth.auth'].info}")

    oinfo = request.env['omniauth.auth'].info

    # if invited we create the user and log
    if params[:uuid] and Invitation.validate_uuid(params[:uuid], oinfo.email)
      logger.info("creating user on invitation #{params[:uuid]} #{oinfo.inspect}")
      user = User.create!(:email   => oinfo.email, 
                          :name    => oinfo.first_name, 
                          :surname => oinfo.last_name)
      logger.info("created user #{user} by invitation")
    end

    user = User.where(:email => oinfo.email).first

    if user
      logger.info "logging #{user.inspect} with sign_in_and_redirect"
      #sign_in_and_redirect user, :event => :authentication    
      sign_in user
      redirect_to root_path
    else
      flash[:error] = "User #{oinfo.email} is not allowed. Please contact #{Rails.configuration.support_mail}"
      logger.info "#{oinfo.inspect} not allowed"
      redirect_to guest_courses_path
    end
  end

  def shibboleth
    logger.info("shibboleth uid = #{request.env['omniauth.auth'].uid}")
    logger.info("shibboleth info = #{request.env['omniauth.auth'].info}")

    oinfo = request.env['omniauth.auth'].info
    raise oinfo.inspect
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
