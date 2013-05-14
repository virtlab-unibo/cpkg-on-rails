class Admin::CoursesController < ApplicationController
  before_filter :user_admin!

  def index
    @courses = Course.includes(:users, :degree).all
  end

  def new
    @course = Course.new
    @course.year = Date.today.year
  end 

  def create
    @course = Course.new(params[:course], :as => :admin)
    if @course.save
      flash[:notice] = I18n.t 'course_crtd_ok'
      redirect_to admin_courses_path
    else
      render :action => :new
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course], :as => :admin)
      flash[:notice] =  I18n.t 'course_updt_ok'
      redirect_to admin_courses_path
    else
      render :action => :edit
    end
  end
end
