require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    let(:project) { build(:project) }

    it 'is valid' do
      expect(project).to be_valid
    end

    context 'ad hoc projects' do
      before do
        project.hours_cap_kind = :ad_hoc
      end

      it 'are monthly billing only' do
        project.billing = :lump_sum
        expect(project).to be_invalid
      end

      it 'validates ad hoc cannot have a due date' do
        project.due_date = 1.week.from_now
        expect(project).to be_invalid
      end

      it 'validates ad hoc cannot have an hours cap' do
        project.hours_cap = 100
        expect(project).to be_invalid
      end
    end

    context 'estimated projects' do
      before do
        project.hours_cap_kind = :estimated
        project.status = :draft
      end

      it 'active and closed must have a due date' do
        project.due_date = nil
        expect(project).to be_valid

        project.status = :active
        expect(project).to be_invalid
      end

      it 'active and closed must have an hour cap' do
        project.hours_cap = nil
        expect(project).to be_valid

        project.status = :active
        expect(project).to be_invalid
      end
    end
  end
end
