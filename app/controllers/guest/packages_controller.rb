class Guest::PackagesController < ApplicationController
  skip_filter :redirect_unsigned_user

  # remember in config/routes
  # match ':id', :controller => "guest::packages", :action => "show"
  # we reach this also with url like '8080-so-2013'
  def show
    @package = params[:id] =~ /^\d+$/ ? Package.find(params[:id]) : Package.find_by_name(params[:id])
    @course  = @package.course
    @other_packages = @course.packages - [@package]
  end
end

