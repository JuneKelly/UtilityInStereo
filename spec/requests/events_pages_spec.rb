require 'spec_helper'

describe "EventsPages" do
  let(:user)        { FactoryGirl.create(:user) }
  let(:client)      { FactoryGirl.create(:client, user: user, name: "Pillhead")}
  let(:project_one) { FactoryGirl.create(:project, client: client) }
  let(:phase_one)   { project_one.phases.build(title: "der", is_done: false) }
  let(:task_one)    { FactoryGirl.create(:task, phase: phase_one) }
  let(:event_one)   do
    FactoryGirl.create(:event, user: user, task: nil,
                              start_at: "2014-10-07 11:45:00",
                              end_at:   "2014-10-09 18:00:00")
  end
  let(:event_two)   do
    FactoryGirl.create(:event, user: user, task: task_one,
                              start_at: "2014-05-01 10:00:00",
                              end_at:   "2014-05-01 17:00:00")
  end

  before do
    user.save
    client.save
    project_one.save
    phase_one.save
    task_one.save
    event_one.save
    event_two.save
    valid_login(user)
  end
  
  subject { page }

  describe "hours on project page" do
    before { visit project_path(task_one.project) }
    it { should have_content "7 hours" }
  end

  describe "event show" do
    before { visit event_path(event_one) }

    it { should have_selector('h1', text: "Event:") }
    it { should have_content(event_one.title) }
    it { should have_content(event_one.details) }
    it { should have_content("Back to Calendar") }
  end

  describe "agenda view" do
    before { visit agenda_path }

    it { should have_selector('h1', text: 'Agenda') }
    it { should have_selector('h2', text: 'Soon') }
    it { should have_selector('h2', text: 'Later') }
    it { should have_selector('h3', text: event_one.title) }
    it { should have_content(event_two.title) }

    it { should have_content(event_one.start_at.strftime("%H:%M")) }
    it { should have_content(event_one.end_at.strftime("%H:%M")) }
    it { should have_content(event_two.start_at.strftime("%H:%M")) }
    it { should have_content(event_two.end_at.strftime("%H:%M")) }

    describe "with an associated task" do
      it { should have_content(event_two.task.title) }
      it { should have_content(event_two.task.phase.title) }
      it { should have_content(event_two.task.phase.project.title) }
      it { should have_content(event_two.task.phase.project.client.name) }
    end
  end

  describe "week view" do
    # Todo
  end

  describe "month view" do
    # Todo
  end

  describe "creation" do
    before { visit new_event_path }

    it { should have_selector('h1', text: 'New Event') }
    it { should have_selector('label', text: 'Title') }
    it { should have_selector('label', text: 'Details') }
    it { should have_selector('label', text: 'Start date') }
    it { should have_selector('label', text: 'Start time') }
    it { should have_selector('label', text: 'End date') }
    it { should have_selector('label', text: 'End time') }
    it { should have_button('Create') }
    it { should have_link('Cancel') }

    describe "with valid information" do
      before do
        fill_in 'Title', with: 'New Event Title'
        fill_in 'Details', with: 'Lorem Ipsum'
        fill_in 'Start date', with: '12/20/2014'
        fill_in 'End date', with: '12/21/2014'
      end

      it "should create an event" do
        expect { click_button 'Create' }.to change(Event, :count).by(1)
      end

      describe "redirect" do
        before { click_button 'Create' }
        it { should have_selector('h1', text: 'Calendar') }
        it { should have_content("New Event Title") }
      end
    end

    describe "with invalid information" do

      it "should not create and event" do
        expect do
          click_button 'Create'
        end.not_to change(Event, :count)
      end

      describe "error messages" do
        before { click_button 'Create' }
        it { should have_content('error') }
      end
    end
  end

  describe "creation through task" do
    before do
      visit phase_path(phase_one)
    end

    it { should have_link 'Make Event' }

    describe "click Make Event link" do
      before { click_link 'Make Event' }

      it do
        should have_selector('h1', 
                text: "New Event for Task: #{task_one.title}")
      end
      it { should have_selector('label', text: 'Title') }
      it { should have_selector('label', text: 'Details') }
      it { should have_selector('label', text: 'Start date') }
      it { should have_selector('label', text: 'Start time') }
      it { should have_selector('label', text: 'End date') }
      it { should have_selector('label', text: 'End time') }
      it { should have_button('Create') }
      it { should have_link('Cancel') }

      describe "with valid information" do
        before do
          fill_in 'Title', with: 'New Event Title'
          fill_in 'Details', with: 'Lorem Ipsum'
          fill_in 'Start date', with: '12/20/2014'
          fill_in 'End date', with: '12/21/2014'
        end

        it "should create an event" do
          expect { click_button 'Create' }.to change(Event, :count).by(1)
        end

        describe "redirect" do
          before { click_button 'Create' }
          it { should have_selector('h1', text: phase_one.title ) } 
          # it { should have_content(task_one.title) }
        end
      end
    end
  end

  describe "edit" do
    before { visit edit_event_path(event_one) }

    it { should have_selector('h1', text: "Edit Event: #{event_one.title}") }
    it { should have_selector('label', text: 'Title') }
    it { should have_selector('label', text: 'Details') }
    
    it { should have_selector('label', text: 'Start date') }
    # it { should have_content("10/07/2012") }
    it { should have_selector('label', text: 'Start time') }

    it { should have_selector('label', text: 'End date') }
    # it { should have_content("10/09/2012") }
    it { should have_selector('label', text: 'End time') }
    it { should have_button 'Save' }
    it { should have_link 'Delete Event' }
    it { should have_link 'Cancel' }

    describe "with valid information" do
      before do
        fill_in 'Title', with: 'New Valid Event Title'
        fill_in 'Details', with: 'Lorem Ipsum'
      end

      describe "redirect" do
        before { click_button 'Save' }
        it { should have_content('New Valid Event Title') }
        it { should have_content('Calendar') }
      end
    end

    describe "with invalid information" do
      before { fill_in 'Title', with: '' }

      describe "error messages" do
        before { click_button 'Save' }
        it { should have_content('error') }
      end
    end
  end

  describe "destroy" do
    before { visit edit_event_path(event_one) }

    it "should remove the event" do
      expect { click_link 'Delete Event' }.to change(Event, :count).by(-1)
    end

  end
end
