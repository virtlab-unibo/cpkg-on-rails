class CoursesController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :show]
  before_action :user_admin!, only: [:new, :create, :destroy]
  before_action :get_course_and_check_permission, only: [:edit, :update]

  # only teacher (current_user)
  # students sees degree_path(:id) for list of courses FIXME
  def index
    @courses = current_user.courses.includes(:vlab_packages, :degree)
  end

  def show
    @course = Course.includes(vlab_packages: :documents).find(params[:id])
    @packages = @course.vlab_packages.all
  end

  def new
    @degree = Degree.find(params[:degree_id])
    @course = @degree.courses.new(year: Date.today.year)
  end 

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to courses_path, notice: I18n.t('course_crtd_ok') 
    else
      render action: :new
    end
  end

  def destroy
    @course = Course.find(params[:id])
    if @course.destroy
      flash[:notice] = 'The course has been deleted.'
    else
      flash[:error] = 'The course can not be deleted.'
    end
    redirect_to courses_path
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
    authorize @course
  end

  def course_params
    params.require(:course).permit(:name, :degree_id, :abbr, :description, :year, :user_ids => [])
  end
end
