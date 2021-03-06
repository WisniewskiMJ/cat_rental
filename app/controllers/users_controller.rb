# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_no_user, only: %i[new create]
  before_action :require_user, except: %i[new create]

  def new; end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      email = UserMailer.welcome_email(@user)
      email.deliver
      flash[:success] = 'Your account has been created'
      redirect_to user_url(@user)
    else
      flash.now[:danger] = @user.errors.full_messages.to_sentence
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
    @user = User.find_by(id: params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to cats_url
    end
  end

  def update
    @user = current_user
    return unless @user

    if @user.update(user_params)
      flash[:success] = 'Your account has been succesfully updated'
      redirect_to user_url
    else
      flash.now[:danger] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy if @user == current_user
    redirect_to cats_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
