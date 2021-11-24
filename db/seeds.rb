return unless Rails.env.development?

ActiveRecord::Base.transaction do
  sample = User.create!(email: 'sample@example.com',
                        password: 'Password1!',
                        password_confirmation: 'Password1!',
                        confirmed_at: Time.zone.now)

  entity = Entity.create!(
    name: 'John Doe',
    email: 'no-reply@example.com',
    phone: '1234567890'
  )

  customer = Customer.create!(
    name: 'Customer 1, Inc.',
    email: 'invoices@customer1.com',
    default_hourly_rate: Money.new(10000, 'USD')
  )

  project = Project.create!(
    entity: entity,
    customer: customer,
    name: 'Default Project',
    billing: :monthly
  )
end
