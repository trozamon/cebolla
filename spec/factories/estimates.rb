FactoryBot.define do
  factory :estimate do
    project { build(:project) }
    number { 0 }
    status { :draft }
  end
end
