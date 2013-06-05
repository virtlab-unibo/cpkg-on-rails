class ChangelogsController < ApplicationController

  def new
    @package = Package.find(params[:package_id])
    @changelog = @package.changelogs.new
  end

  # create the debian package and put it into the repo_dir
  def create
    @package = Package.find(params[:package_id])
    @changelog = @package.changelogs.new(changelog_params)
    @changelog.user_id = current_user.id
    res = false
    begin
      Package.transaction do
        @changelog.save! 
        # NB. we've to reload the package contents from 
        # db to get the right version of the package.
        # Maybe there's a better way
        @package.reload
        dest_dir = Rails.configuration.repo_dir
        equivs = ActiveDebianRepository::Equivs.new(@package, dest_dir) 
        res = equivs.create!
      end
    rescue => err
      logger.info "ChangelogsController, Failed to create the package: #{err}"
      # reload the previous state from db. (maybe it's unnecessary)
      # NB changelog doesn't exist then it doesn't need to be reloaded.
      @package.reload
    end
    if res 
      flash[:notice] = I18n.t 'pkg_upld_ok' 
      redirect_to courses_path
    else
      flash[:error] = I18n.t 'pkg_upld_no'
      redirect_to courses_path
    end

  end

  private

  def changelog_params
    params.require(:changelog).permit(:description)
  end

end
