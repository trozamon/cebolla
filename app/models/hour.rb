class Hour < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :line_item, optional: true

  validates :date, presence: true
  validates :num, presence: true
  validates :description, presence: true

  scope :unbilled, -> { where(line_item: nil) }
end
