require 'spec_helper'

describe "AdminPages" do
  
  let(:admin_user) { FactoryGirl.create(:user, account_type: :admin,
                                is_admin: true,
                                is_active: true,
                                name: 'Admin User',
                                email: 'admin@example.com',
                                password: 'foobar',
                                password_confirmation: 'foobar') }
  let(:standard_user) { FactoryGirl.create(:user, account_type: :standard,
                                is_admin: false,
                                is_active: true,
                                name: "Standard User",
                                email: 'standard@example.com',
                                password: 'foobar',
                                password_confirmation: 'foobar') }
  let(:other_user) { FactoryGirl.create(:user, account_type: :standard,
                                is_admin: false,
                                is_active: true,
                                name: "Other User",
                                email: 'other@example.com',
                                password: 'foobar',
                                password_confirmation: 'foobar') }

  before do
    admin_user.save
    standard_user.save
    other_user.save
  end

  subject { page }

  context "access to overwatch" do

    describe "admin user should have access" do
      before do 
        valid_login(admin_user)
        visit all_users_path
      end

      it { should have_selector('h1', text: "All Users") }
      it { should have_content standard_user.name }
      it { should have_content other_user.name }
    end

    describe "standard user should not have access" do
      before do
        valid_login(standard_user)
        visit all_users_path
      end

      it { should_not have_selector('h1', text: "All Users") }
      it { should_not have_content admin_user.name }
      it { should_not have_content other_user.name } 
    end
  end

  context "header buttons" do
    
    describe "admin user should see header menu items" do
      before { valid_login(admin_user) }

      it { should have_link("All Users", href: all_users_path) }
    end

    describe "standard_user should not see admin links" do
      before { valid_login(standard_user) }

      it { should_not have_link("All Users", href: all_users_path) }
    end

    describe "admin links should not be shown for non-logins" do
      before { visit root_path }

      it { should have_link("Log In", href: login_path) }
      it { should_not have_link("All Users", href: all_users_path) }
    end
  end

  context "overwatch All Users page" do
    before do
      valid_login(admin_user)
      visit all_users_path
    end

    it { should have_selector('h1', text: "All Users") }
    it { should have_content standard_user.name }
    it { should have_content other_user.name }

    it { should have_content "Admin User (Admin)" }

    it { should have_content admin_user.email }
    it { should have_content standard_user.email }
    it { should have_content other_user.email }

    it { should have_content admin_user.last_login }
    it { should have_content standard_user.last_login }
    it { should have_content other_user.last_login }
  end 

end
