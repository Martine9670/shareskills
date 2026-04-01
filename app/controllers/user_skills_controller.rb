class UserSkillsController < ApplicationController
  before_action :require_login

  def create
    @user_skill = UserSkill.new(
      user:       current_user,
      skill_id:   params[:user_skill][:skill_id],
      level:      params[:user_skill][:level],
      skill_type: params[:user_skill][:skill_type]
    )

    if @user_skill.save
      flash[:notice] = "Compétence ajoutée ✓"
    else
      flash[:alert] = @user_skill.errors.full_messages.join(", ")
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @user_skill = current_user.user_skills.find(params[:id])
    @user_skill.destroy
    flash[:notice] = "Compétence retirée."
    redirect_back(fallback_location: root_path)
  end
end
