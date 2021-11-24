FactoryBot.define do
  factory :project do
    entity
    customer
    name { Faker::Name.name }
    billing { :monthly }
  end
end
