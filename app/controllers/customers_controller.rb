class CustomersController < AuthedController
  def create
    Customer.create!(customer_params)
    redirect_to customers_path
  end

  def edit
    @customer = Customer.find(params[:id])
    @customer.build_address if @customer.address.blank?
  end

  def index
    @customers = Customer.order(:name)
  end

  def new
    @customer = Customer.new
    @customer.build_address
  end

  def update
    Customer.find(params[:id]).update!(customer_params)
    redirect_to customers_path
  end

  private

  def customer_params
    params.require(:customer)
          .permit(:name,
                  :email,
                  :default_hourly_rate_cents,
                  :default_hourly_rate_currency,
                  address_attributes: %i[city id line1 line2 state zip])
  end
end
