class InvitationsController < ApplicationController
  skip_before_action :handle_guest

  def register
    if Invitation.validate_uuid(params[:uuid])
      user = User.get_from_sso_session(env, fake_upn)
      logger.info("registrato #{user.inspect}")
      redirect_to root_path and return
    end
  end

  def fake_upn
    "valeria.montesi3@unibo.it"
    nil
    "pietro.donatini@unibo.it"
  end

end


