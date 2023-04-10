class EstimatePdf < BasePdf

  DISCLAIMER = <<-TEXT
  The hours and max price quoted reflect the estimated work based on current
  specification and scope of work.  Changes to the specification or scope of
  work will involve change orders that may increase the hours and max price.
  TEXT

  attr_reader :estimate

  def initialize(estimate)
    @estimate = estimate
  end

  def generate_body(pdf)
    print_header(pdf, entity)

    pdf.move_down P_SIZE * 2
    pdf.font(FONT, size: H1_SIZE, style: :bold) do
      pdf.text estimate.proper_name, align: :center
    end
    pdf.font(FONT, size: H2_SIZE) do
      pdf.text "For: #{customer.name}", align: :center
    end

    pdf.font(FONT, size: SMALL_SIZE) do
      pdf.text DISCLAIMER, align: :center
    end

    pdf.move_down P_SIZE
    pdf.text "Description", style: :bold
    pdf.text project.description
    pdf.move_down P_SIZE * 3

    width = content_width(pdf) / 4.0
    pdf.font(FONT, style: :bold) do
      pdf.text_box 'Approx. Start', at: [0, pdf.cursor + P_SIZE], width: width, align: :center
      pdf.text_box 'Est. Completion', at: [width, pdf.cursor + P_SIZE], width: width, align: :center
      pdf.text_box 'Hours', at: [width * 2.0, pdf.cursor + P_SIZE], width: width, align: :center
      pdf.text_box 'Approx. Price', at: [width * 3.0, pdf.cursor + P_SIZE], width: width, align: :center
    end
    pdf.move_down P_SIZE + 2
    pdf.text_box estimate.start_date.to_s, at: [0, pdf.cursor + P_SIZE], width: width, align: :center
    pdf.text_box estimate.estimated_completion.to_s, at: [width, pdf.cursor + P_SIZE], width: width, align: :center
    pdf.text_box estimate.hours.to_s, at: [width * 2.0, pdf.cursor + P_SIZE], width: width, align: :center
    pdf.text_box estimate.price.format, at: [width * 3.0, pdf.cursor + P_SIZE], width: width, align: :center

    pdf.move_down P_SIZE * 2
    pdf.text "Scope of Work", style: :bold
    estimate.tasks.order(subject: :asc).each do |task|
      pdf.move_down 2
      pdf.text "• #{task.subject}"
    end

    add_draft_watermark(pdf) if estimate.status_draft?
  end

  private

  def add_draft_watermark(pdf)
    pos = [pdf.page.margins[:left], pdf.page.dimensions[3] / 2.0]

    pdf.repeat(:all) do
      pdf.fill_color(WATERMARK_COLOR)
      pdf.font(FONT, size: WATERMARK_SIZE) do
        pdf.transparent(WATERMARK_OPACITY) do
          pdf.text_box(
            'DRAFT',
            color: 'EEEEEE',
            at: pos,
            width: pdf.page.dimensions[2],
            height: pdf.page.dimensions[3],
            rotate: 30,
            rotate_around: :bottom_left
          )
        end
      end
      pdf.fill_color(DEFAULT_COLOR)
    end
  end

  def entity
    Entity.first
  end

  def project
    estimate.project
  end

  def customer
    project.customer
  end
end
