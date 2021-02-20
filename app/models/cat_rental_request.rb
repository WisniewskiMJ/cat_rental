# frozen_string_literal: true

class CatRentalRequest < ApplicationRecord
  STATUSES = %w[PENDING APPROVED DENIED].freeze

  validates :cat_id, presence: true
  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :not_backwards_in_time
  validate :not_in_the_past
  validate :does_not_overlap

  belongs_to :cat

  belongs_to :requester,
             foreign_key: :user_id,
             class_name: :User,
             inverse_of: :requests

  def approve!
    raise 'not pending' if status != 'PENDING'

    transaction do
      deny_overlapping_pending_requests
      self.status = 'APPROVED'
      save
    end
  end

  def deny!
    self.status = 'DENIED'
    save
  end

  def not_backwards_in_time
    errors[:end_date] << "can't be earlier than start date" if start_date > end_date
  end

  def not_in_the_past
    errors[:start_date] << 'must minimum one day from now' if start_date < Time.zone.now.to_date
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

  def deny_overlapping_pending_requests
    overlapping_pending_requests.each do |r|
      r.status = 'DENIED'
      r.save
    end
  end
end
