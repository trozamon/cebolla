class Customer < ApplicationRecord
  validates :name, presence: true

  has_many :projects
  has_many :tasks, through: :projects
  has_one :address, as: :addressable

  monetize :default_hourly_rate_cents, allow_nil: true
end
