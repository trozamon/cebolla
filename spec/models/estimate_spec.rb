require 'rails_helper'

RSpec.describe Estimate, type: :model do
  let(:project) { create(:project, status: :draft, hours_cap_kind: :estimated) }
  let(:estimate) { build(:estimate, project: project) }

  describe 'validations' do
    it 'requires an estimated project'
  end

  describe '#price' do
    it 'calculates hours times hourly'
  end

  describe 'estimated_completion' do
    it 'estimates if start date is nil'

    it 'estimates if start date is nil and there are no hours' do
      estimate.start_date = nil
      travel_to(Time.new(2023, 3, 30, 12, 0, 0)) do
        expect(estimate.estimated_completion).to eq Date.new(2023, 3, 30)
      end
    end
  end
end
