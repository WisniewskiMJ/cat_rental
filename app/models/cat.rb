# frozen_string_literal: true

class Cat < ApplicationRecord
  COLORS = %w[black grey white buff brown orange tortoiseshell calico].freeze

  validates :birth_date, presence: true
  validates :color, presence: true, inclusion:
    { in: COLORS }
  validates :name, presence: true
  validates :sex, presence: true, inclusion: { in: %w[M F] }
  validates :description, presence: true, length: { in: 3..300 }
  validates :owner, presence: true

  belongs_to :owner,
             foreign_key: :user_id,
             class_name: :User,
             inverse_of: :cats

  has_many :rental_requests,
           class_name: :CatRentalRequest,
           dependent: :destroy
end
