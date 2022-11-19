class Customer < ApplicationRecord
  has_many :projects
  has_many :tasks, through: :projects
  has_one :address, as: :addressable

  validates :name, presence: true

  accepts_nested_attributes_for :address

  monetize :default_hourly_rate_cents, allow_nil: true

  def complete_unbilled_hours
    tasks = Task.where(project: projects.active)
                .closed

    Hour.where(task: tasks).unbilled.sum(:num)
  end

  def estimated_backlog_hours
    Task.where(project: projects.active).open.sum(:est_hours)
  end
end
