  require 'spec_helper'

describe "ProjectPages" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:wrong_user) { FactoryGirl.create(:user) }
  let(:client) do 
    FactoryGirl.create(:client, user: user, name: "Pillhead")
  end

  let(:project_one) do
    FactoryGirl.create(:project, client: client)
  end

  let(:phase_one) do
    project_one.phases.build(title: "ph1", is_done: false) 
  end
  let(:task_one) do
    FactoryGirl.create(:task, phase: phase_one)
  end
  let(:phase_two) do
    project_one.phases.build(title: "ph2", is_done: false) 
  end

  let(:project_two) do
    FactoryGirl.create(:project, client: client)
  end


  before do
    user.save
    wrong_user.save
    client.save
    project_one.save
    project_two.save
    phase_one.save
    task_one.save
    phase_two.save
    valid_login(user)
  end

  subject { page }

  describe "index" do
    before { visit projects_path }

    it { should have_selector('h1', text: 'Projects') }
    it { should have_selector('h2', text: project_one.title) }
    it { should have_selector('h2', text: project_two.title) }
  end 

  describe "done projects" do
    before do
      project_one.is_done = true
      project_one.save
      visit done_projects_path
    end

    it { should have_selector('h1', text: 'Done Projects') }
    it { should have_selector('h2', text: project_one.title) }
    it { should_not have_selector('h2', text: project_two.title) }

    describe "done project page" do
      before { visit project_path project_one }

      it { should have_link 'Un-Archive' }
      it { should_not have_link 'Edit' }
      it { should_not have_link 'New Phase' }

      describe "Unarchive" do
        before { click_link 'Un-Archive' }

        it { should have_link 'Edit' }
        it { should have_link 'Mark Project As Done' }
        it { should have_content 'project un-archived' }
      end

      describe "try to visit edit page" do
        before { visit edit_project_path(project_one) }

        it { should have_content "Sorry, the Project is Done" }
        it { should_not have_link "Save" }
      end

      describe "try to visit phase edit page" do
        before { visit edit_phase_path(phase_one) }

        it { should have_content "Sorry, the Project is Done" }
        it { should_not have_link "Save" }
      end

      describe "phase_one" do
        before { visit phase_path phase_one }

        it { should_not have_link 'Edit' }
        it { should_not have_link 'New Phase' }
      end
    end

  end

  describe "project page" do
    before do
      visit project_path(project_one)
    end

    it { should have_selector('h1', text: project_one.title) }
    it { should have_content(project_one.details) }
    it { should have_content('Quotation') }
    it { should have_content('Deposit') }

    it { should have_link('Edit') }
    it { should have_link('Mark Project As Done') }

    it { should have_content(project_one.client.name) }

    it { should have_content(phase_one.title) }
    it { should have_content(phase_two.title) }
    it { should have_content(phase_one.details) }
    it { should have_content(phase_two.details) }

    it { should_not have_content "Client View Preview" }

    it { should have_content "0 hours" }

    describe "as wrong user" do
      before do
        click_link 'Log Out'
        valid_login(wrong_user)
        visit project_path(project_one)
      end
      it { should have_content('wrong user') }
      it { should_not have_content(project_one.title) }
    end

    describe "phases and tasks" do
      let(:task_one) { FactoryGirl.create(:task, phase: phase_one) }
      let(:task_two) { FactoryGirl.create(:task, phase: phase_one) }
      let(:task_three) { FactoryGirl.create(:task, phase: phase_two) }
      before do
        task_one.save
        task_two.save
        task_three.save
        visit project_path(project_one)
      end

      it { should have_content(phase_one.title) }
      it { should have_content(phase_two.title) }
      it { should have_content(task_one.title) }
      it { should have_content(task_two.title) }
      it { should have_content(task_three.title) }
    end
  end

  describe "client view" do
    before do
      project_one.has_client_view = true
      project_one.client_view_message = "Hurr"
      project_one.save
    end

    context "project page" do
      before { visit project_path project_one }

      it { should have_content "Client View Preview" }
      it do 
        should have_link "Client View Preview",
                        href: project_client_view_path(id: project_one.long_id)
      end
    end

    context "client view page" do
      before { visit project_client_view_path(id: project_one.long_id) }

      it { should have_content project_one.client_view_message }
    end
  end

  describe "create project" do
    before do
      visit new_client_project_path(client)
    end

    it { should have_selector('h1', text: "New Project with #{client.name}") }
    it { should have_selector('label', text: 'Title') }
    it { should have_selector('label', text: 'Details') }
    it { should have_selector('label', text: 'Quotation') }
    it { should have_selector('label', text: 'Hourly rate') }
    it { should have_selector('label', text: 'Deposit') }
    it { should have_selector('label', text: 'Deadline') }
    it { should have_button('Create') }

    describe "limits" do
      before do
        @lite_user = FactoryGirl.create(:user, account_type: "lite")
        @c_one = @lite_user.clients.build(name:"c1")
        @c_one.save

        @standard_user = FactoryGirl.create(:user, account_type: "standard")
        @c_two = @standard_user.clients.build(name:"c2")
        @c_two.save
        
        @lite_user.project_limit.times do 
          p = FactoryGirl.create(:project, client: @c_one)
          p.save
        end
        @standard_user.project_limit.times do 
          p = FactoryGirl.create(:project, client: @c_two)
          p.save
        end
      end

      describe "limits for lite user" do
        before do
          click_link "Log Out"
          valid_login(@lite_user)
          visit new_client_project_path(@c_one)
        end

        it { should have_content "Sorry" }
        it { should_not have_selector('h1', text: 'New Project') }
      end

      describe "limits for standard user" do
        before do
          click_link "Log Out"
          valid_login(@standard_user)
          visit new_client_project_path(@c_two)
        end

        it { should have_content "Sorry" }
        it { should_not have_selector('h1', text: 'New Project') }
      end

    end

    describe "with invalid data" do

      it "should not create a Project" do
        expect do
          click_button 'Create'
        end.not_to change(Project, :count)
      end

      describe "error messages" do
        before { click_button 'Create' }

        it { should have_selector('h1',text: "New Project with #{client.name}")}
        it { should have_content('error') }
      end
    end

    describe "with valid data" do
      before do
        fill_in 'Title', with: "Project Title"
        fill_in 'Details', with: 'Lorem Ipsum'
        fill_in 'Quotation', with: 2400
        fill_in 'Hourly rate', with: 12.00
        fill_in 'Deposit', with: 800
        fill_in 'Deadline', with: 6.weeks.from_now
      end

      it "should create a Project record" do
        expect do
          click_button 'Create'
        end.to change(Project, :count).by(1)
      end

      describe "redirect" do
        before { click_button 'Create' }

        it { should have_selector('h1', text: "Project Title") }
      end

      context "phase templates" do

        describe "no phases" do
          before { click_button 'Create' }
          it { should_not have_content 'Pre-Production' }
          it { should_not have_content 'Tracking' }
          it { should_not have_content 'Editing' }
          it { should_not have_content 'Mixing' }
          it { should_not have_content 'Mastering' }
        end

        describe "p-t-e-mi-ma" do
          before do
            select('preproduction - tracking - editing - mixing - mastering', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should have_content 'Pre-Production' }
          it { should have_content 'Tracking' }
          it { should have_content 'Editing' }
          it { should have_content 'Mixing' }
          it { should have_content 'Mastering' }
        end

        describe "p-t-e-mi" do
          before do
            select('preproduction - tracking - editing - mixing', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should have_content 'Pre-Production' }
          it { should have_content 'Tracking' }
          it { should have_content 'Editing' }
          it { should have_content 'Mixing' }
          it { should_not have_content 'Mastering' }
        end

        describe "p-t-e" do
          before do
            select('preproduction - tracking - editing', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should have_content 'Pre-Production' }
          it { should have_content 'Tracking' }
          it { should have_content 'Editing' }
          it { should_not have_content 'Mixing' }
          it { should_not have_content 'Mastering' }
        end

        describe "p-t" do
          before do
            select('preproduction - tracking', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should have_content 'Pre-Production' }
          it { should have_content 'Tracking' }
          it { should_not have_content 'Editing' }
          it { should_not have_content 'Mixing' }
          it { should_not have_content 'Mastering' }
        end

        describe "mi-ma" do
          before do
            select('mixing - mastering', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should_not have_content 'Pre-Production' }
          it { should_not have_content 'Tracking' }
          it { should_not have_content 'Editing' }
          it { should have_content 'Mixing' }
          it { should have_content 'Mastering' }
        end

        describe "e-mi-ma" do
          before do
            select('editing - mixing - mastering', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should_not have_content 'Pre-Production' }
          it { should_not have_content 'Tracking' }
          it { should have_content 'Editing' }
          it { should have_content 'Mixing' }
          it { should have_content 'Mastering' }
        end

        describe "e-mi" do
          before do
            select('editing - mixing', 
              from: 'template_type')
            click_button 'Create'
          end
          it { should_not have_content 'Pre-Production' }
          it { should_not have_content 'Tracking' }
          it { should have_content 'Editing' }
          it { should have_content 'Mixing' }
          it { should_not have_content 'Mastering' }
        end
      end
    end
  end 

  describe "edit page" do
    before do
      visit edit_project_path(project_one)
    end

    it { should have_selector('h1', text: "Edit Project") }
    it { should have_selector('label', text: 'Title') }
    it { should have_selector('label', text: 'Details') }
    it { should have_selector('label', text: 'Done ?') }
    it { should have_selector('label', text: 'Quotation') }
    it { should have_selector('label', text: 'Paid in full ?') }
    it { should have_selector('label', text: 'Hourly rate') }
    it { should have_selector('label', text: 'Deposit') }
    it { should have_selector('label', text: 'Deposit paid ?') }
    it { should have_selector('label', text: 'Deadline') }
    it { should have_button('Save') }

    describe "with invalid data" do
      before { fill_in 'Title', with: '' }

      describe "error messages" do
        before { click_button 'Save' }

        it { should have_content('error') }
      end
    end

    describe "with valid data" do
      before do
        fill_in 'Title', with: 'New Title'
        fill_in 'Details', with: 'New Details'
        click_button 'Save'
      end

      it { should have_selector('h1', text: 'New Title') }
      it { should have_content('New Details') }
    end
  end

  describe "delete project" do
    before do
      visit edit_project_path(project_one)
    end

    it { should have_link 'Delete Project' }

    it "should delete the project" do
      expect do
        click_link 'Delete Project'
      end.to change(Project, :count).by(-1)
    end

    describe "redirection" do
      before { click_link 'Delete Project' }

      it { should have_selector('h1', text: 'Projects') }
    end
  end

  describe "mark project as done" do
    before { visit project_path(project_one) }

    it { should have_link 'Mark Project As Done' }

    describe "clicking the Done button" do
      before do
        click_link 'Mark Project As Done'
        visit project_path(project_one)
      end

      it { should_not have_link 'Mark Project As Done' }
      it { should have_content 'This Project is Done!' }

      describe "Phases should be done" do
        describe "phase_one" do
          before { visit phase_path(phase_one) }

          it { should_not have_link 'Mark Phase As Done' }
          it { should have_content 'This Phase is Done!' }

          describe "and task" do
            before { visit task_path(task_one) }

            it { should_not have_link 'Done' }
            it { should have_content('This task is done') }
          end
        end

        describe "phase_two" do
          before { visit phase_path(phase_two) }

          it { should_not have_link 'Mark Phase As Done' }
          it { should have_content 'This Phase is Done!' }
        end
      end
    end
  end
end
