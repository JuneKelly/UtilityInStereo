require 'spec_helper'

describe "ClientPages" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:wrong_user) { FactoryGirl.create(:user) }
  let(:first_client) do 
    FactoryGirl.create(:client, user: user, name: "Pillhead")
  end
  let(:second_client) do 
    FactoryGirl.create(:client, user: user, name: "Dave Steel Band")
  end

  let(:contact_one) { FactoryGirl.create(:contact, client: first_client) }
  let(:contact_two) { FactoryGirl.create(:contact, client: first_client) }

  before do 
    user.save
    wrong_user.save
    first_client.save
    second_client.save
    contact_one.save
    contact_two.save
    valid_login(user)
  end

  subject { page }


  describe "client index page" do
    before do
      visit clients_path
    end

    it { should have_selector('h1', text: "Clients") }
    it { should have_link('New Client') }
    it { should have_selector('h2', text: first_client.name) }
    it { should have_selector('h2', text: second_client.name) }
    it { should have_link(first_client.name, href: client_path(first_client)) }

    describe "when logged in as wrong user" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do 
        logout
        valid_login(other_user)
        visit clients_path
      end

      it { should_not have_selector('h2', text: first_client.name) }
    end

    describe "when user inactive" do
      before do 
        user.is_active = false
        user.save
      end 

      describe "should redirect to inactive page" do
        before { visit clients_path }

        it { should have_content "Your Account is Inactive" }
      end
    end 
  end

  describe "client show" do
    before { visit client_path(first_client) }

    it { should have_selector('h1', text: first_client.name) }
    it { should have_link('Edit') }

    describe "contact details" do
      
      before do 
        visit client_path(first_client)
      end

      it { should have_selector('h2', text: 'Contact Details:') }
      it { should have_content(contact_one.name) }
      it { should have_content(contact_one.role) }
      it { should have_content(contact_one.email) }
      it { should have_content(contact_one.phone) }

      it { should have_content(contact_two.name) }
      it { should have_content(contact_two.role) }
      it { should have_content(contact_two.email) }
      it { should have_content(contact_two.phone) }

      it { should have_link('New Project') }

      it { should have_link('Add Contact Details') }
      it { should have_link("<< Back To Clients", href: clients_path) }
    end

    describe "as wrong user" do
      before do
        click_link 'Log Out'
        valid_login wrong_user
        visit client_path(first_client)
      end

      it { should_not have_selector('h1', text: first_client.name) }
      it { should have_content('wrong user') }
    end

    describe "project list" do
      before do
          @project_one = FactoryGirl.create(:project, client: first_client)
          @project_one.save
          @project_two = FactoryGirl.create(:project, client: first_client)
          @project_two.save
          visit client_path(first_client)
      end
      it { should have_content @project_one.title }
      it { should have_content @project_two.title }
    end
  end


  describe "client creation" do
    before do
      visit new_client_path(first_client)
    end

    it { should have_selector('h1', text: 'Create Client') }
    it { should have_selector('label', text: 'Name') }
    it { should have_selector('label', text: 'Description') }
    it { should have_selector('label', text: 'Website') }
    # it { should have_link('Create') }

    describe "limits" do
      before do
        @lite_user = FactoryGirl.create(:user, account_type: "lite")
        @standard_user = FactoryGirl.create(:user, account_type: "standard")
        @lite_user.client_limit.times do 
          c = @lite_user.clients.build(name: "test")
          c.save
        end
        @standard_user.client_limit.times do 
          c = @standard_user.clients.build(name: "test")
          c.save
        end
      end

      describe "limits for lite user" do
        before do
          click_link "Log Out"
          valid_login(@lite_user)
          visit new_client_path
        end

        it { should have_content "Sorry" }
        it { should_not have_selector('h1', text: 'Create Client') }
      end

      describe "limits for standard user" do
        before do
          click_link "Log Out"
          valid_login(@standard_user)
          visit new_client_path
        end

        it { should have_content "Sorry" }
        it { should_not have_selector('h1', text: 'Create Client') }
      end

    end

    describe "when submitting invalid information" do
      
      it " should not create a client" do
        expect do
          click_button 'Create'
        end.not_to change(Client, :count)
      end

      describe "error messages" do
        before { click_button 'Create' }

        it { should have_selector('h1', text: 'Create Client') }
        it { should have_content('error') }
      end

    end

    describe "when submitting valid information" do
      before do
        fill_in 'Name', with: 'My Client'
        fill_in 'Description', with: 'These guys rule!'
        fill_in 'Website', with: 'www.myclient.com'
      end

      it "should create a client" do
        expect do
          click_button 'Create'
        end.to change(Client, :count).by(1)
      end

      describe "redirect to client page" do
        before { click_button 'Create' }
        it { should have_selector('h1', text: 'My Client') }
      end
    end

    describe "when submitting minimal information" do
      before do
        fill_in 'Name', with: 'My Client'
      end

      it "should create a client" do
        expect do
          click_button 'Create'
        end.to change(Client, :count).by(1)
      end

      describe "redirect to client page" do
        before { click_button 'Create' }
        it { should have_selector('h1', text: 'My Client') }
      end
    end
  end


  describe "client edit" do
    before do
      visit client_path(first_client)
    end

    describe "should have edit link on client page" do
      before do
        visit client_path(first_client)
      end

      it { should have_link('Edit') }
    end

    describe "on edit page" do
      before do
        visit edit_client_path(first_client)
      end

      it { should have_selector('h1', text: 'Edit Client') }
      it { should have_selector('label', text: 'Name') }
      it { should have_selector('label', text: 'Description') }
      it { should have_selector('label', text: 'Website') }

      describe "when submitting incorrect info" do
        before do
          fill_in 'Name', with: ''
          click_button 'Save'
        end
        it { should have_content('error') }
      end

      describe "when submitting correct info" do
        let(:new_name) { "The New Name" }
        let(:new_description) { "The New Description" }

        before do
          fill_in 'Name', with: new_name
          fill_in 'Description', with: new_description
          click_button 'Save'
        end
        it { should have_selector('h1', text: new_name) }
        it { should have_content(new_description) }
      end

      describe "contacts" do
        it { should have_content(contact_one.name) }
        it { should have_content(contact_two.name) }
        it { should have_link('Edit', href: edit_contact_path(contact_one)) }
        it { should have_link('Edit', href: edit_contact_path(contact_two)) }
        it { should have_link('Delete Contact Details', href: contact_path(contact_one)) }
        it { should have_link('Delete Contact Details', href: contact_path(contact_two)) }
      end
    end
  end

  describe "client deletion" do
    before do
      visit edit_client_path(first_client)
    end

    it { should have_link('Delete') }
    
    it "should delete the client" do
      expect do
        click_link 'Delete'
      end.to change(Client, :count).by(-1)
    end
  end

  describe "contact operations" do

    describe "contact deletion" do
      before { visit edit_client_path(first_client) }

      it { should have_link('Delete Contact Details', 
                  href: contact_path(contact_one))}

      it "should remove the contact" do
        expect do
          click_link('Delete Contact Details')
        end.to change(Contact, :count).by(-1)
      end

      describe "should redirect to client edit page" do
        before do
          click_link('Delete Contact Details')
        end
        it { should have_selector('h1', text: 'Edit Client') }
        it { should_not have_content(contact_one.role) }
        it { should have_content(contact_two.name) }
      end
    end

    describe "create a contact" do
      before do
        visit client_path(first_client)
        click_link('Add Contact Details')
      end

      describe "form page" do
        it { should have_selector('h1', text: 'Add Contact Details') }
        it { should have_selector('label', text: "Name") }
        it { should have_selector('label', text: "Role") }
        it { should have_selector('label', text: "Email") }
        it { should have_selector('label', text: "Phone") }
        it { should have_button('Create') }
      end


      describe "with valid info" do
        before do
          fill_in 'Name', with: 'Valid Contact Name'
          fill_in 'Role', with: 'Guitarist'
          fill_in 'Email', with: 'contact@gmail.com'
          fill_in 'Phone', with: '01234554'
        end

        it "should create a Contact record" do
          expect do
            click_button 'Create'
          end.to change(Contact, :count).by(1)
        end 

        describe "redirect to the client page" do
          before { click_button 'Create' }
          it { should have_content(first_client.name) }
          it { should have_content('Valid Contact Name') }
        end
      end

      describe "with minimal info" do
        before do
          fill_in 'Name', with: 'Valid Contact Name'
        end

        it "should create a Contact record" do
          expect do
            click_button 'Create'
          end.to change(Contact, :count).by(1)
        end 

        describe "redirect to the client page" do
          before { click_button 'Create' }
          it { should have_content(first_client.name) }
          it { should have_content('Valid Contact Name') }
        end
      end

      describe "with invalid info" do
        
        it "should not create a Contact" do
          expect do
            click_button 'Create'
          end.not_to change(Contact, :count)
        end

        describe "error messages" do
          before { click_button 'Create' }
          it { should have_content('error') }
        end
      end
    end


    describe "edit a contact" do
      before { visit edit_contact_path(contact_one) }

      it { should have_selector('h1', text: 'Edit Contact Details') }
      it { should have_selector('label', text: 'Name') }
      it { should have_selector('label', text: 'Role') }
      it { should have_selector('label', text: 'Email') }
      it { should have_selector('label', text: 'Phone') }

      describe "with invalid info" do
        before do
          fill_in 'Name', with: ''
          click_button 'Save'
        end
        it { should have_content('error') }
        it { should_not have_selector('h1', text: first_client.name) }
      end

      describe "with valid info" do
        before do
          fill_in 'Name', with: 'Valid Name'
          click_button 'Save'
        end
        it { should have_selector('h3', text: 'Valid Name') }
        it { should_not have_content('error') }
      end

      describe "as wrong user" do
        before do
          click_link 'Log Out'
          valid_login wrong_user
          visit edit_contact_path(contact_one)
        end

        it { should_not have_selector('h1', text: 'Name') }
        it { should have_content('wrong user') }
      end

    end

  end
end
