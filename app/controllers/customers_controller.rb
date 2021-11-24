class CustomersController < AuthedController
  def create
    Customer.create!(customer_params)
    redirect_to customers_path
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def index
    @customers = Customer.all
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
                  :default_hourly_rate_currency)
  end
end
