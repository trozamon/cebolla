class CustomersController < AuthedController
  before_action :set_customer, only: %i[edit project_status update]

  def create
    Customer.create!(customer_params)
    redirect_to customers_path
  end

  def edit
    @customer.build_address if @customer.address.blank?
  end

  def index
    @customers = Customer.order(:name)
  end

  def new
    @customer = Customer.new
    @customer.build_address
  end

  def project_status
    date = Time.zone.today
    respond_to do |format|
      format.pdf do
        @tmpfile = Tempfile.new("", nil, mode: File::CREAT | File::BINARY | File::RDWR, encoding: 'ASCII-8BIT')
        ProjectStatusPdf.new(@customer, date).generate(@tmpfile.path)
        @tmpfile.rewind

        name = @customer.name
                        .downcase
                        .gsub(/(\s|,)+/, '-')
                        .gsub('.', '')

        send_file @tmpfile,
                  filename: "#{name}_#{date}.pdf",
                  disposition: 'inline',
                  type: 'application/pdf'
      end
    end
  end

  def update
    @customer.update!(customer_params)
    redirect_to customers_path
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer)
          .permit(:name,
                  :email,
                  :default_hourly_rate_cents,
                  :default_hourly_rate_currency,
                  address_attributes: %i[city id line1 line2 state zip])
  end
end
