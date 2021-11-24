class Invoice < ApplicationRecord
  belongs_to :entity
  belongs_to :customer

  has_many :line_items, dependent: :destroy
  has_many :hours, through: :line_items

  scope :open, -> { where(posted_at: nil) }
  scope :posted, -> { where.not(posted_at: nil) }

  def total
    return Money.new(0, 'USD') if line_items.none?

    line_items.map(&:subtotal).sum
  end

  def posted?
    posted_at.present?
  end
end
