class EstimatesController < AuthedController
  def edit
    @estimate = Estimate.find(params[:id])
  end

  def show
    @estimate = Estimate.find(params[:id])
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
    @estimate = Estimate.find(params[:id])
    @estimate.update!(estimate_params)
    redirect_to project_path(@estimate.project)
  end

  private

  def estimate_params
    params.require(:estimate).permit(:start_date)
  end
end
