class TasksController < AuthedController
  before_action :set_task, only: %i[destroy edit show update]
  before_action :set_project, only: %i[create destroy edit new show]

  def create
    @project.tasks.create!(task_params)
    redirect_to @project
  end

  def edit
    @projects = @project.customer.projects
  end

  def destroy
    @task.destroy!
    flash[:success] = "Removed task #{@task.subject}"
    redirect_to project_path(@project)
  end

  def update
    @task.update!(task_params)
    redirect_to task_path(@task)
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_project
    if @task
      @project = @task.project
    else
      @project = Project.find(params[:project_id])
    end
  end

  def task_params
    params.require(:task)
          .permit(:subject,
                  :project_id,
                  :description,
                  :est_hours,
                  :state,
                  :kind)
  end
end
