require 'spec_helper'

describe "TrialPages" do

  # test the interaction of trial accounts

  let(:trial_user) { FactoryGirl.create(:user, account_type: 'trial') }

  let(:expired_user) do
   FactoryGirl.create(:user, account_type: 'trial', trial_expire: 7.days.ago) 
  end

  subject { page }

  before do
    trial_user.save
    expired_user.save
  end

  context "when user is on trial account" do
    before { valid_login trial_user }

    describe "user dashboard" do
      before { visit user_path(trial_user) }

      it { should have_selector 'h1', text: trial_user.name }
      it { should have_content "Account type: trial" }
      it { should have_content trial_user.trial_expire.to_date.to_s }
      it { should have_content "Account status: active" }
    end

    describe "account limits" do
      subject { trial_user }
      its(:client_limit) { should == 24 }
      its(:project_limit) { should == 4 }
    end

    describe "visiting Projects page" do
      before { visit projects_path }

      it { should have_selector 'h1', text: "Projects" }
    end

    describe "visiting Clients page" do
      before { visit clients_path }

      it { should have_selector 'h1', text: "Clients" }
    end

    describe "visiting Calendar page" do
      before { visit calendar_path }
      
      it { should have_selector 'h1', text: "Calendar" }

      describe "creating new event" do
        before { click_link "New Event" }

        it { should have_selector 'h1', text: 'New Event' }
      end
    end
  end

  context "When user trial expires" do
    before { valid_login expired_user }

    describe "user dashboard" do
      before { visit user_path(expired_user) }

      it { should have_selector 'h1', text: expired_user.name }
      it { should have_content "Account type: trial" }
      it { should have_content "Account status: active" }
    end

    describe "when accessing Projects page" do
      before { visit projects_path }

      it { should_not have_selector 'h1', text: 'Projects' }
      it { should have_selector 'h1', text: 'Subscription Plans' }
      it { should have_content 'trial has expired' }

      it "should have changed user to inactive" do
        expired_user.is_active { should == false }
      end

      describe "then accessing another page" do
        before { visit clients_path }

        it { should_not have_selector 'h1', text: "Clients" }
        it { should have_selector 'h1', text: "Your Account is Inactive" }
        it { should have_link "activating a subscription", href: plans_path }
        it { should have_link "contact the system administrator", href: contact_us_path }
      end

      describe "then accessing user dashboard" do
        before { visit user_path(trial_user) }

        it { should have_selector 'h1', text: expired_user.name }
        it { should have_content "Account type: trial" }
        it { should have_content "Account status: inactive" }
      end
    end
  end

end
