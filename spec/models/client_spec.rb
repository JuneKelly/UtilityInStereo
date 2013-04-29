require 'spec_helper'

describe Client do
  
  before do
    @user = User.new(name: "Test User", email: "user@test.com",
                      password: "foobar", password_confirmation: "foobar")
    @user.save
    @client = @user.clients.build(name: "First Client", 
                                description: "My first paying client", 
                                website: "www.client.com")
    @client.save
  end

  subject { @client }


  # Response tests
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:website) }
  it { should respond_to(:user) }
  it { should respond_to(:projects) }
  it { should respond_to(:contacts) }
  its(:user) { should == @user }

  # Validation tests
  it { should be_valid }

  describe "when user_id is not present" do
    before { @client.user_id = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @client.name = nil }
    it { should_not be_valid }
  end

  # Accessible Attributes tests
  it "should not allow access to user_id" do
    expect do
      Client.new(name: "blah", user_id: 1)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  # Associations 
  describe "contacts" do
    let(:contact) { FactoryGirl.create(:contact, client: @client) }

    before do
      contact.save
    end

    describe "on deleting client" do

      it "should remove the contact" do
        expect do
          @client.destroy
        end.to change(Contact, :count).by(-1)
      end

      it "should not remove user" do
        expect do
          @client.destroy
        end.not_to change(User, :count)
      end

      describe "client should not be present" do
        before { @client.destroy }

        # Todo
      end
    end
  end

  describe "projects" do
    let(:project) { FactoryGirl.create(:project, client: @client) }

    before { project.save }

    describe "on deleting client" do
      it "should remove the project" do
        expect do
          @client.destroy
        end.to change(Project, :count).by(-1)
      end
    end

    it "should not remove user" do
      expect do
        @client.destroy
      end.not_to change(User, :count)
    end
  end
end
