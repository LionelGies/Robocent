class TextMessagesController < ApplicationController
  before_filter :require_login

  layout "dashboard"
  
  def new
    if params["step"].present?
      @step = params["step"]
    else
      @step = "1"
    end

    if session[:text_message].present?
      session[:text_message] = session[:text_message].merge(params[:text_message]) if params[:text_message].present?
      @text_message = current_user.text_messages.new(session[:text_message])
    elsif params[:text_message].present?
      @text_message = current_user.text_messages.new(params[:text_message])
      session[:text_message] = params[:text_message]
    else
      @text_message = TextMessage.new
    end

    if params["step"] == "3"
      @text_message.number_of_recipients = @text_message.list.number_of_contacts
      @text_message.cost_per_text = current_user.subscription.plan.price_per_call_or_text / 100.0
      @message_size = (@text_message.content.length.to_f / 140.0).ceil
      @text_message.number_of_texts_required = @message_size * @text_message.number_of_recipients
      @text_message.total_cost = @text_message.number_of_texts_required.to_f * @text_message.cost_per_text
      @current_balance = current_user.account_balance.current_balance
      @charge_difference = ((@text_message.total_cost - @current_balance) * 100).ceil.to_f / 100.0 if @current_balance < @text_message.total_cost
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @text_message = current_user.text_messages.new(session[:text_message])
    @text_message.number_of_recipients = @text_message.list.number_of_contacts
    @text_message.cost_per_text = current_user.subscription.plan.price_per_call_or_text / 100.0
    @message_size = (@text_message.content.length.to_f / 140.0).ceil
    @text_message.number_of_texts_required = @message_size * @text_message.number_of_recipients
    @text_message.total_cost = @text_message.number_of_texts_required.to_f * @text_message.cost_per_text
      
    if @text_message.save
      session.delete(:text_message)
      redirect_to dashboard_path, :notice => "Successfully placed the text messages into queue!"
    else
      redirect_to send_text_path
    end
  end
end
