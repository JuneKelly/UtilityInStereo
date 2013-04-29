require 'spec_helper'

describe "PhaseOrders" do
  let(:user)        { FactoryGirl.create(:user) }
  let(:wrong_user)  { FactoryGirl.create(:user) }
  let(:client)      { FactoryGirl.create(:client, user: user, name: "Pillhead") }

  let(:project) { FactoryGirl.create(:project, client: client) }

  before do
    user.save
    wrong_user.save
    client.save
    project.save
    # phase_one.save
    # phase_two.save
    valid_login(user)
  end

  context "ordering on creation" do
    describe "first three phase" do
      before do 
        @phase_one = project.phases.create(title: "Phase One") 
        @phase_two = project.phases.create(title: "Phase Two")
        @phase_three = project.phases.create(title: "Phase Three")
      end
      
      it "phase one should be in order" do
        @phase_one.order_index.should == 0 
        @phase_one.should be_unique_order_index 
      end

      it "phase two should be in order" do
        @phase_two.order_index.should == 1 
        @phase_two.should be_unique_order_index 
      end

      it "phase three should be in order" do
        @phase_three.order_index.should == 2 
        @phase_three.should be_unique_order_index
      end
    end
  end

  context "ordering moving forward" do
    before do
      @project_mf = FactoryGirl.create(:project, client: client)
      @phase_mf_one = @project_mf.phases.create(title: "Phase One") 
      @phase_mf_two = @project_mf.phases.create(title: "Phase Two")
      @phase_mf_three = @project_mf.phases.create(title: "Phase Three")
      @phase_mf_four = @project_mf.phases.create(title: "Phase Four")
    end

    describe "move phase two forward" do

    end

  end

  context "ordering moving back" do

  end

  context "ordering with deletion" do
    before do
      @project_d = FactoryGirl.create(:project, client: client)
      @phase_d_one = @project_d.phases.create(title: "Phase One") 
      @phase_d_two = @project_d.phases.create(title: "Phase Two")
      @phase_d_three = @project_d.phases.create(title: "Phase Three")
      @phase_d_four = @project_d.phases.create(title: "Phase Four")
    end

    describe "when deleting phase two" do
      before do
        visit edit_phase_path(@phase_d_two)
        click_link 'Delete'
      end

      it "phase one should be in order" do
        @phase_d_one.order_index.should == 0 
        @phase_d_one.should be_unique_order_index 
      end

      it "phase three should be in order" do
        @phase_d_three.reload.order_index.should == 1 
        @phase_d_three.should be_unique_order_index 
      end

      it "phase four should be in order" do
        @phase_d_four.reload.order_index.should == 2 
        @phase_d_four.should be_unique_order_index
      end
    end
  end
end
