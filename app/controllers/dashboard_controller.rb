class DashboardController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  def index
    @total_contacts_count = current_user.lists.sum_number_of_contacts.first.total.to_i
    @call_contacts_count = current_user.lists.sum_number_of_contacts.by_call.first.total.to_i
    @text_contacts_count = current_user.lists.sum_number_of_contacts.by_text.first.total.to_i
    @price_per_call_or_text = current_user.subscription.plan.price_per_call_or_text

    @total_text_or_call_can_send = ((current_user.current_balance * 100.0) / @price_per_call_or_text).to_i

    @text_messages = current_user.text_messages
    @calls = current_user.calls
  end

  def profile
    @user = current_user
  end

  def welcome_pop_up_submit
    if params[:list].present?
      @list = current_user.lists.new(params[:list])
      @list.type_of_list = "text"
      @list_create = true if @list.save
    end

    if current_user.subscription.plan.recurring and params[:twilio_phone_number].present?
      @tpn = current_user.build_twilio_phone_number(params[:twilio_phone_number])
      @number_create = true if @tpn.save
    end

    notice = (@list_create.present? or @number_create.present?) ? "Successfully Saved Settings!" : ""
    redirect_to dashboard_path, :notice => notice
  end
  
end
