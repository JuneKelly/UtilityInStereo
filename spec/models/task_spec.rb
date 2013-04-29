require 'spec_helper'

describe Task do
  let(:user) { FactoryGirl.create(:user) }
  let(:client) { FactoryGirl.create(:client, user: user) }
  let(:project) { FactoryGirl.create(:project, client: client) }
  let(:phase) { project.phases.create(title: "der", is_done: false) }
  
  let(:task) { phase.tasks.create(title: "Task One", is_done: false)}

  subject { task }

  it { should respond_to(:title) }
  it { should respond_to(:is_done) }
  it { should respond_to(:phase) }
  it { should respond_to(:project) }
  it { should respond_to(:client) }
  it { should respond_to(:user) }
  it { should respond_to(:events) }
  its(:phase)   { should == phase }
  its(:project) { should == project }
  its(:client)  { should == client }
  its(:user)    { should == user }


  # Validations
  it { should be_valid } 

  describe "when title is not present" do
    before { task.title = nil }
    it { should_not be_valid }
  end

  describe "when phase_id is not present" do
    before { task.phase_id = nil }
    it { should_not be_valid }
  end

  # Accessible Attributes
  it "should not allow access to phase_id" do
    expect do
      Task.new(title: "blah", phase_id: 1)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
end
