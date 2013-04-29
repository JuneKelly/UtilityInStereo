require 'spec_helper'

describe "UserPages" do
  
  let(:user) { FactoryGirl.create(:user) }

  subject { page }

  before do
    user.save
  end

  describe "signup page" do

  end

  describe "user homepage" do
    before do
      valid_login(user)
      visit user_path(user)
    end
    it { should have_selector('h1', text: user.name) }
    it { should have_content(user.email) }
    it { should have_link("Edit") }

    describe "as wrong user" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.save 
        visit user_path(other_user)
      end
      it { should_not have_selector('h1', text: other_user.name) }
      it { should have_content('wrong user') }
    end

    describe "events agenda" do
      it { should have_content "Upcoming Events" }
      
      context "with no events" do
        before do
          visit user_path(user)
        end

        it { should have_content "None"}
      end

      context "with less than 8 events" do
        before do
          4.times do
            e = FactoryGirl.create(:event, user: user, task: nil)
            e.save
          end 
          visit user_path(user)
        end

        it { should_not have_content "None" }

        it "should have event titles" do
          user.events.each do |event|
            page { should have_content event.title }
          end
        end
      end

      context "with more than 8 events" do
        before do
          12.times do
            e = FactoryGirl.create(:event, user: user, task: nil)
            e.save
          end 
          visit user_path(user)
        end

        it { should_not have_content "None" }

        it "should have first 8 event titles" do
          first_events = user.events.limit(8)

          first_events.each do |event|
            page { should have_content event.title }
          end
        end

        it "should not have last event title" do
          last_event = user.events.last
          page { should_not have_content last_event.title }
        end
      end
    end 
  end

  describe "user edit page" do
    before do
      valid_login(user)
      visit edit_user_path(user)
    end

    it { should have_selector('h1', text: "Edit Details") }
    it { should have_selector('label', text: "Name") }
    it { should have_selector('label', text: "Email") }
    it { should have_selector('label', text: "Password") }
    it { should have_selector('label', text: "Password confirmation") }

    describe "when submitting invalid info" do
      before do
        fill_in 'Email', with: 'blah'
        click_button 'Save'
      end
      it { should have_content('error') }

    end

    describe "when submitting valid info" do
      before do
        fill_in 'Email', with: "blah@gmail.com"
        fill_in 'Password', with: 'blahblah'
        fill_in 'Password confirmation', with: 'blahblah'
        click_button 'Save'
      end
      it { should have_content('blah@gmail.com') }
      it { should_not have_content('error') }
    end

    describe "as wrong user" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.save 
        visit edit_user_path(other_user)
      end
      it { should_not have_content(other_user.name) }
      it { should have_content('wrong user') }
    end
  end

end
