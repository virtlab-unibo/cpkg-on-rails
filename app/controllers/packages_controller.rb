# -*- coding: utf-8 -*-
class PackagesController < ApplicationController
  
  # for the jquery autocomplete
  autocomplete :package, :name, :full => true #, :extra_data => [:description]

  def new
    @course = Course.find(params[:course_id])
    authorize! :manage, @course
    @package = @course.packages.new
  end

  def edit 
    @package = Package.find(params[:id])
    @course = @package.course
  end

  def create
    @course = Course.find(params[:course_id])
    authorize! :manage, @course
    @package = @course.packages.new(params[:package])
    if @package.save
      flash[:notice] = I18n.t 'package_crtd_ok'
      redirect_to edit_package_path(@package)
    else
      @package.name = nil
      render :new
    end
  end

  def destroy
    @package = Package.find(params[:id])
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
    if @package.update_attributes(params[:package])
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
    if @package.add_dependency(params[:depend])
      flash[:notice] = I18n.t 'added_dep_ok' 
    else
      logger.info @package.errors.inspect
      # FIXME refactor...
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
    @package.version = "0.temporary"
    begin
      path = @package.create_deb!(@package.package_options[:tmp_dir])
      send_file path, :type => "application/x-debian-package"
    rescue 
      flash[:error] = I18n.t 'del_pkg_error'
      redirect_to courses_path
    end
  end

end
