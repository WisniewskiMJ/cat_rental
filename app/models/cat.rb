# frozen_string_literal: true

require 'action_view'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  COLORS = %w[black grey white buff brown orange tortoiseshell calico].freeze

  validates :birth_date, presence: true
  validates :color, presence: true, inclusion:
    { in: COLORS, message: '%<value>s is not a valid cat color' }
  validates :name, presence: true
  validates :sex, presence: true, inclusion: { in: %w[M F] }
  validates :description, presence: true, length: { in: 3..300,
                                                    too_long: 'is too long',
                                                    too_short: 'is too short' }
  validates :owner, presence: true

  belongs_to :owner,
             primary_key: :id,
             foreign_key: :user_id,
             class_name: :User,
             inverse_of: :cats

  has_many :rental_requests,
           primary_key: :id,
           class_name: :CatRentalRequest,
           dependent: :destroy

  def age
    time_ago_in_words(birth_date)
  end
end
