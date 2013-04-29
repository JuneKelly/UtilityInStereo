require 'spec_helper'

describe "UserActivePages" do

  # test access to pages when the user is inactive

  let(:user)        { FactoryGirl.create(:user) }
  let(:client)      { FactoryGirl.create(:client, user: user, name: "Pillhead") }
  let(:contact)     { FactoryGirl.create(:contact, client: client) }
  let(:project)     { FactoryGirl.create(:project, client: client, has_client_view: true) }
  let(:phase)       { project.phases.build(title: "der", is_done: false) }
  let(:task_one)    { FactoryGirl.create(:task, phase: phase) }

  let(:enquiry_one) { FactoryGirl.create(:enquiry, user: user) }
  let(:event_one)   do
    FactoryGirl.create(:event, user: user, task: nil,
                              start_at: "2014-10-07 11:45:00",
                              end_at:   "2014-10-09 18:00:00")
  end

  before do 
    phase.save
    user.is_active = false
    user.save

    valid_login(user)
  end 

  subject { page }

  context "user page access" do

    describe "user profile" do
      before { visit user_path user }

      it { should_not have_selector 'h1', text: "Your Account is Inactive" }
    end 

    describe "user edit" do
      before { visit edit_user_path user }

      it { should_not have_content "Your Account is Inactive" }

      describe "submitting" do
        before do 
          fill_in "Name", with: "Name Two"
          click_button 'Save'
        end
        it { should_not have_content "Your Account is Inactive" }
        it { should have_content "Name Two" }
      end
    end 
  end

  context "client access" do
    describe "client index" do
      before { visit clients_path }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "single client" do 
      before { visit client_path client }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "new client" do
      before { visit new_client_path }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "edit client" do
      before { visit edit_client_path client }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

  end

  context "contact access" do
    describe "new contact" do
      before { visit new_contact_path(client) }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end
  end

  context "project access" do
    describe "project index" do
      before { visit projects_path }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "single project" do 
      before { visit project_path project }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "new project" do
      before { visit new_client_project_path(client) }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "edit project" do
      before { visit edit_project_path project }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "project client view" do
      before do
        click_link "Log Out"
        visit project_client_view_path(id: project.long_id)
      end
      it { should_not have_content project.title }
      it { should have_content "Project not found" }
    end
  end

  context "phase access" do
    describe "phase page" do
      before { visit phase_path phase }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "new phase" do
      before { visit new_project_phase_path(project) }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "edit phase" do
      before { visit edit_phase_path phase }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end
  end

  context "task access" do
    describe "task page" do
      before { visit task_path task_one }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "new task" do
      before { visit new_phase_task_path(phase) }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "edit task" do
      before { visit edit_task_path task_one }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end
  end

  context "enquiry access" do
    describe "enquiry index" do
      before { visit enquiries_path }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "single enquiry" do 
      before { visit enquiry_path enquiry_one }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "public enquiry page" do
      before do
        click_link "Log Out"
        visit new_enquiry_url(user_id: user.long_id)
      end
      it { should_not have_content project.title }
      it { should have_content "No Such User" }
    end
  end

  context "event access" do
    describe "calendar" do
      before { visit calendar_path }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "new event" do
      before { visit new_event_path }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end

    describe "edit event" do
      before { visit edit_event_path event_one }
      it { should have_selector 'h1', text: "Your Account is Inactive" }
    end
  end
end