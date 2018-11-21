class ChangelogsController < ApplicationController
  before_action :get_package_and_check_permission, only: [:new, :create]

  def new
    @changelog = @package.changelogs.new
  end

  # create the debian package and put it into the config.reprepro_incomingdir
  def create
    @changelog = @package.changelogs.new(changelog_params)
    @changelog.user_id = current_user.id

    if ! File.file?(Rails.configuration.reprepro_command)
      flash[:error] = "Missing #{Rails.configuration.reprepro_command}. Try apt-get install reprepro."
      render action: :new
      return
    end

    res = false
    begin
      Package.transaction do
        @changelog.save! 
        # NB. we've to reload the package contents from db to get the right version of the package.
        @package.reload
        equivs = ActiveDebianRepository::Equivs.new(@package, Rails.configuration.reprepro_incomingdir)
        equivs.create!
        flash[:notice] = I18n.t 'pkg_upld_ok'
      end
    rescue => err
      logger.info "ChangelogsController: Failed to create the package: #{err}"
      flash[:error] = I18n.t 'pkg_upld_no'
    end

    `#{Rails.configuration.reprepro_exec}`

    redirect_to courses_path
  end

  private

  def get_package_and_check_permission
    @package = VlabPackage.find(params[:vlab_package_id])
    authorize @package
  end

  def changelog_params
    params.require(:changelog).permit(:description)
  end

end
