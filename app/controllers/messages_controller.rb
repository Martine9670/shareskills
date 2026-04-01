class MessagesController < ApplicationController
  before_action :require_login

  def index
    # Conversations : liste des interlocuteurs uniques
    partner_ids = Message.where(sender_id: current_user.id)
                         .or(Message.where(receiver_id: current_user.id))
                         .pluck(:sender_id, :receiver_id)
                         .flatten.uniq - [current_user.id]
    @conversations = User.where(id: partner_ids)
    @unread_count  = Message.unread_for(current_user).count
  end

  def show
    @partner  = User.find(params[:id])
    @messages = Message.conversation_between(current_user, @partner)
    @messages.where(receiver: current_user, read: false).update_all(read: true)
    @new_message = Message.new
  end

  def create
    @receiver = User.find(params[:message][:receiver_id])
    @message  = Message.new(
      sender:      current_user,
      receiver:    @receiver,
      subject:     params[:message][:subject],
      body:        params[:message][:body],
      proposed_at: params[:message][:proposed_at].presence
    )
    if @message.save
      redirect_to message_path(@receiver), notice: "Message envoyé !"
    else
      flash[:alert] = @message.errors.full_messages.join(", ")
      redirect_back fallback_location: message_path(@receiver)
    end
  end
end
