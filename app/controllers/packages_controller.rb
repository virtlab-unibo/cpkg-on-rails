# -*- coding: utf-8 -*-
class PackagesController < ApplicationController
  respond_to :json, :only => :search

  def get_model
    Package
  end

  def new
    @course = Course.find(params[:course_id])
    authorize! :manage, @course
    @package = @course.packages.new
  end

  def edit 
    @package = get_model.find(params[:id])
    @course = @package.course
  end

  def create
    @course = Course.find(params[:course_id])
    authorize! :manage, @course
    @package = @course.packages.new(package_params)
    if @package.save
      flash[:notice] = I18n.t 'package_crtd_ok'
      redirect_to edit_package_path(@package)
    else
      @package.name = nil
      render :new
    end
  end

  def destroy
    @package = get_model.find(params[:id])
    authorize! :manage, @course
    raise "Non si puo' eliminare"
  end

  def update
    @package = Package.find(params[:id])
    @course = @package.course
    authorize! :manage, @course
    # name and dependencies cannot be changed 
    params[:package].delete(:name)
    params[:package].delete(:depends)
    if @package.update_attributes(package_params)
      flash[:notice] = I18n.t 'package_updt_ok'
      redirect_to edit_package_path(@package)
    else
      logger.info @package.errors.inspect
      render :action => :new
    end
  end

  def depend
    @package = Package.find(params[:id])
    authorize! :manage, @package.course
    if Package.where(:name => params[:depend]).count > 0
      if @package.add_dependency(params[:depend])
        flash[:notice] = I18n.t 'added_dep_ok' 
      else
        logger.info @package.errors.inspect
        # FIXME refactor...
        flash[:error] = @package.errors[:base].join(', ')
      end
    else
      @package.errors.add(:base, "Unknown package #{params[:depend]}")
      flash[:error] = @package.errors[:base].join(', ')
    end
    # FIXME to refactor 
    redirect_to edit_package_path(@package, :anchor => 'software')
  end

  def undepend
    @package = Package.find(params[:id])
    authorize! :manage, @package.course
    if @package.remove_dependency(params[:depend])
      flash[:notice] = I18n.t 'dep_rem_ok'
    else
      logger.info @package.errors.inspect
      flash[:notice] = I18n.t 'dep_rem_no'
    end
    redirect_to edit_package_path(@package, :anchor => 'software')
  end

  def download
    @package = Package.find(params[:id])
    #FIXME: If we set a different version we break 
    # the package creation cause equivs use the version
    # into the changelogs
    #@package.version = "0.temporary"
    begin
      dest_dir = Rails.configuration.tmp_packages_dir
      equivs = ActiveDebianRepository::Equivs.new(@package, dest_dir) 
      path = equivs.create!
      send_file path, :type => "application/x-debian-package"
    rescue 
      flash[:error] = I18n.t 'del_pkg_error'
      redirect_to courses_path
    end
  end

  def search
    logger.info(params.inspect)
    is_full_search = true
    term = params[:q]
    res = Package.where(["LOWER(name) LIKE ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]).limit(10).select(:id, :name)
    # render :json => { :status => :ok, :res => res.to_json}
    render :json => { :status => :ok, :res => res.to_json}
  end

  private

  def package_params
    # only authorized. Shall we move authorize! here
    params.require(:package).permit(:name, :short_description, :long_description, :depends, :homepage, :documents, :version, :filename)
  end

end
