class Admin::AdminController < ApplicationController
  before_action :user_admin!

end

