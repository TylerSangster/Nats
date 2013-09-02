class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper

  def set_current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_current_user
  	redirect_to login_url, alert: "Please login" unless set_current_user
	end

	helper_method :set_current_user

  def require_correct_user
  	redirect_to root_url if set_current_user != User.find(params[:id])
	end

end
