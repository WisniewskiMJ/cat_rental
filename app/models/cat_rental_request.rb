class CatRentalRequest < ApplicationRecord

  STATUSES = %w(PENDING APPROVED DENIED)

  validates :cat_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :not_backwards_in_time
  validate :does_not_overlap

  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :Cat

  def approve!
    if self.status != 'PENDING'
      raise 'not pending'
    else
      transaction do
        self.status = 'APPROVED'
        self.save
        overlapping_pending_requests.each do |request|
          request.status = 'DENIED'
          request.save
        end
      end
    end
  end

  def deny!
    self.status = 'DENIED'
    self.save
  end

  def not_backwards_in_time
    if start_date > end_date
      errors[:end_date] << "can't be earlier than start date"
    end
  end

  def overlapping_requests
    CatRentalRequest.where('cat_id = ?', cat_id)
                    .where.not('id = ? AND (start_date > ? OR end_date < ?)',
                                id, end_date, start_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where('status = ?', 'APPROVED')
  end

  def overlapping_pending_requests
    overlapping_requests.where('status = ?', 'PENDING')
  end

  def does_not_overlap
    if overlapping_approved_requests.exists?
      errors[:overlaps] << "with another request"
    end
  end

end
