class Entity < ApplicationRecord
  validates :name, presence: true
  has_one :address, as: :addressable

  accepts_nested_attributes_for :address
end
