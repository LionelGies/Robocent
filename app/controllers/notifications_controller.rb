class NotificationsController < ApplicationController
  def adaptive_ipn
    puts params.inspect
    render :text => "SUCCESS", :status => :ok
  end
end