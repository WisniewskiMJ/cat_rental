# frozen_string_literal: true

class CatRentalRequestsController < ApplicationController
  before_action :require_user
  before_action :require_ownership, only: %i[approve deny]

  def new
    @cats = Cat.all
    @cat = Cat.find_by(id: params[:cat_id])
  end

  def create
    @request = current_user.requests.new(cat_rental_request_params)
    if @request.save
      puts 'SAVE'
      flash[:success] = 'Your request has been submitted'
      redirect_to cat_url(@request[:cat_id])
    else
      puts 'NO SAVE'
      flash[:danger] = @request.errors.full_messages.to_sentence
      redirect_to new_cat_rental_request_url(cat_id: (@request[:cat_id]))
    end
  end

  def approve
    @request = CatRentalRequest.find_by(id: params[:id])
    @request.approve!
    redirect_to cat_url(@request[:cat_id])
  end

  def deny
    @request =  CatRentalRequest.find_by(id: params[:id])
    @request.deny!
    redirect_to cat_url(@request[:cat_id])
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def require_ownership
    @request = CatRentalRequest.find_by(id: params[:id])
    cat = @request.cat
    redirect_to cats_url unless current_user && cat.owner.id == current_user.id
  end
end
