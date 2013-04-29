require 'spec_helper'

describe Event do
  let(:user) { FactoryGirl.create(:user) }
  let(:client) { FactoryGirl.create(:client, user: user) }
  let(:project) { FactoryGirl.create(:project, client: client) }
  let(:phase) { project.phases.create(title: "der", is_done: false) }
  let(:task) { FactoryGirl.create(:task, phase: phase) }

  let(:event) { FactoryGirl.create(:event, user: user, task: task) }

  subject { event }

  it { should respond_to(:title) }
  it { should respond_to(:details) }
  it { should respond_to(:start_at) }
  it { should respond_to(:end_at) }
  it { should respond_to(:all_day) }
  it { should respond_to(:is_public) }
  
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should respond_to(:task) }

  describe "with a task assigned" do
    its(:task) { should == task }
  end

  describe "without a task assigned" do
    before { event.task = nil }
    it { should be_valid }
    its(:task) { should == nil }
  end

  # Validations
  it { should be_valid }

  describe "without a title" do
    before { event.title = nil }
    it { should_not be_valid } 
  end

  describe "without a user_id" do
    before { event.user_id = nil }
    it { should_not be_valid }
  end

  describe "without a start_at" do
    before { event.start_at = nil }
    it { should_not be_valid }
  end

  describe "without an end_at" do
    before { event.end_at = nil }
    it { should_not be_valid }
  end

  describe "with wrong time order" do
    let(:bad_event) { user.events.build(title: "Bad Title",
                                        start_at: "2012-12-31 18:45:00",
                                        end_at: "2012-12-20 09:30:00") }
    it "should not create a new event" do
      expect do
        bad_event.save
      end.should_not change(Event, :count)
    end
  end

  describe "accessible attributes" do

    it "should not allow access to user_id" do
      expect do
        Task.new(title: "blah", user_id: 1)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    describe "when assigning a task" do
      before { event.task = nil }

      it "should not raise an error" do
        expect do
          event.task = task
          event.save
        end.should_not raise_error
      end
    end

    describe "when assigned a task from the wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user) }
      let(:wrong_event) { FactoryGirl.create(:event, user: user) }

      it "should raise an error" do
        expect do
          wrong_event.task = task
          wrong_event.save
        end.should raise_error()
      end
    end
  end
end
