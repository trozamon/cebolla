class InvoicesController < AuthedController
  def create
    # for all monthly projects, get unbilled hours for closed tasks
    ActiveRecord::Base.transaction do
      invoice = make_invoice(persist: true, make_params: invoice_params)
      redirect_to invoice_path(invoice)
    end
  end

  def index
    @open = Invoice.open
    @posted = Invoice.posted.order(posted_at: :desc).limit(30)
  end

  def new
    @invoice = make_invoice
  end

  def post
    @invoice = Invoice.find(params[:id])
    @invoice.update!(posted_at: Time.zone.now)
    redirect_to invoice_path(@invoice)
  end

  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        content = render_to_string(template: 'invoices/show',
                                   format: 'pdf',
                                   layout: 'pdf',
                                   locals: { :@invoice => @invoice })
        pdf = Grover.new(content, margin: { left: '0.5in', top: '0.5in', right: '0.5in', bottom: '0.5in' }).to_pdf
        @tmpfile = Tempfile.new("", nil, mode: File::CREAT | File::BINARY | File::RDWR, encoding: 'ASCII-8BIT')
        @tmpfile.write(pdf)
        @tmpfile.flush
        @tmpfile.rewind
        send_file @tmpfile,
                  filename: "#{@invoice.customer.name.downcase.gsub(/\s/, '')}-#{@invoice.number}.pdf",
                  disposition: 'inline',
                  type: 'application/pdf'
      end
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:customer_id, :number, :date)
  end

  def make_invoice(persist: false, make_params: { date: Time.zone.today })
    cust =
      Customer.find_by(id: params.dig(:invoice, :customer_id)) ||
      Customer.find_by(id: params[:customer_id]) ||
      Customer.first
    ent = Entity.first

    invoice = Invoice.new(make_params)
    invoice.customer = cust
    invoice.entity = ent
    invoice.due_date = invoice.date + 30.days
    invoice.save! if persist

    projects = Project.where(customer: cust, entity: ent)

    projects.find_each do |project|
      hours = Hour.where(line_item_id: nil)
                  .joins(:task)
                  .where(tasks: { state: :closed, project_id: project.id })

      next if hours.none?

      line_item = invoice.line_items.build(invoice: invoice,
                                           description: project.name,
                                           quantity: hours.sum(:num),
                                           unit_amount: project.hourly_rate)

      if persist
        line_item.save!
        hours.find_each { |h| h.update!(line_item: line_item) }
      end
    end

    invoice
  end
end
