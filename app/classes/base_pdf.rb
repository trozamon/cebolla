class BasePdf
  FONT = 'Helvetica'
  DEFAULT_COLOR = '000000'
  H1_SIZE = 18
  H2_SIZE = 16
  H3_SIZE = 14
  P_SIZE = 12
  SMALL_SIZE = 8

  WATERMARK_SIZE = 144
  WATERMARK_COLOR = '000000'
  WATERMARK_OPACITY = 0.4

  def generate(fname)
    Prawn::Document.generate(fname) do |pdf|
      pdf.font FONT

      generate_body(pdf)
    end
  end

  protected

  def print_header(pdf, entity, right_text = nil)
    pdf.font(FONT, size: H2_SIZE, style: :bold) do
      pdf.text entity.name
      if right_text
        pdf.text_box(right_text, at: [300, 720], width: 235, align: :right)
      end
    end

    pdf.move_down P_SIZE / 2
    print_address(pdf, entity.address)
  end

  def content_width(pdf)
    pdf.page.dimensions[2] - pdf.page.margins[:left] - pdf.page.margins[:right]
  end

  def print_address(pdf, address)
    pdf.text address.line1
    if address.line2.present?
      pdf.text address.line2
    end
    pdf.text "#{address.city}, #{address.state} #{address.zip}"
  end
end
