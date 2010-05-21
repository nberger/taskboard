class OrganizationsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, :only => [ :new, :create, :add_user ]
  before_filter :require_organization_admin, :only => [:show, :edit, :update, :destroy ]
  before_filter :find_organization, :only => [:edit, :update, :destroy, :add_user ]
  layout "application", :only => [ :index ]
  
  # GET /organizations
  def index
    @organizations = (current_user.admin?) ? Organization.all : current_user.organizations
  end

  # GET /organizations/1
  def show
    @organization = Organization.find(params[:id])
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    render :action => :new
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      render :json => @organization, :status => :created
    else
      render :json => @organization.errors, :status => :precondition_failed
    end
  end
  
  # GET /organizations/1/edit
  def edit 
    render :action => :edit
  end

  # PUT /organizations/1
  def update
    if @organization.update_attributes(params[:organization])
      render :json => @organization, :status => :ok
    else
      render :json => @organization.errors, :status => :precondition_failed
    end
  end
  
  # DELETE /organizations/1
  def destroy
    if @organization.destroy
      render :json => '', :status => :ok
    end
  end
  
  def add_user
    @user = User.find(params[:user_id])
    @organization.users << @user
    render :json => { :id => @user.to_param, :organization => @organization.to_param}, :status => :ok
  end
  
  def find_organization
    @organization = Organization.find(params[:id])
  end
  # def invite
  #   render :partial => 'invitation_form', :locals => {:errors => []}, :status => :ok
  # end
  # 
  # def send_invitation
  #   @errors = []
  # 
  #   @invite_info = {}
  #   [:name, :email, :organization].each { |key| @invite_info[key] = (params[key]) ? params[key].to_s.strip : '' }
  # 
  #   @errors << 'Please fill in all missing fields' if @invite_info.has_value?('')
  #   @errors << "Organization already exists" if Organization.find_by_name(@invite_info[:organization])
  #   @errors << "Member with that mail already exists" if Member.find_by_email(@invite_info[:email])
  # 
  #   # create organization
  #   @organization = Organization.new(:name => @invite_info[:organization])
  #   @organization.save if @errors.empty?
  #   
  #   # create member
  #   candidate_to_username = @invite_info[:name].downcase.gsub(/ /, '.')
  #   matching_username = Member.first(:select => 'username', :conditions => [ "username LIKE ?", "#{candidate_to_username}%" ], :order => 'username DESC')
  #   matching_username = matching_username ? matching_username.username : 0
  #   candidate_to_username = candidate_to_username + (matching_username.gsub(/\D/, '').to_i + 1).to_s if matching_username != 0
  #   @member = Member.new(:name => @invite_info[:name], :new_organization => @organization.id, :added_by => current_user.name, :color => 'ff0000', :username => candidate_to_username, :email => @invite_info[:email])
  #   
  #   if @errors.empty? && @member.save
  #     render :inline => "<script>location.reload(true)</script>", :status => :ok
  #   else
  #     @organization.destroy
  #     render :partial => 'invitation_form',
  #         :locals => { :no_refresh => true, :edit => false, :member => @member, :errors => @errors, :invite_info => @invite_info },
  #             :status => :internal_server_error
  #   end
  # end
end
