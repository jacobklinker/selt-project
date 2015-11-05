class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :auth_outside_test
  
  protected
    # this method should be placed in ApplicationController
    def auth_outside_test
      head(:authenticate_user!) unless Rails.env.test?
    end
end
