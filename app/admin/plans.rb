ActiveAdmin.register Plan do
  config.filters = false
  
  controller do
    def scoped_collection
      Plan.enabled
    end
  end

  index do
    column :id
    column :name
    column "Subscription Fee/Month", :sortable => false do |plan|
      number_to_currency plan.monthly_fee
    end
    column :price_per_call_or_text
    column "Text or Call included/Month", :monthly_included_text_or_call, :sortable => false
    column "Keywords", :max_keywords
    column "Free Text", :free_text, :sortable => false
    default_actions
  end

  form do |f|
    f.inputs "Plan Details" do
      if f.object.new_record?
        f.input :name
        f.input :stripe_id, :label => "Stripe plan name(should be unique)"
        f.input :max_keywords
        f.input :price_per_call_or_text, :label => "Price pre call or text(in cent)"
        f.input :monthly_fee, :label => "Monthly subscription fee(0.00 for no fee)"
        f.input :monthly_included_text_or_call, :label => "Texts or calls included per month"
        f.input :free_text
        f.input :trial_period_days
        f.input :currency, :as => :hidden, :input_html => { :value => 'usd' }
        f.input :interval, :as => :hidden, :input_html => { :value => 'month' }
      else
        f.input :name 
        f.input :max_keywords
        f.input :price_per_call_or_text
        f.input :monthly_included_text_or_call, :label => "Texts or calls included per month"
        f.input :free_text
        f.input :trial_period_days
      end
    end
    f.buttons
  end
  
  member_action :destroy do
    @plan = Plan.find(params[:id])
    @plan.disabled = true
    @plan.save
    redirect_to :action => :index
  end
  
end
