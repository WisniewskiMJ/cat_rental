# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_user, except: [:destroy]

  def new
  end

  def create
    @user = User.confirm_credentials(params[:user][:username],
                                     params[:user][:password])
    if @user
      login(@user)
      flash[:success] = 'You have been logged in'
      redirect_to cats_url
    else
      flash.now[:danger] = "Username and password doesn't match"
      render :new
    end
  end

  def destroy
    logout
    flash[:success] = 'You have been logged out'
    redirect_to cats_url
  end

end
