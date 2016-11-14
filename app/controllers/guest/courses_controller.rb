class Guest::CoursesController < ApplicationController
  skip_before_action :redirect_unsigned_user

  def index
    @courses = Course.includes(:degree, :packages).order('degrees.code').all
  end

  # the show is the index with the @course selected
  def show
    @courses = Course.includes(:degree).order('degrees.code')
    @course = Course.find(params[:id])
    render action: :index
  end

end

