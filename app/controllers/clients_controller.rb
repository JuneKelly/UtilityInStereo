class ClientsController < ApplicationController
  before_filter :logged_in_user, 
                only: [:new, :index, :show, :edit, :create, :update, :destroy]
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]

  # check account is active
  before_filter except: [] do |c| 
    c.check_is_active(current_user)
  end


  def index
    @clients = current_user.clients.order("created_at ASC")
  end

  def new
    check_limit
    @client = current_user.clients.build
  end

  def create
    check_limit
    @client = current_user.clients.build(params[:client])
    respond_to do |format|
      if @client.save
        flash[:success] = "Created client #{@client.name} :)"
        format.html { redirect_to client_path(@client) }
      else
        flash[:notice] = "error , form is invalid"
        format.html { redirect_to new_client_path }
      end
      format.js
    end
  end

  def edit
    @contacts = @client.contacts
  end

  def update
    if @client.update_attributes(params[:client])
      flash[:success] = "Client updated"
      redirect_to client_path(@client)
    else
      render 'edit'
    end
  end

  def show
    @client = current_user.clients.find_by_id(params[:id])
    @contacts = @client.contacts.order("created_at ASC")
    @projects = @client.projects.order("created_at DESC")
  end

  def destroy
    @client.destroy
    flash[:success] = "Client #{@client.name} deleted"
    redirect_to clients_path
  end

  private
    def correct_user
      @client = Client.find_by_id(params[:id])
      @user = @client.user
      if @user != current_user
        redirect_to(root_path, notice: "Error: wrong user")
      end
    end

    def check_limit
      if current_user.clients.count >= current_user.client_limit
        redirect_to clients_path, 
          notice: "Sorry, you have reached the limit for Clients on this account, consider upgrading to a standard account"
      end
    end
end
