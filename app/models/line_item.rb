class LineItem < ApplicationRecord
  belongs_to :invoice
  has_many :hours, dependent: :nullify

  monetize :unit_amount_cents

  def subtotal
    unit_amount * quantity
  end
end
