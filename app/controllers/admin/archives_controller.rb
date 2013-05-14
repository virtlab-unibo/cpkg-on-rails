# -*- coding:  utf-8 -*-
class Admin::ArchivesController < ApplicationController
  before_filter :user_admin!

  def index
    @archives = Archive.all
  end

  def new
    @archive = Archive.new(Archive.default_attributes)
  end 

  def create
    @archive = Archive.new(params[:archive])
    if @archive.save
      flash[:notice] = I18n.t 'repo_ins_ok' 
      redirect_to admin_archives_path
    else
      render :action => :new
    end
  end

  def sync
    @archive = Archive.find(params[:id])
    logger.info("going to sync #{@archive.inspect}")
    begin
      @archive.update_db_in_background
      flash[:notice] = I18n.t 'repo_updated_ok' 
    rescue => e
      logger.info e 
      flash[:error] = I18n.t 'repo_updated_no' 
    end
  end

  def destroy
    archive = Archive.find(params[:id])
    # FIXME: we should change mysql policy on repo drop (on delete cascade)
    begin
      archive.destroy
      flash[:notice] = I18n.t 'repo_del_ok'
    rescue
      flash[:error] = I18n.t 'repo_del_no'
    end
    redirect_to admin_archives_path
  end

end
