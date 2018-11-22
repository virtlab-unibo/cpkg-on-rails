class PackagesController < ApplicationController

  # reach this also with url like '8080-so-2013'
  # get ':id', controller: "packages", action: "show", constraints: { id: /\d+-\w+-\d+/ }
  #def show
  #  @package = params[:id] =~ /^\d+$/ ? Package.find(params[:id]) : Package.find_by_name(params[:id])
  #  @other_packages = @package.course.vlab_packages - [@package]
  #end

  def search
    logger.info(params.inspect)
    is_full_search = true
    term = params[:q]
    res = Package.where(["LOWER(name) LIKE ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]).limit(100).select(:id, :name)
    render json: { status: :ok, res: res.to_json}
  end
end

