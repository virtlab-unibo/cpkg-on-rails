class CoursesController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :show]
  before_action :get_course_and_check_permission, only: [:edit, :update]

  # only teacher (current_user)
  # students sees degree_path(:id) for list of courses FIXME
  def index
    @courses = current_user.courses.includes(:packages, :degree)
  end

  def show
    @course = Course.includes(packages: :documents).find(params[:id])
    @packages = @course.packages.all
  end

  def edit
  end

  def update
    @course.description = params[:course][:description]
    if @course.save
      redirect_to courses_path, notice: 'OK'
    else
      render action: :edit
    end
  end

  private

  def get_course_and_check_permission
    @course = Course.find(params[:id])
    authorize! :manage, @course
  end
end
