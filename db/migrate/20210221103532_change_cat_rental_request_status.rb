class ChangeCatRentalRequestStatus < ActiveRecord::Migration[5.2]
  def change
    remove_column :cat_rental_requests, :status, :string
    add_column :cat_rental_requests, :status, :integer, default: 10, null: false
  end
end
