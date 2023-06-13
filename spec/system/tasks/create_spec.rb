require 'rails_helper'

RSpec.describe 'task creation', type: :system, login_as: :user, js: true do
  context 'ad hoc' do
    let!(:project) { create(:project) }

    scenario 'create a task' do
      visit new_project_task_path(project_id: project.id)

      fill_in 'Subject', with: 'Add invoice model'
      fill_in 'Description', with: 'Add a table to store invoices'
      fill_in 'Estimated Hours', with: '4'

      expect do
        click_on 'Add Task'
        expect(page).to have_content(/added task/i)
      end.to change(Task, :count).by 1

      t = Task.last!
      expect(t.subject).to eq 'Add invoice model'
      expect(t.description).to eq 'Add a table to store invoices'
      expect(t.kind).to eq 'feature'
      expect(t.state).to eq 'brand_new'
      expect(t.est_hours).to eq 4
    end
  end

  context 'estimated' do
    scenario 'create a task'
    scenario 'cannot create a task with no draft estimate'
  end
end
