# frozen_string_literal: true

class CatRentalRequest < ApplicationRecord
  enum status: { pending: 10,
                 approved: 20,
                 denied: 30 }

  validates :cat_id, presence: true
  validates :user_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true
  validate :end_not_earlier_than_start
  validate :not_in_the_past
  validate :does_not_overlap_with_approved

  belongs_to :cat

  belongs_to :requester,
             foreign_key: :user_id,
             class_name: :User,
             inverse_of: :requests

  def approve!
    raise 'not pending' if status != 'pending'

    transaction do
      deny_overlapping_pending_requests
      self.status = :approved
      save
    end
  end

  def deny!
    self.status = :denied
    save
  end

  def end_not_earlier_than_start
    errors[:end_date] << 'can not be earlier than start' if start_date > end_date
  end

  def not_in_the_past
    errors[:start_date] << 'can not be in the past' if start_date < Time.zone.now.to_date
  end

  def overlapping_requests
    CatRentalRequest.where('cat_id = ?', cat_id)
                    .where.not('id = ?', id)
                    .where.not('start_date > ? OR end_date < ?',
                               end_date, start_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where('status = ?', 20)
  end

  def overlapping_pending_requests
    overlapping_requests.where('status = ?', 10)
  end

  def does_not_overlap_with_approved
    errors[:overlaps] << 'with approved request' if overlapping_approved_requests.exists?
  end

  def deny_overlapping_pending_requests
    overlapping_pending_requests.each do |r|
      r.status = :denied
      r.save
    end
  end
end
