class Guest::CoursesController < ApplicationController
  skip_before_action :redirect_unsigned_user

  def index
    @courses = Course.includes(:degree, :vlab_packages).order('degrees.code').all
  end

  # the show is the index with the @course selected
  def show
    @course = Course.find(params[:id])
    @courses = @course.degree.courses.includes(:degree).order('degrees.code')
    render action: :index
  end
end

