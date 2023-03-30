class Project::Upsert
  include ::Service

  attr_reader :params

  def initialize(params:)
    @params = params
  end

  def call
    if params[:id].present?
      @project = Project.find(params[:id])
      @project.update!(update_params)
    else
      @project = Project.new(create_params)

      if @project.hours_cap_kind_estimated?
        @project.status = :draft
      else
        @project.status = :active
      end

      Project.transaction do
        @project.save!
        if @project.hours_cap_kind_estimated?
          @project.estimates.create!(number: 0, status: :draft)
        end
      end
    end

    # TODO: handle invalid record in here
    # TODO: don't handle not_found (let controller handle?)

    ok(project: @project)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error { e }
    error('Not found')
  end

  def create_params
    params.require(:project)
          .permit(:billing,
                  :customer_id,
                  :default_hourly_rate_cents,
                  :default_hourly_rate_currency,
                  :description,
                  :due_date,
                  :entity_id,
                  :hours_cap_kind,
                  :name)
  end

  def update_params
    params.require(:project)
          .permit(:description, :name)
  end
end
