class ContactsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource

  layout 'dashboard'

  # GET /contacts
  # GET /contacts.json
  def index
    session.delete(:list_contacts) if session[:list_contacts].present?
    @contacts = current_user.contacts.all
    @lists = current_user.lists.order("created_at desc")
    @user = current_user
    @dnc_list = @user.dnc.map{|dnc| dnc.phone}

    if params[:search].present?
      key = params[:search]
      @search_contacts = current_user.contacts.by_phone_number(key)
      key = params[:search].split(/\W/).join("")
      @search_contacts = current_user.contacts.by_phone_number(key) if @search_contacts.empty?
      key = formatted_number(params[:search])
      @search_contacts = current_user.contacts.by_phone_number(key) if @search_contacts.empty?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    render :layout => false
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = current_user.contacts.new(params[:contact])
    @contact.source = "Manual Input"
    respond_to do |format|
      if @contact.save
        format.html { redirect_to new_contact_path, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to contacts_path, notice: 'Contact was successfully updated.' }
        format.js
      else
        format.html { redirect_to contacts_path }
        format.js
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.js
    end
  end
end
