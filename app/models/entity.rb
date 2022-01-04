class Entity < ApplicationRecord
  has_one :address, as: :addressable
  has_many :projects

  validates :name, presence: true

  accepts_nested_attributes_for :address
end
