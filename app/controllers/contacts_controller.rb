class ContactsController < ApplicationController
  before_filter :logged_in_user, only: [:new, :create, :edit, 
                                        :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  # check account is active
  before_filter except: [] do |c| 
    c.check_is_active(current_user)
  end

  def new
    @client = Client.find_by_id(params[:client_id])
    if @client.user == current_user
      @contact = @client.contacts.build
    else
      redirect_to root_path, notice: 'wrong user'
    end
  end

  def create
    @client = Client.find_by_id(params[:client_id])
    @contact = @client.contacts.build(params[:contact])
    if @client.user == current_user
      if @contact.save
        flash[:success] = "Contact created"
        redirect_to client_path(@client)
      else
        render 'new'
      end
    else
      redirect_to root_path notice: 'wrong user'
    end
  end

  def edit
  end

  def update
    if @contact.update_attributes(params[:contact])
      flash[:success] = "Contact updated"
      redirect_to edit_client_path(@contact.client)
    else
      render 'edit'
    end
  end

  def destroy
    @contact.destroy
    flash[:success] = "Contact #{@contact.name} deleted."
    redirect_to edit_client_path(@contact.client)
  end

  private

    def correct_user
      @contact = Contact.find_by_id(params[:id])
      @user = @contact.user
      if @user != current_user
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end
end
