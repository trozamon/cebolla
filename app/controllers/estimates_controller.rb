class EstimatesController < AuthedController
  before_action :set_estimate

  def finalize
    Project.transaction do
      @estimate.update!(status: :active,
                        due_date: @estimate.estimated_completion)
      @estimate.project.update!(status: :active,
                                due_date: @estimate.estimated_completion,
                                hours_cap: @estimate.hours)
    end

    flash[:success] = 'Finalized estimate'
    redirect_to project_path(@estimate.project)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        @tmpfile = Tempfile.new("", nil, mode: File::CREAT | File::BINARY | File::RDWR, encoding: 'ASCII-8BIT')
        EstimatePdf.new(@estimate).generate(@tmpfile.path)
        @tmpfile.rewind
        send_file @tmpfile,
                  filename: "#{@estimate.proper_name}.pdf",
                  disposition: 'inline',
                  type: 'application/pdf'
      end
    end
  end

  def update
    @estimate.update!(estimate_params)
    redirect_to project_path(@estimate.project)
  end

  private

  def set_estimate
    @estimate = Estimate.find(params[:id])
  end

  def estimate_params
    params.require(:estimate).permit(:start_date)
  end
end
