class ProjectsController < AuthedController
  before_action :set_project, only: %i[archive archive? edit show update]

  def archive
    @project.archive!
    redirect_to projects_path
  end

  def create
    project = Project.create!(project_params)
    redirect_to project_path(project)
  end

  def index
    @projects = Project.active
                       .joins(:customer)
                       .includes(:customer)
                       .order('customers.name ASC, projects.name ASC')
  end

  def show
    @unbilled = @project.tasks.closed
                              .joins(:hours)
                              .where(hours: { line_item_id: nil })
                              .distinct
  end

  def update
    @project.update!(project_params)
    redirect_to project_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project)
          .permit(:name,
                  :description,
                  :entity_id,
                  :customer_id,
                  :due_date,
                  :default_hourly_rate_cents,
                  :default_hourly_rate_currency,
                  :billing)
  end
end
