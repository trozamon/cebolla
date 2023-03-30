class ProjectsController < AuthedController
  before_action :set_project, only: %i[archive archive? edit show]

  def archive
    @project.archive!
    redirect_to projects_path
  end

  def create
    res = Project::Upsert.call(params: params)

    if res.error?
      flash[:error] = res.error
    end

    redirect_to project_path(res.project)
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
    res = Project::Upsert.call(params: params)

    if res.error?
      flash[:error] = res.error
    end

    redirect_to project_path(res.project)
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
