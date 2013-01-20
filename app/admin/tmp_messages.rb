ActiveAdmin.register TmpMessage do
  menu :label => "Contact Us"
  actions :all, :except => [:edit, :new]

  index do
    selectable_column
    column :name
    column :email
    column :content
    column :created_at
    column :updated_at
    column "Manage" do |tm|
      link_to 'Reply', '#' #reply_admin_tmp_message_path(tm)
    end
    default_actions
  end

  member_action :reply do
    @tm = TmpMessage.find(params[:id])
    render "reply"
  end
end
