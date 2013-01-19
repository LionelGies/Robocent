ActiveAdmin.register Import do
  actions :all, :except => [:edit]

  filter :user
  filter :list
  filter :file_name_identifier
  filter :number_of_contacts
  filter :created_at

  index do
    selectable_column
    column :id
    column :user_id
    column :user
    column :list
    column :file_name_identifier
    column :number_of_contacts
    column :hold
    column "Mapping" do |import|
      import.mapping.present? ? "Yes" : "No"
    end
    column :created_at
    column "Manage" do |import|
      link_to 'Approve', approve_admin_import_path(import), :confirm => "Are you sure to approve?"
    end
    default_actions
  end

  controller do
    def scoped_collection
      Import.where("hold = ?", true)
    end
  end

  show do
    attributes_table do
      row :user
      row :list
      row :file_name_identifier
      row :number_of_contacts
      row :hold
      row :uploaded
      row "Subscribed Plan" do |import|
        import.user.subscription.plan.name
      end
      row "Allowed Contacts" do |import|
        import.user.subscription.plan.maximum_numbers
      end
      row "Total Uploaded Contacts" do |import|
        import.user.lists.sum_number_of_contacts.first.total.to_i
      end
      row "Remaining Contacts" do |import|
        import.user.subscription.plan.maximum_numbers.to_i - import.user.lists.sum_number_of_contacts.first.total.to_i
      end
      row "Manage" do |import|
        link_to 'Approve', approve_admin_import_path(import), :confirm => "Are you sure to approve?"
      end
    end
    active_admin_comments
  end

  member_action :approve do
    @import = Import.find(params[:id])
    if @import.mapping.present?
      Delayed::Job.enqueue Jobs::ImportJob.new(@import), 0 , 2.seconds.from_now, :queue => "import"
      flash[:notice] = "Successfully placed into queue."
      redirect_to :action => :index
    else
      flash[:notice] = "Column Mapping is not present!"
      redirect_to :action => :index
    end
  end
end
