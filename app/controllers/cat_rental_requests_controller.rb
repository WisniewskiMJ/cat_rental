class CatRentalRequestsController < ApplicationController
  before_action :require_user
  before_action :require_ownership, only: [:approve, :deny]

  def new
    render :new
  end

  def create
    @request = CatRentalRequest.new(cat_rental_request_params)
    if @request.save
      redirect_to cat_url(@request[:cat_id])
    else
      render :new
    end
  end

  def approve
    @request =  CatRentalRequest.find_by(id: params[:id])
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
    @request =  CatRentalRequest.find_by(id: params[:id])
    cat = @request.cat
    redirect_to cats_url if !(current_user && cat.owner.id == current_user.id)
  end

end
