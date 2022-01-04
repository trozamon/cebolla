class Customer < ApplicationRecord
  has_many :projects
  has_many :tasks, through: :projects
  has_one :address, as: :addressable

  validates :name, presence: true

  accepts_nested_attributes_for :address

  monetize :default_hourly_rate_cents, allow_nil: true
end
