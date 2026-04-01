class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def new
    redirect_to dashboard_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      SwapMailer.welcome(@user).deliver_later
      flash[:notice] = "Bienvenue sur ShareSkills, #{@user.name} ! 🎉"
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @teach_skills = @user.teach_skills.includes(:skill)
    @learn_skills  = @user.learn_skills.includes(:skill)
    @swaps         = @user.all_swaps.limit(10)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    params_to_apply = user_params
    if params_to_apply[:password].blank?
      params_to_apply = params_to_apply.except(:password, :password_confirmation)
    end
    if @user.update(params_to_apply)
      flash[:notice] = "Profil mis à jour."
      redirect_to dashboard_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                  :location, :bio, :avatar_image)
  end
end
