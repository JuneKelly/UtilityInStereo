require 'spec_helper'

describe "TasksPages" do
  let(:user)        { FactoryGirl.create(:user) }
  let(:client)      { FactoryGirl.create(:client, user: user, name: "Pillhead") }
  let(:project_one) { FactoryGirl.create(:project, client: client) }
  let(:phase_one)   { project_one.phases.build(title: "der", is_done: false) }
  let(:task_one)    { FactoryGirl.create(:task, phase: phase_one) }

  before do
    user.save
    client.save
    project_one.save
    phase_one.save
    task_one.save
    valid_login(user)
  end

  subject { page }

  describe "create task" do
    before { visit new_phase_task_path(phase_one) }

    it { should have_selector('h1', text: "New Task") }
    it { should have_selector('label', text: 'Title') }
    it { should have_button('Create') }

    describe "with valid information" do
      before { fill_in 'Title', with: 'Valid Title' }

      it "should create a task" do
        expect{ click_button 'Create' }.to change(Task, :count).by(1)
      end

      describe "redirect" do
        before { click_button 'Create' }
        it { should have_selector('h1', text: phase_one.title) }
        it { should have_content(phase_one.project.title) }
      end
    end

    describe "with invalid information" do
      before { fill_in 'Title', with: '' }

      it "should not create a task" do
        expect { click_button 'Create' }.not_to change(Task, :count)
      end

      describe "error messages" do
        before { click_button 'Create' }
        it do 
          should have_selector('h1', text: "New Task for #{phase_one.title}")
        end
        it { should have_content('error') }
      end
    end
  end

  describe "show task" do
    let(:event_one) { FactoryGirl.create(:event, task: task_one, user: user) }
    let(:event_two) { FactoryGirl.create(:event, task: task_one, user: user) }
    before do
      event_one.save
      event_two.save
      visit task_path(task_one)
    end

    it { should have_selector('h1', text: task_one.title) }
    it { should have_link( task_one.phase.title) }
    it { should have_link( task_one.phase.project.title) }
    it { should have_link 'Edit' }
    it { should have_link 'Make Event' }
    it { should have_link 'Delete' }
    it { should have_content(event_one.title) }
    it { should have_content(event_two.title) }
  end

  describe "edit task" do
    before { visit edit_task_path(task_one) }

    it { should have_selector('h1', text: "Edit Task for #{phase_one.title}") }
    it { should have_selector('label', text: 'Title') }
    it { should have_button('Save') }

    describe "with valid information" do
      before { fill_in 'Title', with: 'New Valid Title' }

      describe "redirect" do
        before { click_button 'Save' }
        it { should have_selector('h1', text: phase_one.title) }
        it { should have_content(phase_one.project.title) }
        it { should have_content('New Valid Title') }
      end
    end

    describe "with invalid information" do
      before { fill_in 'Title', with: '' }

      describe "error messages" do
        before { click_button 'Save' }
        it do 
          should have_selector('h1', text: "Edit Task")
        end
        it { should have_content('error') }
      end
    end
  end

  describe "delete task" do
    before { visit edit_task_path(task_one) }

    it { should have_link('Delete') }

    it "should remove the task" do
      expect do
        click_link 'Delete'
      end.to change(Task, :count).by(-1)
    end

    describe "redirect" do
      before { click_link 'Delete' }
      it { should have_content(phase_one.title) }
    end
  end

  describe "mark task as done" do
    before { visit task_path(task_one) }

    it { should have_link 'Done' }

    describe "when clicking done button" do
      before do
        click_link 'Done'
        visit task_path(task_one)
      end

      it { should_not have_link 'Done' }
      it { should have_content('This task is done') }
    end
  end
end
