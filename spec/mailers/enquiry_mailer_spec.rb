require "spec_helper"

describe EnquiryMailer do
  
  before do
    @user = User.new(name: "Test User", email: "user@test.com",
                      password: "foobar", password_confirmation: "foobar")
    @user.save
    @enquiry = FactoryGirl.create(:enquiry, user: @user)
    @enquiry.save
  end

  describe "enquiry notify" do
    it "should render successfully" do
      lambda { EnquiryMailer.enquiry_notify(@user, @enquiry) }.
                should_not raise_error
    end

    context "rendered without errors" do
      before do
        @mailer = EnquiryMailer.enquiry_notify(@user, @enquiry)
      end

      it "should have the enquirer name" do
        @mailer.html_part.body.should have_content(@enquiry.name)
        @mailer.text_part.body.should have_content(@enquiry.name)
      end

      it "should be added to the delivery queue" do
        lambda { @mailer.deliver }.
            should change(ActionMailer::Base.deliveries, :size).by(1)
      end

      it "should deliver successfully" do
        lambda { @mailer.deliver }.should_not raise_error
      end 

    end
  end


end
