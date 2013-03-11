class ListsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource

  layout 'dashboard'

  def show
    session[:list_contacts] = true
    @list = List.find(params[:id])
    @contacts = @list.contacts
    @user = current_user
    @dnc_list = @user.dnc.map{|dnc| dnc.phone}
  end

  def new
    session[:referer] = request.referer
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = current_user.lists.new(params[:list])

    respond_to do |format|
      if @list.save
        format.html { redirect_to session[:referer].present? ? session[:referer] : contacts_path }
        format.js
      else
        format.html { render :action => :new }
        format.js
      end
    end
  end

  def check_validation
    @error = {}
    if params[:list_id].present?
      @list = List.find(params[:list_id])
      list = List.find(:first, :conditions => ["lists.id <> ? and lists.user_id = ? and lists.name = ? and lists.type_of_list = ?", @list.id, current_user.id, params[:list][:name], @list.type_of_list])
      @error[:name] = "You have already used this list name for list type #{@list.type_of_list} !" if list.present?
      list1 = List.find(:first, :conditions => ["lists.id <> ? and lists.user_id = ? and lists.keyword = ?", @list.id, current_user.id, params[:list][:keyword]]) if params[:list][:keyword].present?
      @error[:keyword] = "You have already used this keyword!" if list1.present?
      list2 = List.find(:first, :conditions => ["lists.id <> ? and lists.shortcode_keyword = ?", @list.id, params[:list][:shortcode_keyword]]) if params[:list][:shortcode_keyword].present?
      @error[:shortcode_keyword]= "This keyword is not available!" if list2.present?
    else
      @list = current_user.lists.new(params[:list])
      list = List.find_by_user_id_and_name_and_type_of_list(current_user.id, @list.name, @list.type_of_list)
      @error[:name] = "You have already used this list name for list type #{@list.type_of_list} !" if list.present?
      list1 = List.find_by_user_id_and_keyword(current_user.id, @list.keyword) if @list.keyword.present?
      @error[:keyword] = "You have already used this keyword!" if list1.present?
      list2 = List.find_by_shortcode_keyword(@list.shortcode_keyword) if @list.shortcode_keyword.present?
      @error[:shortcode_keyword]= "This keyword is not available!" if list2.present?
    end
  end

  # PUT /lists/1
  # PUT /lists/1.json
  def update
    @list = List.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to contacts_path, notice: 'List was successfully updated.' }
        format.js
      else
        format.html { render :action => :edit }
        format.js
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list = List.find(params[:id])
    @list.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.js
    end
  end

  def export_contacts
    @contacts = Contact.where(:list_id => params[:id]).includes(:list)
    respond_to do |format|
      format.csv { send_data @contacts.to_csv }
    end
  end
end
