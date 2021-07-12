class DegreesController < ApplicationController
  skip_before_action :redirect_unsigned_user, only: [:index, :show]
  before_action :user_admin!, except: [:index, :show]

  def index
    @degrees = Degree.order(:code, :name)
  end

  def show
    @degree  = Degree.find(params[:id])
    @courses = @degree.courses.includes(:vlab_packages).order(:name).all
  end

  def new
    @degree = Degree.new
  end 

  def create
    @degree = Degree.new(degree_params)
    if @degree.save
      redirect_to degrees_path, notice: I18n.t('course_crtd_ok')
    else
      render action: :new
    end
  end

  def edit
    @degree = Degree.find(params[:id])
  end

  def update
    @degree = Degree.find(params[:id])
    if @degree.update(degree_params)
      flash[:notice] =  I18n.t 'course_updt_ok'
      redirect_to degrees_path
    else
      render action: :edit
    end
  end

  private 

  def degree_params
    params.require(:degree).permit(:name, :code)
  end
end
