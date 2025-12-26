class Task < ApplicationRecord
  belongs_to :project
  belongs_to :estimate, optional: true

  has_many :hours, dependent: :destroy

  validates :subject, presence: true
  validates :kind, presence: true
  validates :state, presence: true

  scope :open, -> { where.not(state: :closed) }

  enum :kind, {
    bug: 1,
    feature: 2
  }

  enum :state, {
    brand_new: 1,
    in_progress: 2,
    resolved: 3,
    closed: 4
  }
end
