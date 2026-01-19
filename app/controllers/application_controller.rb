class ApplicationController < ActionController::Base
  include Authentication
  # This ensures that even on "Guest" pages, we check if an admin is present
  # so the menu shows "Sair" instead of "Login".
  before_action :resume_session
end