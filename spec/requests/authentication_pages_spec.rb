require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "Login" do
    let(:user) { FactoryGirl.create(:user, name: "John Doe") }

    before { visit login_path }

    it { should have_selector('h1',  text: 'Log In') }
    it { should have_selector('label',  text: 'Email') }
    it { should have_selector('label',  text: 'Password') }

    describe "with invalid information" do
      before { invalid_login(user) }

      it { should have_selector('h1', text: 'Log In')}
      it { should have_content('Error') }
    end

    describe "with valid information" do
      before { valid_login(user) }

      it { should have_content('Logged in') }
      it { should have_link('Log Out') }
      it { should have_link(user.name) }
      it { should have_selector('h1', text: user.name) }
      it { should have_content(user.email) }
      it { should_not have_content('Error') }

      describe "sidebar links" do
        it { should have_link('Clients') }
        it { should have_link('Projects') }
        it { should have_link('Calendar') }
        it { should have_link('Enquiries') }
      end

      describe "last_login field" do
        it "should equal todays date" do
          user.last_login.to_date.should == Date.today 
        end
      end

      describe "and then logout" do
        before { click_link('Log Out') }

        it { should have_link('Log In') }
      end
    end

  end

  describe "authorization" do

    describe "for logged in users" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        valid_login(user)
      end

      describe "attempt to sign up" do
        # ToDo
      end

      describe "homepage should redirect to user page" do
        before do
          visit root_path
        end

        it { should have_selector('h1', text: user.name) }
      end
    end

    describe "for non-logged-in users" do

      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit protected page" do

        describe "after logging in" do
          before do
            visit user_path(user)
            valid_login(user)
          end

          it "should show desired protected page" do
            page.should have_selector('h1', text: user.name)
          end

          describe "when logging in again" do
            before do
              click_link("Log Out")
              valid_login(user)
            end

            it "should show default user page" do
              page.should have_selector('h1', text:user.name)
            end
          end
        end
      end

      describe "in the Users controller" do
        describe "visiting a users page" do
          before { visit user_path(user) }
          it { should have_selector('h1', text: "Log In") }
        end

        describe "visiting edit user page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: "Log In") }
        end

        describe "submitting to update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to the delete action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Clients Controller" do
        let(:client) { FactoryGirl.create(:client, user: user) }
        before { client.save }

        describe "visiting show page" do
          before { visit client_path(client) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(client.name) }
        end

        describe "visiting index page" do
          before { visit clients_path }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_selector('h1', text: 'Clients') }
        end

        describe "visiting edit page" do
          before { visit edit_client_path(client) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(client.name) }
        end

        describe "submitting to update action" do
          before { put client_path(client) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete client_path(client) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Contacts Controller" do
        let(:client) { FactoryGirl.create(:client, user: user) }
        let(:contact) { FactoryGirl.create(:contact, client: client) }
        before do
          client.save
          contact.save
        end

        describe "visiting edit page" do
          before { visit edit_contact_path(contact) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(contact.name) }
        end

        describe "submitting to update action" do
          before { put contact_path(contact) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete contact_path(contact) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Projects Controller" do
        let(:client) { FactoryGirl.create(:client, user: user) }
        let(:contact) { FactoryGirl.create(:contact, client: client) }
        let(:project) { FactoryGirl.create(:project, client: client) } 
        before do
          client.save
          contact.save
          project.save
        end

        describe "visiting show page" do
          before { visit project_path(project) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(project.title) }
        end

        describe "visiting index page" do
          before { visit projects_path }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_selector('h1', text: 'Projects') }
        end

        describe "visiting edit page" do
          before { visit edit_project_path(project) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(project.title) }
        end

        describe "submitting to update action" do
          before { put project_path(project) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete project_path(project) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Phases Controller" do
        let(:client) { FactoryGirl.create(:client, user: user) }
        let(:contact) { FactoryGirl.create(:contact, client: client) }
        let(:project) { FactoryGirl.create(:project, client: client) } 
        let(:phase) { project.phases.build(title: "ph") }
        before do
          client.save
          contact.save
          project.save
          phase.save
        end

        describe "visiting show page" do
          before { visit phase_path(phase) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(phase.title) }
        end

        describe "visiting edit page" do
          before { visit edit_phase_path(phase) }
          it { should have_selector('h1', text: 'Log In') }
          it { should_not have_content(phase.title) }
        end

        describe "submitting to update action" do
          before { put phase_path(phase) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete phase_path(phase) }
          specify { response.should redirect_to(login_path) }
        end
      end
    end 



    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }

      before do
        valid_login(user)
      end

      describe "in the Users controller" do
        describe "visiting a users page" do
          before { visit user_path(other_user) }
          it { should have_content('wrong user') }
          it { should_not have_content(other_user.name) }
        end

        describe "visiting edit user page" do
          before { visit edit_user_path(other_user) }
          it { should have_content('wrong user') }
          it { should_not have_content(other_user.name) }
        end

        describe "submitting to update action" do
          before { put user_path(other_user) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to the delete action" do
          before { delete user_path(other_user) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Clients Controller" do
        let(:client) { FactoryGirl.create(:client, user: other_user) }
        before { client.save }

        describe "visiting show page" do
          before { visit client_path(client) }
          it { should have_content('wrong user') }
          it { should_not have_content(client.name) }
        end

        describe "visiting edit page" do
          before { visit edit_client_path(client) }
          it { should have_content('wrong user') }
          it { should_not have_content(client.name) }
        end

        describe "submitting to update action" do
          before { put client_path(client) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete client_path(client) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Contacts Controller" do
        let(:client) { FactoryGirl.create(:client, user: other_user) }
        let(:contact) { FactoryGirl.create(:contact, client: client) }
        before do
          client.save
          contact.save
        end

        describe "visiting edit page" do
          before { visit edit_contact_path(contact) }
          it { should have_content('wrong user') }
          it { should_not have_content(contact.name) }
        end

        describe "submitting to update action" do
          before { put contact_path(contact) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete contact_path(contact) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Projects Controller" do
        let(:client) { FactoryGirl.create(:client, user: other_user) }
        let(:contact) { FactoryGirl.create(:contact, client: client) }
        let(:project) { FactoryGirl.create(:project, client: client) } 
        before do
          client.save
          contact.save
          project.save
        end

        describe "visiting show page" do
          before { visit project_path(project) }
          it { should have_content('wrong user') }
          it { should_not have_content(project.title) }
        end

        describe "visiting edit page" do
          before { visit edit_project_path(project) }
          it { should have_content('wrong user') }
          it { should_not have_content(project.title) }
        end

        describe "submitting to update action" do
          before { put project_path(project) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete project_path(project) }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Phases Controller" do
        let(:client) { FactoryGirl.create(:client, user: other_user) }
        let(:contact) { FactoryGirl.create(:contact, client: client) }
        let(:project) { FactoryGirl.create(:project, client: client) } 
        let(:phase) { project.phases.build(title: "ph") }
        before do
          client.save
          contact.save
          project.save
          phase.save
        end

        describe "visiting show page" do
          before { visit phase_path(phase) }
          it { should have_content('wrong user') }
          it { should_not have_content(phase.title) }
        end

        describe "visiting edit page" do
          before { visit edit_phase_path(phase) }
          it { should have_content('wrong user') }
          it { should_not have_content(phase.title) }
        end

        describe "submitting to update action" do
          before { put phase_path(phase) }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting to destroy action" do
          before { delete phase_path(phase) }
          specify { response.should redirect_to(login_path) }
        end
      end
    end
  end
end
