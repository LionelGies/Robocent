class DashboardController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  def index
    @total_contacts_count = current_user.lists.sum_number_of_contacts.first.total.to_i
    @call_contacts_count = current_user.lists.sum_number_of_contacts.by_call.first.total.to_i
    @text_contacts_count = current_user.lists.sum_number_of_contacts.by_text.first.total.to_i
    @price_per_call_or_text = current_user.subscription.plan.price_per_call_or_text
    @cost_for_text = (@text_contacts_count.to_f * @price_per_call_or_text) / 100
    @cost_for_call = (@call_contacts_count.to_f * @price_per_call_or_text) / 100

    @text_messages = current_user.text_messages
    @calls = current_user.calls
  end

  def profile
    @user = current_user
  end
  
end
