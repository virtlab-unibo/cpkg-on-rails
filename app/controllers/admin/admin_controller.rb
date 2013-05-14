class Admin::AdminController < ApplicationController
  before_filter :user_admin!

end

