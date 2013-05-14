class Invitation < ActiveRecord::Base

  DAYS_BEFORE_EXPIRATION = 90

  before_create :force_unique_email,
                :generate_uuid,
                :generate_expiration

  def generate_uuid
    self.uuid = SecureRandom.hex(30)
  end

  def force_unique_email
    Invitation.where(:email => self.email).destroy_all
  end

  def generate_expiration
    self.expiration = Date.today + DAYS_BEFORE_EXPIRATION.days
  end

  def self.validate_uuid(uuid, email)
    invitation = Invitation.where(:uuid => uuid, :email => email).first
    invitation or return false
    if invitation.expiration < Date.today
      logger.info "#{invitation.inspect} expired"
      return false
    end
    invitation.destroy
    true
  end
    
end

