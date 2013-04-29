require 'spec_helper'

describe Contact do
  let(:user) { FactoryGirl.create(:user) }
  let(:client) { FactoryGirl.create(:client, user: user) }
  let(:contact) { FactoryGirl.create(:contact, client: client) }

  subject { contact }

  it { should respond_to(:name) }
  it { should respond_to(:role) }
  it { should respond_to(:email) }
  it { should respond_to(:phone) }

  it { should respond_to(:client) }
  it { should respond_to(:user) }
  its(:client) { should == client }
  its(:user) { should == user }

  # Validation Tests
  it { should be_valid }

  describe "when client_id is not present" do
    before { contact.client_id = nil }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { contact.name = nil }
    it { should_not be_valid }
  end

  # Accessible Attributes tests
  it "should not allow access to client_id" do
    expect do
      Contact.new(name: "blah", client_id: 200)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
end
