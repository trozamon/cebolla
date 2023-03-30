FactoryBot.define do
  factory :project do
    entity
    customer
    name { Faker::Name.name }
    billing { :monthly }
    hours_cap_kind { :ad_hoc }
    status { :active }
  end
end
