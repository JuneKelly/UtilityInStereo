require 'spec_helper'

describe "PhasePages" do
  let(:user)        { FactoryGirl.create(:user) }
  let(:wrong_user)  { FactoryGirl.create(:user) }
  let(:client)      { FactoryGirl.create(:client, user: user, name: "Pillhead") }

  let(:project_one) { FactoryGirl.create(:project, client: client) }

  let(:phase_one)   { project_one.phases.create(title: "der1", is_done: false) }
  let(:phase_two)   { project_one.phases.create(title: "der2", is_done: false) }

  let(:task_one)    { FactoryGirl.create(:task, phase: phase_one) }
  let (:task_two)   { FactoryGirl.create(:task, phase: phase_one) }
  let (:task_three) { FactoryGirl.create(:task, phase: phase_two) }

  before do
    user.save
    wrong_user.save
    client.save
    project_one.save
    phase_one.save
    phase_two.save
    task_one.save
    task_two.save
    task_three.save
    valid_login(user)
  end

  subject { page }

  describe "phase show page" do
    before do
      visit phase_path(phase_one)
    end

    it { should have_selector('h1', text: phase_one.title) }
    it { should have_content(phase_one.project.title) }
    it { should have_content(phase_one.details) }
    it { should have_link('Edit') }
    it { should have_link('Mark Phase As Done') }
    it { should have_link('New Task') }

    describe "tasks" do
      it { should have_content(task_one.title) }
      it { should have_content(task_two.title) }
      it { should_not have_content(task_three.title) }
    end
  end

  describe "phase create page" do
    before do
      visit new_project_phase_path(project_one)
    end

    it { should have_selector('h1', text: "New Phase for #{project_one.title}")}
    it { should have_selector('label', text: 'Title') }
    it { should have_selector('label', text: 'Details') }
    it { should have_selector('label', text: 'Charging flat rate ?') }
    it { should have_selector('label', text: 'Flat rate') }
    it { should have_selector('label', text: 'Due date') }
    it { should have_button('Create') }

    describe "with invalid info" do
      before do
        fill_in 'Title', with: ''
      end

      it "should not create a Phase" do
        expect do
          click_button 'Create'
        end.not_to change(Phase, :count)
      end

      describe "error messages" do
        before do
          click_button 'Create'
        end

        it { should have_selector('h1', 
                    text: "New Phase for #{project_one.title}") }
        it { should have_content('error') }
      end
    end

    describe "with valid info" do
      before do
        fill_in 'Title', with: "der3"
        fill_in 'Details', with: "Blah blah"
      end

      it "should create a Phase" do
        expect do
          click_button 'Create'
        end.to change(Phase, :count).by(1)
      end

      describe "redirect to Phase page" do
        before do
          click_button 'Create'
        end

        it { should have_selector('h1', text: "der3") }
        it { should_not have_content('error') }
      end

      # describe "navigating to Project" do
      #   before { visit project_path(project_one) }

      #   it { should have_content(project_one.title) }
      #   it { should have_content("der3") }
      # end
    end
  end

  describe "phase edit page" do
    before do
      visit edit_phase_path(phase_one)
    end

    it { should have_selector('h1', text: 'Edit Phase') }
    it { should have_selector('label', text: 'Title') }
    it { should have_selector('label', text: 'Details') }
    it { should have_selector('label', text: 'Done ?') }
    it { should have_selector('label', text: 'Charging flat rate ?') }
    it { should have_selector('label', text: 'Flat rate') }
    it { should have_selector('label', text: 'Due date') }
    it { should have_button('Save') }
    it { should have_link("Delete") }

    describe "with invalid info" do
      before do
        fill_in 'Title', with: ''
        click_button 'Save'
      end

      it { should have_content('Edit Phase') }
      it { should have_content('error') }
    end

    describe "with valid info" do
      before do
        fill_in 'Title', with: 'New Phase Title'
        click_button 'Save'
      end 

      it { should have_selector('h1', text: 'New Phase Title') }
      it { should_not have_content('error') }
    end
  end

  describe "delete phase" do
    before do
      visit edit_phase_path(phase_one)
      click_link "Delete"
    end

    it { should have_selector('h1', text: project_one.title) }
    it { should_not have_selector('h2', text:phase_one.title) }
    it { should have_content('Deleted Phase') }
  end

  describe "mark phase as done" do
    before { visit phase_path(phase_one) }

    it { should have_link 'Mark Phase As Done' }

    describe "clicking Done link" do
      before do
        click_link 'Mark Phase As Done'
        visit phase_path(phase_one)
      end

      it { should_not have_link 'Mark Phase As Done' }
      it { should have_content 'This Phase is Done!' }
    end
  end
end
