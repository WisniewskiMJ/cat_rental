# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_no_user, only: [:new, :create]
  before_action :require_user, except: [:new, :create]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user == current_user
      render :show
    else
      redirect_to cats_url
    end
  end

  def edit 
    @user = current_user
    if @user
      render :edit 
    else 
      redirect to cats_url
    end
  end

  def update
    @user = current_user
    return unless @user

    if @user.update(user_params)
      redirect_to user_url
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user == current_user
      @user.destroy
      redirect_to cats_url
    else
      redirect_to cats_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
