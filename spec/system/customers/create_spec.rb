require 'rails_helper'

RSpec.describe 'customer creation', type: :system, login_as: :user, js: true do
  let!(:entity) { create(:entity) }

  it 'creates a customer' do
    visit new_customer_path

    fill_in 'Name', with: 'ACME Corp'
    fill_in 'Email', with: 'boss@acme.com'
    fill_in 'Default hourly rate cents', with: '10500'
    fill_in 'Line1', with: '123 Main St'
    fill_in 'Line2', with: 'Ste 100'
    fill_in 'City', with: 'Jenison'
    fill_in 'State', with: 'MI'
    fill_in 'Zip', with: '49428'

    expect do
      click_on 'Create Customer'
      expect(page).to have_content(/# projects/i)
    end.to change(Customer, :count).by 1

    customer = Customer.last!
    expect(customer.name).to eq 'ACME Corp'
    expect(customer.email).to eq 'boss@acme.com'
    expect(customer.default_hourly_rate).to eq Money.new(105_00, 'USD')

    addr = customer.address
    expect(addr.line1).to eq '123 Main St'
    expect(addr.line2).to eq 'Ste 100'
    expect(addr.city).to eq 'Jenison'
    expect(addr.state).to eq 'MI'
    expect(addr.zip).to eq '49428'
  end
end
