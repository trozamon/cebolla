class HoursController < AuthedController
  before_action :set_task, only: %i[create new]

  def create
    @task.hours.create!(hour_params.merge(user: current_user))
    redirect_to task_path(@task)
  end

  def new; end

  private

  def hour_params
    params.require(:hour).permit(:date, :description, :num)
  end

  def set_task
    @task = Task.find(params[:task_id])
  end
end
