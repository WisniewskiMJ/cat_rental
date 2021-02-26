# frozen_string_literal: true

class CatsController < ApplicationController
  before_action :require_user, except: %i[index show]

  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find_by(id: params[:id])

    if @cat
      render :show
    else
      redirect_to cats_url
    end
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      flash[:success] = 'You have succesfully added a new cat'
      redirect_to cat_url(@cat)
    else
      flash.now[:danger] = @cat.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find_by(id: params[:id])
    if @cat
      render :edit
    else
      redirect_to cats_url
    end
  end

  def update
    @cat = current_user.cats.find_by(id: params[:id])
    return unless @cat

    if @cat.update(cat_params)
      flash[:success] = 'Your cat has been succesfully updated'
      redirect_to cat_url(@cat)
    else
      flash.now[:danger] = @cat.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end

end
