ActiveAdmin.register User do
  filter :name

  index do
    selectable_column
    column :organization_name
    column :organization_type
    column :name
    column :phone
    column :email
    column :address
    column :state
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
      f.input :address
      f.input :state, :as => :select, :collection => UsState::NAMES
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
      row :address
      row :state
      row :time_zone
      row :activation_state
      row :activation_token
      row :last_login_at
      row :last_logout_at
      row :last_activity_at
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
