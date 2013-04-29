class EnquiryMailer < ActionMailer::Base
  default from: "notifier@utilityinstereo.com"

  def enquiry_notify(user, enquiry)
    @user = user
    @enquiry = enquiry
    mail(:to => @user.email, :subject => "New Enquiry Recieved - Utility In Stereo")
   end
end
