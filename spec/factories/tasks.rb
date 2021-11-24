FactoryBot.define do
  factory :task do
    project
    subject { Faker::Lorem.sentence }
    kind { :feature }
    state { :brand_new }
  end
end
