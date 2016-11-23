class DegreesController < ApplicationController
  skip_before_action :redirect_unsigned_user

  def index
    @degrees = Degree.order(:code, :name)
  end

  def show
    @degree  = Degree.find(params[:id])
    @courses = @degree.courses.includes(:packages).order(:name)
  end

end
