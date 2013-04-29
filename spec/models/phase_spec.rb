require 'spec_helper'

describe Phase do
  let(:user) { FactoryGirl.create(:user) }
  let(:client) { FactoryGirl.create(:client, user: user) }
  let(:project) { FactoryGirl.create(:project, client: client) }
  let(:phase) { project.phases.build(title: "der", is_done: false) }

  subject { phase }

  it { should respond_to(:title) }
  it { should respond_to(:details) }
  it { should respond_to(:is_flat_rate) }
  it { should respond_to(:flat_rate) }
  it { should respond_to(:due_date) }
  it { should respond_to(:is_done) }

  it { should respond_to(:project) }
  its(:project) { should == project }

  it { should respond_to(:client) }
  its(:client) { should == client }

  it { should respond_to(:user) }
  its(:user) { should == user}

  it { should respond_to(:tasks) }

  it { should respond_to(:order_index) }

  # Validation Tests
  it { should be_valid }

  describe "when title is not present" do
    before { phase.title = nil }
    it { should_not be_valid }
  end

  describe "when project_id is not present" do
    before { phase.project_id = nil }
    it { should_not be_valid }
  end


  # Accessible Attributes Tests
  it "should not allow access to project_id" do
    expect do
      Phase.new(title: "blah", project_id: 200)
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  # Assocciations 
  describe "tasks" do
    let(:task) { FactoryGirl.create(:task, phase: phase) }

    before do
      user.save
      client.save
      project.save
      phase.save
      task.save
    end

    describe "when deleting a phase" do
      it "should remove the task" do
        expect { phase.destroy }.to change(Task, :count).by(-1)
      end

      it "should not remove the project" do
        expect { phase.destroy }.not_to change(Project, :count)
      end
    end
  end
end
