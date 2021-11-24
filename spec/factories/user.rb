FactoryBot.define do
  factory :user do
    confirmed_at { Time.zone.now }
    email { Faker::Internet.email }
    password { 'what up' }
    password_confirmation { 'what up' }
  end
end
