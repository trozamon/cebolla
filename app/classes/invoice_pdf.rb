class InvoicePdf
  FONT = 'Helvetica'
  H2_SIZE = 16
  P_SIZE = 12

  attr_reader :invoice

  def initialize(invoice)
    @invoice = invoice
  end

  def generate(fname)
    Prawn::Document.generate(fname) do |pdf|
      pdf.font FONT

      pdf.font(FONT, size: H2_SIZE, style: :bold) do
        pdf.text invoice.entity.name
        pdf.text_box("Invoice ##{invoice.number}",
                     at: [300, 720],
                     width: 235,
                     align: :right)
      end

      pdf.move_down P_SIZE / 2
      print_address(pdf)

      pdf.move_down P_SIZE * 2
      print_billing_info(pdf)

      pdf.move_down P_SIZE * 2
      print_billing_table(pdf)

      pdf.move_down P_SIZE * 2
      print_completed_tasks(pdf)
    end
  end

  private

  def content_width(pdf)
    pdf.page.dimensions[2] - pdf.page.margins[:left] - pdf.page.margins[:right]
  end

  def print_address(pdf)
    address = invoice.entity.address
    pdf.text address.line1
    if address.line2.present?
      pdf.text address.line2
    end
    pdf.text "#{address.city}, #{address.state} #{address.zip}"
  end

  def print_billing_info(pdf)
    width = content_width(pdf) / 3.0
    adtnl = pdf.page.margins[:left]

    pdf.font(FONT, style: :bold) do
      pdf.text 'Bill To'
      pdf.draw_text 'Date', at: [width + adtnl, pdf.cursor]
      pdf.draw_text 'Due Date', at: [width * 2.0 + adtnl, pdf.cursor]
    end

    pdf.move_down P_SIZE / 2
    pdf.text invoice.customer.name
    pdf.draw_text invoice.date.to_s, at: [width + adtnl, pdf.cursor]
    pdf.draw_text invoice.due_date.to_s, at: [width * 2.0 + adtnl, pdf.cursor]
    address = invoice.customer.address
    pdf.text address.line1
    if address.line2.present?
      pdf.text address.line2
    end
    pdf.text "#{address.city}, #{address.state} #{address.zip}"
  end

  def print_billing_table(pdf)
    width = content_width(pdf) / 5.0

    pdf.font(FONT, style: :bold) do
      pdf.text 'Project'
      pdf.text_box 'Hours', at: [width * 2.0, pdf.cursor + P_SIZE + 2], width: width - P_SIZE, align: :right
      pdf.text_box 'Rate', at: [width * 3.0, pdf.cursor + P_SIZE + 2], width: width - P_SIZE, align: :right
      pdf.text_box 'Total', at: [width * 4.0, pdf.cursor + P_SIZE + 2], width: width, align: :right
    end

    pdf.stroke { pdf.horizontal_rule }
    pdf.move_down P_SIZE / 2

    pdf.stroke_color 'bbbbbb'
    invoice.line_items.each.with_index do |li, idx|
      if idx > 0
        pdf.stroke { pdf.horizontal_rule }
        pdf.move_down P_SIZE / 2
      end

      pdf.text li.description
      pdf.text_box li.quantity.to_s, at: [width * 2.0, pdf.cursor + P_SIZE + 2], width: width - P_SIZE, align: :right
      pdf.text_box li.unit_amount.format, at: [width * 3.0, pdf.cursor + P_SIZE + 2], width: width - P_SIZE, align: :right
      pdf.text_box li.subtotal.format, at: [width * 4.0, pdf.cursor + P_SIZE + 2], width: width, align: :right
    end
    pdf.stroke_color '000000'

    pdf.stroke { pdf.horizontal_rule }
    pdf.move_down P_SIZE / 2

    pdf.font(FONT, style: :bold) do
      pdf.text 'Total'
      pdf.text_box invoice.total.format, at: [width * 4.0, pdf.cursor + P_SIZE + 2], width: width, align: :right
    end
  end

  def print_completed_tasks(pdf)
    pdf.font(FONT, size: H2_SIZE, style: :bold) do
      pdf.text 'Completed Tasks'
    end
    pdf.move_down P_SIZE / 2

    invoice.hours.map(&:task).uniq.each.with_index do |task, idx|
      if idx > 0
        pdf.move_down P_SIZE / 2
      end

      pdf.font(FONT, style: :bold) do
        pdf.text task.subject
      end
      pdf.text task.description
    end
  end
end
