class CoursesController < ApplicationController
  before_action :get_course_and_check_permission, only: [:edit, :update]

  def index
    @courses = current_user.courses.includes(:packages)
  end

  def edit
  end

  def update
    @course.description = params[:course][:description]
    if @course.save
      redirect_to courses_path, notice 'OK'
    else
      render action: :edit
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  def get_course_and_check_permission
    @course = Course.find(params[:id])
    authorize! :manage, @course
  end
end
