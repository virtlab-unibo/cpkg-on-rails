class InvitationMailer < ApplicationMailer
  default from: "donatini@dm.unibo.it"

  def invitation_email(invitation)
    @invitation = invitation
    mail(:to => 'donatini@dm.unibo.it',
         :subject => 'cpkg')
  end

end
