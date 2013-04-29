require 'spec_helper'

describe Enquiry do
  
  before do
    @user = User.new(name: "Test User", email: "user@test.com",
                      password: "foobar", password_confirmation: "foobar")
    @user.save
    @enquiry = FactoryGirl.create(:enquiry, user: @user)
  end

  subject { @enquiry }

  # Responses
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:message) }
  it { should respond_to(:viewed) }
  its(:viewed) { should be false }
  it { should respond_to(:user) }
  its(:user) { should == @user }


  # Validations
  it { should be_valid }

  describe "without a name" do
    before do
      @enquiry.name = nil
    end

    it { should_not be_valid }
  end

  describe "without an email" do
    before do
      @enquiry.email = nil
    end

    it { should_not be_valid }
  end

  describe "without a user" do
    before do
      @enquiry.user = nil
    end

    it { should_not be_valid }
  end


  # Accessible Attributes
  it "should not allow access to user_id" do
    expect do
      Enquiry.new(name: "Rar", user: 1)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end


  # Associations


  
end
