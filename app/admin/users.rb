ActiveAdmin.register User do
  config.per_page = 50
  
  filter :organization_name
  filter :organization_type
  filter :name
  filter :phone
  filter :email
  filter :activation_state
  filter :time_zone, :as => :select, :collection => UsState::TIME_ZONES

  index do
    selectable_column
    column :id
    column :organization_name
    column :organization_type
    column :name
    column :phone
    column :email
    column :activation_state
    column :time_zone
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :organization_name
      f.input :organization_type
      f.input :name
      f.input :phone
      f.input :email
      f.input :time_zone, :as => :select, :collection => UsState::TIME_ZONES
    end
    f.buttons
  end

  show do |user|
    attributes_table do
      row :organization_name
      row :organization_type
      row :name
      row :phone
      row :email
      row :time_zone
      row :activation_state
      row :activation_token
      row :last_login_at
      row :last_logout_at
      row :last_activity_at
      row :created_at
      row :updated_at
      row "Manage" do |user|
        link_to 'Cancel Account', cancel_admin_user_path(user), :confirm => "It will delete all the associated data with this user! Are you sure to cancel this account?"
      end
    end
    active_admin_comments
  end

  member_action :cancel do
    @user = User.find(params[:id])
    if @user.present?
      flash[:notice] = "User account id : #{params[:id]} cancellation is in queue!"
      @user.delay.destroy
      redirect_to :action => :index
    else
      flash[:notice] = "User was not found by id : #{params[:id]}"
      redirect_to :action => :index
    end
  end
end
