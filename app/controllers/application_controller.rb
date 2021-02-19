# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil unless session[:session_token]

    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  private

  def require_no_user
    redirect_to cats_url if current_user
  end

  def require_user
    return if current_user

    flash[:danger] = 'You have to be logged in to access that section'
    redirect_to cats_url
  end

end
