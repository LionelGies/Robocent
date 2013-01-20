ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    plans_count = Plan.count(:all)
    admins_count = AdminUser.count(:all)
    users_count = User.count(:all)
    contacts_count = Contact.count(:all)
    phone_numbers = TwilioPhoneNumber.all
    recordings_count = Recording.count(:all)
    text = TextMessage.find(:first, :select => "SUM(number_of_texts_required) as total_text, SUM(total_processed) as processed, SUM(succeeded) as total_succeeded")
    if text.present?
      text_sent_count = text.total_text.to_i
      text_processed = text.processed.to_i
      text_succeeded = text.total_succeeded.to_i
    end
    call = Call.find(:first, :select => "SUM(number_of_recipients) as total_call")
    call_sent_count = call.total_call.to_i if call.present?

    receipt = Receipt.find(:first, :select => "SUM(credit) as total_credit, SUM(debit) as total_debit")
    if receipt.present?
      total_credit = receipt.total_credit.to_f
      total_debit = receipt.total_debit.to_f
    end
    balance = AccountBalance.find(:first, :select => "SUM(current_balance) as total_balance")
    current_balance = balance.total_balance.to_f if balance.present?
    plans = Plan.all
    columns do
      column do
        panel "Statistics" do
          table do
            tr
            td "Total Subscription Plans"
            td ": #{plans_count}"
            tr
            td "Total Admins"
            td ": #{admins_count}"
            tr
            td "Total Users"
            td ": #{users_count}"
            tr
            td "Total Contacts"
            td ": #{contacts_count}"
            tr
            td "Total Recordings"
            td ": #{recordings_count}"
            if text_sent_count.present?
              tr
              td "Total Text Send Request"
              td ": #{text_sent_count}"
              tr
              td "Total Text Processed"
              td ": #{text_processed}"
              tr
              td "Total Text Succeeded"
              td ": #{text_succeeded}"
            end
            if call_sent_count.present?
              tr
              td "Total Call Sent"
              td ": #{call_sent_count}"
            end
            if receipt.present?
              tr
              td "Total Credit Amount"
              td ": #{"$%.3f" % total_credit}"
              tr
              td "Total Dedit Amount"
              td ": #{"$%.3f" % total_debit}"
            end
            if current_balance.present?
              tr
              td "Balance"
              td ": #{"$%.3f" % current_balance}"
            end
          end
        end
      end
      column do
        panel "Subscription Plans" do
          table do
            tr
            th "Plan"
            th "Monthly Price"
            th "Cost per text/call"
            th "Total Users"

            plans.each do |p|
              tr
              td p.name
              td "$%.0f" % (p.amount / 100)
              td "$%.3f" % (p.price_per_call_or_text / 100)
              td p.users.count
            end

          end
        end
      end
      column do
        panel "Server Stats" do
          para "Some Charts to show server performance ..."
        end
      end
    end
  end

  # Here is an example of a simple dashboard with columns and panels.
  #
  # columns do
  #   column do
  #     panel "Recent Posts" do
  #       ul do
  #         Post.recent(5).map do |post|
  #           li link_to(post.title, admin_post_path(post))
  #         end
  #       end
  #     end
  #   end

  #   column do
  #     panel "Info" do
  #       para "Welcome to ActiveAdmin."
  #     end
  #   end
  # end
end # content
