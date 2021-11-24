class HomeController < ApplicationController
  def index
    return render :index unless user_signed_in?

    @customers = Customer.all.order(name: :asc)
    @unbilled_hours = Hour.joins(task: :project)
                          .unbilled
                          .group('projects.customer_id')
                          .sum(:num)
    @tasks = Task.open.count
    @potential_revenue = {}

    Project.active.each do |p|
      @potential_revenue[p.customer_id] ||= Money.new(0, 'USD')
      @potential_revenue[p.customer_id] += p.potential_revenue
    end

    render :dashboard
  end
end
