# frozen_string_literal: true

class CatRentalRequest < ApplicationRecord
  STATUSES = %w[PENDING APPROVED DENIED].freeze

  validates :cat_id, presence: true
  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :not_backwards_in_time
  validate :does_not_overlap

  belongs_to :cat,
             primary_key: :id,
             class_name: :Cat

  belongs_to :requester,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User

  def approve!
    if status != 'PENDING'
      raise 'not pending'
    else
      transaction do
        overlapping_pending_requests.each do |r|
          r.status = 'DENIED'
          r.save
        end
        self.status = 'APPROVED'
        save
      end
    end
  end

  def deny!
    self.status = 'DENIED'
    save
  end

  def not_backwards_in_time
    errors[:end_date] << "can't be earlier than start date" if start_date > end_date
  end

  def overlapping_requests
    CatRentalRequest.where('cat_id = ?', cat_id)
                    .where.not('id = ?', id)
                    .where.not('start_date > ? OR end_date < ?',
                               end_date, start_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where('status = ?', 'APPROVED')
  end

  def overlapping_pending_requests
    overlapping_requests.where('status = ?', 'PENDING')
  end

  def does_not_overlap
    errors[:overlaps] << 'with another request' if overlapping_approved_requests.exists?
  end
end
