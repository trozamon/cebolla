class ProjectStatusPdf < BasePdf
  attr_reader :customer, :date

  def initialize(customer, date)
    @customer = customer
    @date = date
  end

  def generate_body(pdf)
    print_header(pdf, entity, date.to_s)

    pdf.move_down P_SIZE * 2
    pdf.font(FONT, size: H1_SIZE, style: :bold) do
      pdf.text "#{customer.name} Project Status", align: :center
    end

    pdf.move_down P_SIZE
    print_summary_stats(pdf)
    pdf.move_down P_SIZE

    projects.each.with_index do |project, idx|
      pdf.start_new_page if idx > 0
      print_project(pdf, project)
    end
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
      pdf.text "Summary"
    end

    pdf.text "Complete: #{customer.complete_unbilled_hours} hours"
    pdf.text "Estimated Backlog: #{customer.estimated_backlog_hours} hours"
  end

  def entity
    Entity.first
  end

  def projects
    customer.projects.active.order(:name)
  end
end
