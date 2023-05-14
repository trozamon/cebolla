require 'rails_helper'

RSpec.describe 'task creation', type: :system, login_as: :user, js: true do
  context 'ad hoc' do
    scenario 'create a task'
  end

  context 'estimated' do
    scenario 'create a task'
    scenario 'cannot create a task with no draft estimate'
  end
end
