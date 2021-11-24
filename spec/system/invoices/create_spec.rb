require 'rails_helper'

RSpec.describe 'invoice creation', type: :system, login_as: :user, js: true do
  let!(:entity) { create(:entity) }
  let!(:customer) { create(:customer) }

  let!(:customer2) do
    create(:customer, default_hourly_rate: Money.new(10000, 'USD'))
  end

  let!(:project) do
    create(:project,
           customer: customer2,
           entity: entity,
           default_hourly_rate: nil)
  end

  let!(:free_project) do
    create(:project,
           customer: customer2,
           entity: entity,
           default_hourly_rate: Money.new(0, 'USD'))
  end

  let!(:task) { create(:task, project: project, state: :closed) }
  let!(:hour) { create(:hour, num: 2, task: task) }

  let!(:free_task) { create(:task, project: free_project, state: :closed) }
  let!(:free_hour) { create(:hour, num: 2, task: free_task) }

  it 'creates an invoice' do
    visit new_invoice_path(customer_id: customer2.id)

    expect(page).to have_content(project.name)
    expect(page).to have_content(/\$200\.00/)

    fill_in 'Number', with: '0000001'

    expect do
      click_on 'Create Invoice'
      expect(page).to have_content(/invoice 0000001/i)
    end.to change(Invoice, :count).by 1

    inv = Invoice.last
    expect(inv.number).to eq '0000001'
    expect(inv.customer).to eq customer2
    expect(inv.total).to eq Money.new(20000, 'USD')
  end
end
