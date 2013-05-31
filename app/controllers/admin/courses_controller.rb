class Admin::CoursesController < ApplicationController
  before_filter :user_admin!

  def index
    @courses = Course.includes(:users, :degree)
  end

  def new
    @course = Course.new
    @course.year = Date.today.year
  end 

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to admin_courses_path, :flash => { :notice => I18n.t('course_crtd_ok') }
    else
      render :action => :new
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      redirect_to admin_courses_path, :flash => { :notice =>  I18n.t('course_updt_ok') }
    else
      render :action => :edit
    end
  end
  
  private

  def course_params
    params.require(:course).permit(:name, :degree_id, :abbr, :description, :year, :user_ids => [])
  end
end
