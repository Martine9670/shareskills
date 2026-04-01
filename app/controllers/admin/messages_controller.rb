module Admin
  class MessagesController < BaseController
    def new
      @users = User.order(:name)
      @preselected_user_id = params[:user_id]
    end

    def create
      type = params[:message_type]

      if type == "contact"
        user = User.find(params[:user_id])
        AdminMailer.contact_user(user, params[:subject], params[:message]).deliver_now
        flash[:notice] = "Message envoyé à #{user.name}."

      elsif type == "introduce"
        user1 = User.find(params[:user1_id])
        user2 = User.find(params[:user2_id])
        if user1 == user2
          flash[:alert] = "Veuillez sélectionner deux utilisateurs différents."
          redirect_to new_admin_message_path and return
        end
        AdminMailer.introduce_users(user1, user2, params[:message]).deliver_now
        flash[:notice] = "#{user1.name} et #{user2.name} ont été mis en relation."
      end

      redirect_to admin_users_path
    end
  end
end
