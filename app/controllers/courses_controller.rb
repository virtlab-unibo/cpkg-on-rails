class CoursesController < ApplicationController
  def index
    @courses = current_user.courses.includes(:packages)
  end

  def edit
    @course = Course.find(params[:id])
    authorize! :manage, @course
  end

  def update
    @course = Course.find(params[:id])
    authorize! :manage, @course
    @course.description = params[:course][:description]
    @course.save
    redirect_to courses_path
  end

  def show
    @course = Course.find(params[:id])
  end

end
