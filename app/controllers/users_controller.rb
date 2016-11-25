class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @wikis = Wiki.where(user: @user)
  end
end
