class EnquiriesController < ApplicationController
  before_filter :logged_in_user, only: [:index, :show, :destroy]
  before_filter :correct_user, only: [:show, :destroy]

  # check account is active
  before_filter except: [:new, :create] do |c| 
    c.check_is_active(current_user)
  end

  def show
    @enquiry.update_attributes(viewed: true)
  end

  def index
    # get enquiries
    @enquiries = current_user.enquiries.order("created_at DESC")
  end

  def new
    @user = User.find_by_long_id(params[:user_id])
    @enquiry = @user.enquiries.build
    if @user == nil || @user.is_active == false
      redirect_to root_path, notice: "No Such User"
    else 
      render 'new'
    end
  end

  def create
    @user = User.find_by_long_id(params[:user_id])
    @enquiry = @user.enquiries.build(params[:enquiry])
    if @user && @user.is_active == true
      if @enquiry.save
        flash[:success] = "Sent Enquiry to #{@user.name}"

        # EnquiryMailer.enquiry_notify(@user, @enquiry).deliver

        redirect_to root_path  
      else
        flash[:notice] = "Something went wrong!"
        redirect_to root_path  
      end
    else
      flash[:notice] = "No such user"
      redirect_to root_path  
    end
  end

  def destroy
    @enquiry.destroy
    flash[:success] = "Enquiry Deleted"
    redirect_to enquiries_path
  end

  private
    def correct_user
      @enquiry = Enquiry.find_by_id(params[:id])
      @user = @enquiry.user
      if @user != current_user
        redirect_to(root_path, notice: "Wrong User!")
      end
    end 
end  
