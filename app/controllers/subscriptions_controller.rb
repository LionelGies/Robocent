class SubscriptionsController < ApplicationController

  layout "dashboard"
  
  def migration
    @plans = Plan.order("amount asc")
    @current_plan = current_user.subscription.plan
    @subscription = current_user.subscription
  end

  def migrate
    begin
      if params[:subscription].present? and params[:subscription][:plan_id].present?
        @new_plan = Plan.find(params[:subscription][:plan_id])
        @total_contacts = current_user.lists.sum_number_of_contacts.first.total.to_i
        if @new_plan.maximum_numbers >= @total_contacts
          @subscription = current_user.subscription
          @subscription.migrate(@new_plan)
          redirect_to migration_path, :notice => "Successfully Migrated Your Account"
        else
          message = "Your total contacts #{@total_contacts}, Please delete some contacts to downgrade!"
        end
      else
        message = "You must select one plan to migrate!"
      end
    rescue => e
      logger.info e
      message = "Something went wrong! Please contact with customer care."
    end
    redirect_to migration_path, :alert => message if message.present?
  end
end