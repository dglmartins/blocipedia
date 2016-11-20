class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # add this before action to the controller of the view the user needs to be authenticated to see.
  #before_action :authenticate_user!
end
