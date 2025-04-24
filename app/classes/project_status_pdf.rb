class ProjectStatusPdf < BasePdf
  attr_reader :customer, :date

  def initialize(customer, date)
    @customer = customer
    @date = date
  end

  def generate_body(pdf)
    print_header(pdf, Entity.first, Time.zone.today.strftime('%B %-d, %Y'))

    pdf.move_down H1_SIZE
    pdf.font(FONT, size: H1_SIZE, style: :bold) do
      pdf.text "#{customer.name} Project Status", align: :center
    end

    pdf.move_down P_SIZE

    print_summary_stats(pdf)
    pdf.start_new_page

    #projects.each.with_index do |project, idx|
    #  pdf.start_new_page if idx > 0
    #  print_project(pdf, project)
    #end
  end

  private

  def print_project(pdf, project)
    pdf.font(FONT, size: H2_SIZE, style: :bold) do
      pdf.text project.name
    end
    pdf.text project.description

    pdf.move_down P_SIZE
    pdf.font(FONT, size: H3_SIZE, style: :bold) { pdf.text "Completed" }
    pdf.move_down P_SIZE / 2
    print_tasks(pdf, project.complete_unbilled_tasks)

    pdf.move_down P_SIZE
    pdf.font(FONT, size: H3_SIZE, style: :bold) { pdf.text "In Progress" }
    pdf.move_down P_SIZE / 2
    print_tasks(pdf, project.tasks.in_progress)

    pdf.move_down P_SIZE
    pdf.font(FONT, size: H3_SIZE, style: :bold) { pdf.text "Backlog" }
    pdf.move_down P_SIZE / 2
    print_tasks(pdf, project.tasks.brand_new)
  end

  def print_tasks(pdf, tasks)
    pdf.text("N/A") if tasks.empty?

    tasks.each.with_index do |task, idx|
      pdf.move_down(P_SIZE / 2) if idx > 0
      pdf.font(FONT, style: :bold) { pdf.text task.subject }
      pdf.text task.description
    end
  end

  def print_summary_stats(pdf)
    pdf.font(FONT, size: H2_SIZE, style: :bold) do
      pdf.text 'Summary'
    end

    width = content_width(pdf) / 5.0

    pdf.font(FONT, style: :bold) do
      pdf.text 'Project'
      pdf.text_box 'Description', at: [width, pdf.cursor + P_SIZE + 2], width: width*3 - P_SIZE
      pdf.text_box 'Backlog Tasks', at: [width * 4.0, pdf.cursor + P_SIZE + 2], width: width - P_SIZE, align: :right
    end

    pdf.stroke { pdf.horizontal_rule }
    pdf.move_down P_SIZE / 2

    pdf.stroke_color 'bbbbbb'
    projects.each.with_index do |proj, idx|
      if idx > 0
        pdf.stroke { pdf.horizontal_rule }
        pdf.move_down P_SIZE / 2
      end

      pdf.text proj.name

      desc_width = width*3 - P_SIZE
      char_width = desc_width.to_f / P_SIZE.to_f * 2.0
      desc_height = (proj.description.length.to_f/char_width).ceil - 1

      pdf.text_box proj.description || '', at: [width, pdf.cursor + P_SIZE + 2], width: width*3 - P_SIZE
      pdf.text_box proj.tasks.open.count.to_s, at: [width * 4.0, pdf.cursor + P_SIZE + 2], width: width - P_SIZE, align: :right

      pdf.move_down P_SIZE*desc_height
    end
    pdf.stroke_color '000000'
  end

  def entity
    Entity.first
  end

  def projects
    @projects ||= customer.projects.active.order(:name).to_a
  end
end
