class DocumentsController < ApplicationController
  respond_to :json

  def index
    package = Package.find(params[:package_id])
    @documents = package.documents
    render :json => @documents.map{ |d| { :name => d.name,
                                          :size => d.attach_file_size, 
                                          # FIXME aaaaarrrrrghhhhh
                                          # d.attach.url non funziona da solo
                                          :url  => d.attach.url, # attach.url(:original),
                                          :delete_url  => document_path(d), # http://api.rubyonrails.org/classes/ActionDispatch/Routing/UrlFor.html
                                          :delete_type => "DELETE" } } 
  end

  def edit
    @document = Document.find(params[:id])
  end

  def create
    package = Package.find(params[:package_id])
    @document = package.documents.new(params[:document])
    # set the name of the document as the filename
    # Remember: we cannot get an arbitrary name for the document
    # if we want to upload multiple documents at a time. Cause
    # there can only be one inputfield with the right name.
    params[:document][:attach].original_filename = params[:document][:attach].original_filename.gsub(/[^0-9A-Za-z.\-_]/, '')
    @document.name = params[:document][:attach].original_filename

    # FIXME 
    # check_ownership
    if @document.save
      render json: {files: [@document.to_jq_upload]}, status: :created, location: @document

      #render :json => [{ :name => @document.name,
      #                   :size => @document.attach_file_size,
      #                   # :url  => '/cpkg' + @document.attach.url }, 
      #                   :url  => @document.attach.url(:original),
      #                   :delete_url => document_path(self),
      #                   :delete_type => "DELETE"}, 
      #                   :status   => 'created', 
      #                   :location => @document ]
    else
      # FIXME 
      render :json => [@document.errors, status: :unprocessable_entity]
    end
  end

  def update
    @document = Document.find(params[:id])
    @document.name = params[:document][:name]
    @document.description = params[:document][:description]
    if @document.save
      flash[:notice] = I18n.t 'updated_attachment' 
      redirect_to edit_package_path(@document.package.id, :anchor => 'materiale')
    else
      render :edit
    end 
  end

  def destroy
    @document = Document.find(params[:id])
    user_owns!(@document.package.course)
    @document.destroy
    respond_to do |format|
      format.html { redirect_to edit_package_path(document.package.id, :anchor => 'materiale') }
      format.json { head :no_content }
    end
  end

end

