module Admin
  class UsersController < BaseController
    def index
      @users = User.includes(user_skills: :skill).order(:name)
    end

    def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(admin_user_params)
        flash[:notice] = "Utilisateur mis à jour."
        redirect_to admin_users_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "Utilisateur supprimé."
      redirect_to admin_users_path
    end

    private

    def admin_user_params
      params.require(:user).permit(:name, :email, :location, :bio,
                                    :credits_minutes, :is_admin)
    end
  end
end
