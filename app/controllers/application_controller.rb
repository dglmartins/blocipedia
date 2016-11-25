class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  # add this before action to the controller of the view the user needs to be authenticated to see.
  #before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
