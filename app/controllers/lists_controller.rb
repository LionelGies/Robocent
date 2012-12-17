class ListsController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
    render :layout => false
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = current_user.lists.new(params[:list])

    respond_to do |format|
      if @list.save
        format.html { redirect_to contacts_path }
        format.js
      else
        format.html { redirect_to contacts_path }
        format.js
      end
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
        format.html { redirect_to contacts_path }
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
end
