require 'rails_helper'

RSpec.describe 'invoice posting', type: :system, login_as: :user, js: true do
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

  let!(:task) { create(:task, project: project, state: :closed) }
  let!(:hour) { create(:hour, num: 2, task: task) }

  it 'creates an invoice' do
    visit new_invoice_path(customer_id: customer2.id)

    expect(page).to have_content(project.name)
    expect(page).to have_content(/\$200\.00/)

    fill_in 'Number', with: '0000001'

    expect do
      click_on 'Create Invoice'
      expect(page).to have_content(/invoice 0000001/i)
    end.to change(Invoice, :count).by 1

    inv = Invoice.last!
    posted_at = Time.zone.now

    click_on 'Post'
    expect(page).to have_content(/posted invoice/i)
    expect(inv.reload.posted_at).to be >= posted_at
  end
end
