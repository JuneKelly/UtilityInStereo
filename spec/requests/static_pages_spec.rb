require 'spec_helper'

describe "StaticPages" do
  
  subject { page }


  describe "front page" do
    before { visit root_path }

    it { should have_selector('#logo', text: "Utility In Stereo") }
    it { should have_link('Visit Us On Facebook') }
  end


  describe "contact page" do
    before { visit contact_us_path }

    it { should have_selector('h1', text: "Contact Us") }
    it { should have_content('shane@utilityinstereo.com')}
  end

  describe "user guide page" do
    before { visit user_guide_path }

    it { should have_selector('h1', text: 'User Guide') }
    it { should have_selector('h2', text: 'Getting Started') }
    it { should have_selector('h2', text: 'Clients') }
    it { should have_selector('h2', text: 'Projects') }
    it { should have_selector('h2', text: 'Adding Phases and Tasks') }
    it { should have_selector('h2', text: 'Working With Events') }
    it { should have_selector('h2', text: 'Using Your Public Pages') }
  end

  describe "plans" do
    before { visit plans_path }
    it { should have_selector('h1', text: 'Subscription Plans') }
  end

end
