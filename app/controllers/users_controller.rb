class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @my_private_wikis =  Wiki.where(user: @user, private: true)
    @my_public_wikis =  Wiki.where(user: @user, private: false)
    @wikis_i_collaborate = Wiki.joins(:collaborators).where(collaborators: { user: @user })
  end
end
