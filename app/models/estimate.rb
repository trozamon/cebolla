##
# An estimate for a project.
class Estimate < ApplicationRecord
  ##
  # assume 6 hours of work done in a day
  COMPLETION_BUFFER = BigDecimal('0.33').freeze

  belongs_to :project
  has_many :tasks

  validates :number, presence: true
  validates :due_date, presence: true, if: :status_active?
  validates :status, presence: true
  validate :project_is_estimated

  enum status: {
    draft: 1,
    active: 2
  }, _prefix: :status

  def proper_name
    if number == 0 && status_draft?
      "#{project.name} - Draft Estimate"
    elsif number == 0
      "#{project.name} - Estimate"
    elsif status_draft?
      "#{project.name} - Draft Change Order #{number}"
    else
      "#{project.name} - Change Order #{number}"
    end
  end

  def hours
    tasks.sum(:est_hours)
  end

  def price
    project.hourly_rate * hours
  end

  def straight_line_completion
    calc_completion
  end

  def estimated_completion
    calc_completion(1 + COMPLETION_BUFFER)
  end

  private

  def calc_completion(mult = 1)
    total_hours = BigDecimal(hours) * mult
    days = total_hours / 8

    # five days in a workweek
    days *= 7
    days /= 5

    days = days.ceil.to_i

    tmp = (start_date || Time.zone.today) + days
    while tmp.saturday? || tmp.sunday?
      tmp = tmp + 1
    end

    tmp
  end

  def project_is_estimated
    return if project.hours_cap_kind_estimated?

    errors.add(:project, 'must be estimated')
  end
end
