FactoryBot.define do
  factory :hour do
    user
    task
    date { Time.zone.today }
    num { 2 }
    description { Faker::Lorem.sentence }
  end
end
