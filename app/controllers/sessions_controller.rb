# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_user, except: [:destroy]

  def new
    render :new
  end

  def create
    @user = User.confirm_credentials(params[:user][:username],
                                     params[:user][:password])
    if @user
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to cats_url
  end
end
