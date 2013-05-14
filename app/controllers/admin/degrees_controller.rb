class Admin::DegreesController < ApplicationController
  before_filter :user_admin!

  def index
    @degrees = Degree.all
  end

  def new
    @degree = Degree.new
  end 

  def create
    @degree = Degree.new(params[:degree], :as => :admin)
    if @degree.save
      flash[:notice] = I18n.t 'course_crtd_ok'
      redirect_to admin_degrees_path
    else
      render :action => :new
    end
  end

  def edit
    @degree = Degree.find(params[:id])
  end

  def update
    @degree = Degree.find(params[:id])
    if @degree.update_attributes(params[:degree], :as => :admin)
      flash[:notice] =  I18n.t 'course_updt_ok'
      redirect_to admin_degrees_path
    else
      render :action => :edit
    end
  end
end
