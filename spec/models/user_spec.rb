require 'spec_helper'

describe User do
  
  before do
    @user = User.new(name: "Test User", email: "user@test.com",
                      password: "foobar", password_confirmation: "foobar")
    @user.save
  end

  subject { @user }


  # Response tests
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:is_admin) }
  its(:is_admin) { should == false }

  it { should respond_to(:clients) }
  it { should respond_to(:projects) }
  it { should respond_to(:events) }
  
  it { should respond_to(:long_id) }
  it { should respond_to(:last_login) }
  it { should respond_to(:account_type) }
  it { should respond_to(:is_active) }

  it { should respond_to(:client_limit) }
  it { should respond_to(:project_limit) }

  it { should respond_to(:trial_expire) }

  # Validation tests
  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = nil }
    it { should_not be_valid } 
  end

  describe "when name is too long" do
    before { @user.name = "#{'a' * 51}" }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = nil }
    it { should_not be_valid }
  end

  describe "when email is incorrect format" do
    bad_addresses = ["user@gmailcom", "@gmail.com", "user@hotmail",
                      "test.user@foo.", "useratgmail.com"]
    bad_addresses.each do |address|
      before { @user.email = address }
      it { should_not be_valid }
    end
  end

  describe "when email is correct format" do
    good_addresses = ["user@gmail.com", "first.last@gmail.com",
                        "user_one@gmail.com"]
    good_addresses.each do |address|
      before { @user.email = address }
      it { should be_valid }
    end
  end

  describe "when saving duplicate email" do
    before do
      @user.save
      @other_user = FactoryGirl.create(:user, email: @user.email)
      it "should not create a user" do
        expect { @other_user.save }.not_to change(User, :count)
      end
    end
  end

  describe "When password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # Limit tests
  describe "client limit" do 
    describe "lite" do
      before { @user.account_type = "lite" }
      its(:client_limit) { should == 24 }
    end

    describe "standard" do
      before { @user.account_type = "standard" }
      its(:client_limit) { should == 256 }
    end

    describe "tester" do
      before { @user.account_type = "tester" }
      its(:client_limit) { should == 256 }
    end

    describe "admin" do
      before { @user.account_type = "admin" }
      its(:client_limit) { should == 256 }
    end
  end

  describe "project limit" do 
    describe "lite" do
      before { @user.account_type = "lite" }
      its(:project_limit) { should == 4 }
    end

    describe "standard" do
      before { @user.account_type = "standard" }
      its(:project_limit) { should == 24 }
    end

    describe "tester" do
      before { @user.account_type = "tester" }
      its(:project_limit) { should == 24 }
    end

    describe "admin" do
      before { @user.account_type = "admin" }
      its(:project_limit) { should == 24 }
    end
  end

  # Accessible Attributes tests
  it "should not allow access to admin" do
    expect do
      User.new(is_admin: true)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  # Association tests
  describe "clients" do
    let(:client) { FactoryGirl.create(:client, user: @user) }

    before do
      client.save
    end

    describe "on deleting user" do

      it "should remove the client" do
        expect do
          @user.destroy
        end.to change(Client, :count).by(-1)
      end

      describe "client should not be present" do
        before { @user.destroy }

        # Todo
      end
    end

  end
end
