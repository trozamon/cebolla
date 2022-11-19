class Project < ApplicationRecord
  belongs_to :entity
  belongs_to :customer
  has_many :tasks

  validates :name, presence: true
  validates :billing, presence: true

  enum billing: {
    monthly: 1,
    lump_sum: 2
  }

  monetize :default_hourly_rate_cents, allow_nil: true

  scope :active, -> { where(archived_at: nil) }

  def archive!(as_of = Time.zone.now)
    update!(archived_at: as_of)
  end

  def hourly_rate
    if default_hourly_rate.blank?
      customer.default_hourly_rate
    else
      default_hourly_rate
    end
  end

  def potential_revenue
    hourly_rate * tasks.open.sum(:est_hours)
  end

  def complete_unbilled_tasks
    tasks.closed
         .joins(:hours)
         .where(hours: { line_item_id: nil })
         .distinct
  end
end
