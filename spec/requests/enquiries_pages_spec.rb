require 'spec_helper'

describe "EnquiriesPages" do
  let(:user) { FactoryGirl.create(:user) }
  let(:enquiry_one) { FactoryGirl.create(:enquiry, user: user) }
  let(:enquiry_two) { FactoryGirl.create(:enquiry, user: user) }

  before do
    user.save
    enquiry_one.save
    enquiry_two.save
    valid_login(user)
  end

  subject { page }

  describe "enquiries index" do
    before { visit enquiries_path }

    it { should have_content("Enquiries") }
    it { should have_content(enquiry_one.name) }
    it { should have_content(enquiry_two.name) }
    it { should have_content(user.long_id) }
  end

  describe "show page" do
    before { visit enquiry_path(enquiry_one) }

    it { should have_content(enquiry_one.name) }
    it { should have_content(enquiry_one.email) }
    it { should have_content(enquiry_one.message) }
    it { should have_link("Delete") }
  end

  describe "creation" do
    before do
      click_link "Log Out" 
      visit new_enquiry_url(user_id: user.long_id)
    end

    it { should have_selector('h1', text: "Enquire: #{user.name}") }
    it { should have_content("Name") }
    it { should have_content("Email") }
    it { should have_content("Message") }
    it { should have_button("Submit") }

    describe "with valid information" do
      before do
        fill_in "Name", with: "John Doe"
        fill_in "Email", with: "johnd@gmail.com"
        fill_in "Message", with: Faker::Lorem.paragraph(sentence_count = 4)
      end

      it "should add a record to database" do
        expect do
          click_button("Submit")
        end.to change(Enquiry, :count).by(1)
      end

      describe "redirect" do
        before { click_button("Submit") }

        it { should have_content("Sent Enquiry to #{user.name}") }
      end
    end

    describe "with invalid information" do
      before do
        fill_in "Message", with: Faker::Lorem.paragraph(sentence_count = 4)
      end

      it "should not add a record to database" do
        expect do
          click_button("Submit")
        end.not_to change(Enquiry, :count)
      end

      # describe "error messages" do
      #   before { click_button("Submit") }

      #   it { should have_content("error") }
      # end
    end
  end

  describe "deletion" do
    before { visit enquiry_path(enquiry_one) }
    
    it { should have_link("Delete") }
    it "should remove enquiry from database" do
      expect do
        click_link("Delete")
      end.to change(Enquiry, :count).by(-1)
    end

    describe "redirect" do
      before { click_link "Delete" }

      it { should have_content("Enquiries") }
    end
  end
end
