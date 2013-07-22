# -*- coding: utf-8 -*-
class Admin::CorepackagesController < ApplicationController
  respond_to :json, :only => :search

  def new
#    @course = Course.find(params[:course_id])
    #authorize! :manage, @course
    @corepackage = Corepackage.new
  end

  def edit 
    @corepackage = Corepackage.find(params[:id])
    @documents = @corepackage.documents
  end

  def index
    @corepackages = Corepackage.all
  end

  def create
#    @course = Course.find(params[:course_id])
#    authorize! :manage, @course
    @cpackage = Corepackage.new(corepackage_params)
    if @cpackage.save
      flash[:notice] = I18n.t 'package_crtd_ok'
      redirect_to admin_corepackages_path # admin_corepackage_path(@cpackage)
    else
      render :new
    end
  end

  def show
    @corepackage = Corepackage.find(params[:id])
  end

  def del_doc
    #TODO: implement delete document
  end

  def add_doc
    #TODO: implement add document
  end

  def destroy
    #    @package = Package.find(params[:id])
    #    authorize! :manage, @course
    raise "Non si puo' eliminare"
  end

  def update
    @corepackage = Corepackage.find(params[:id])
    #    @course = @package.course
    #    authorize! :manage, @course
    # name and dependencies cannot be changed 
    params[:corepackage].delete(:name)
    params[:corepackage].delete(:depends)
    if @corepackage.update_attributes(corepackage_params)
      flash[:notice] = I18n.t 'package_updt_ok'
      redirect_to edit_admin_corepackage_path(@corepackage)
    else
      logger.info @package.errors.inspect
      render :action => :new
    end
  end

  def depend
         @package = Corepackage.find(params[:id])
         #    authorize! :manage, @package.course
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
         redirect_to edit_admin_corepackage_path(@package, :anchor => 'software')
  end

  def undepend
    @package = Corepackage.find(params[:id])
    #    authorize! :manage, @package.course
    if @package.remove_dependency(params[:depend])
      flash[:notice] = I18n.t 'dep_rem_ok'
    else
      logger.info @package.errors.inspect
      flash[:notice] = I18n.t 'dep_rem_no'
    end
    redirect_to edit_admin_corepackage_path(@package, :anchor => 'software')
  end

  def script
    @package = Corepackage.find(params[:id])
    script = @package.get_script params[:stype]
    res = false
    if script
      if params[:content].strip != ""
        File.open(script, 'w'){|file| file.write(params[:content]) } 
        res = true
      else
       res = true if @package.get_script_object(params[:stype]).destroy
      end
    else #FIXME: check that stype is correct and not a nonsense string
      res = @package.add_script params[:stype], params[:content]
    end
    if res
      flash[:notice] = "The #{params[:stype]} script has been updated successfully" # I18n.t 'dep_rem_no'
    else
      flash[:error] = "Something went wrong! :(" # I18n.t 'dep_rem_no'
    end
    redirect_to edit_admin_corepackage_path(@package, :anchor => 'script')
  end

  def download
    #    @package = Package.find(params[:id])
    #FIXME: If we set a different version we break 
    # the package creation cause equivs use the version
    # into the changelogs
    #@package.version = "0.temporary"
    #    begin
    #      dest_dir = Rails.configuration.tmp_packages_dir
    #      equivs = ActiveDebianRepository::Equivs.new(@package, dest_dir) 
    #      path = equivs.create!
    #      send_file path, :type => "application/x-debian-package"
    #    rescue 
    #      flash[:error] = I18n.t 'del_pkg_error'
    #      redirect_to courses_path
    #    end
  end

 private

  def corepackage_params
    # only authorized. Shall we move authorize! here
    params.require(:corepackage).permit(:name, :short_description, :long_description, :depends, :homepage, :global, :version, :action)
  end

end
