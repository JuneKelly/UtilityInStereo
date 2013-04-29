require 'spec_helper'

describe Project do
  let(:user) { FactoryGirl.create(:user) }
  let(:client) { FactoryGirl.create(:client, user: user) }
  let(:project) { FactoryGirl.create(:project, client: client) }

  subject { project }

  it { should respond_to(:title) }
  it { should respond_to(:details) }
  it { should respond_to(:quotation) }
  it { should respond_to(:is_done) }
  it { should respond_to(:hourly_rate) }
  it { should respond_to(:deposit) }
  it { should respond_to(:deposit_paid) }
  it { should respond_to(:is_paid_in_full) }  
  it { should respond_to(:deadline) }

  it { should respond_to(:has_client_view) }
  it { should respond_to(:client_view_message) }
  
  it { should respond_to(:phases) }
  it { should respond_to(:tasks) }

  it { should respond_to(:long_id) }

  it { should respond_to(:user) }
  it { should respond_to(:client) }
  its(:user)    { should == user }
  its(:client)  { should == client }

  # Validation tests
  it { should be_valid }

  describe "when title is not present" do
    before { project.title = nil }
    it { should_not be_valid }
  end

  describe "when client_id is not present" do
    before { project.client_id = nil }
    it { should_not be_valid }
  end


  # Accessible Attributes tests
  it "should not allow access to user_id" do
    expect do
      Project.new(name: "blah", user_id: 200)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  it "should not allow access to client_id" do
    expect do
      Project.new(name: "blah", client_id: 200)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  # Associations
  describe "phases" do
    let(:phase) { project.phases.build(title: "der", is_done: false) }

    before do
      client.save
      project.save
      phase.save
    end

    describe "when deleting project" do
      it "should remove the phase" do
        expect { project.destroy }.to change(Phase, :count).by(-1)
      end

      it "should not remove the client" do
        expect { project.destroy }.not_to change(Client, :count)
      end
    end
  end

end
