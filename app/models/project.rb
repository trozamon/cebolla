class Project < ApplicationRecord
  belongs_to :entity
  belongs_to :customer
  has_many :estimates
  has_many :tasks

  validates :name, presence: true
  validates :billing, presence: true
  validates :hours_cap_kind, presence: true
  validate :ad_hoc_config, if: :hours_cap_kind_ad_hoc?
  validate :estimated_config, if: :hours_cap_kind_estimated?

  enum :billing, {
    monthly: 1,
    lump_sum: 2
  }, prefix: true

  enum :hours_cap_kind, {
    ad_hoc: 1,
    estimated: 2
  }, prefix: true

  enum :status, {
    active: 1,
    draft: 2,
    completed: 3
  }, prefix: true

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

  def draft_estimate
    estimates.find_by(status: :draft)
  end

  private

  # TODO: only 1 draft estimate

  def ad_hoc_config
    if !billing_monthly?
      errors.add(:base, 'Ad-hoc projects must be billed monthly')
    end

    if due_date.present?
      errors.add(:base, 'Ad-hoc projects cannot have a due date')
    end

    if hours_cap.present?
      errors.add(:base, 'Ad-hoc projects cannot have a cap on hours')
    end
  end

  def estimated_config
    return if status_draft?

    if due_date.blank?
      errors.add(:base, 'Estimated projects must have a due date')
    end

    if hours_cap.blank? || hours_cap <= 0
      errors.add(:base, 'Estimated projects must have a cap on hours')
    end
  end
end
