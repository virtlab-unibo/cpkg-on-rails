class Admin::InvitationsController < ApplicationController
  before_action :user_admin!

  def index
    @invitations = Invitation.order(:expiration).all
  end

  def new   
    @invitation = Invitation.new
  end 

  def create
    @invitation = Invitation.new
    @invitation.email = params[:invitation][:email]
    if @invitation.save
      InvitationMailer.invitation_email(@invitation).deliver
      flash[:notice] = "L'utente #{@invitation.email} e' stato invitato con una mail"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

end


