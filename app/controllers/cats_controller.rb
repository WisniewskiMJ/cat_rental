# frozen_string_literal: true

class CatsController < ApplicationController
  before_action :require_user, except: %i[index show]

  def index
    @cats = Cat.all
    render :index
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
    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
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
    if @cat
      if @cat.update(cat_params)
        redirect_to cat_url(@cat)
      else
        render :edit
      end
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end

  def require_owner
    require_user
    flash.now[:alert] = 'You have to be owner to edit a cat'
  end
end
