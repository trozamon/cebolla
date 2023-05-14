return unless Rails.env.development?

ActiveRecord::Base.transaction do
  sample = User.create_with(password: 'Password1!',
                            password_confirmation: 'Password1!',
                            confirmed_at: Time.zone.now)
               .find_or_create_by!(email: 'sample@example.com')

  entity = Entity.create_with(email: 'no-reply@example.com',
                              phone: '1234567890')
                 .find_or_create_by!(name: 'John Doe')

  customer = Customer.create_with(email: 'invoices@customer1.com',
                                  default_hourly_rate: Money.new(10000, 'USD'))
                     .find_or_create_by!(name: 'Customer 1, Inc.')

  project = Project.create_with(name: 'Default Project',
                                hours_cap_kind: :ad_hoc,
                                status: :active,
                                billing: :monthly)
                   .find_or_create_by!(entity: entity, customer: customer)
end
