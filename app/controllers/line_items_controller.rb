class LineItemsController < AuthedController
  before_action :set_invoice, only: %i[create new]
  before_action :set_line_item, only: %i[edit update]

  def create
    return redirect_to invoice_path(@invoice) if @invoice.posted?

    line_item = @invoice.line_items.create!(li_params)
    redirect_to invoice_path(line_item.invoice)
  end

  def update
    @line_item.update!(li_params)
    redirect_to invoice_path(@line_item.invoice)
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def li_params
    params.require(:line_item).permit(
      :description,
      :quantity,
      :unit_amount_cents,
      :unit_amount_currency
    )
  end
end
