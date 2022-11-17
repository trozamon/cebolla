class BasePdf
  FONT = 'Helvetica'
  H2_SIZE = 16
  P_SIZE = 12

  def generate(fname)
    Prawn::Document.generate(fname) do |pdf|
      pdf.font FONT

      generate_body(pdf)
    end
  end

  protected

  def print_header(pdf, entity, right_text)
    pdf.font(FONT, size: H2_SIZE, style: :bold) do
      pdf.text invoice.entity.name
      pdf.text_box(right_text, at: [300, 720], width: 235, align: :right)
    end
  end

  def content_width(pdf)
    pdf.page.dimensions[2] - pdf.page.margins[:left] - pdf.page.margins[:right]
  end
end
