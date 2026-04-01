class HomeController < ApplicationController
  def landing
    redirect_to dashboard_path if logged_in?
  end

  def dashboard
    require_login

    @search   = params[:search].to_s.strip
    @category = params[:category].to_s.presence

    @users = User.where.not(id: current_user.id)
                 .includes(user_skills: :skill)

    if @search.present?
      @users = @users.joins(user_skills: :skill)
                     .where("skills.name LIKE ? OR users.name LIKE ?",
                            "%#{@search}%", "%#{@search}%")
                     .distinct
    end

    if @category.present?
      @users = @users.joins(user_skills: :skill)
                     .where(skills: { category: @category })
                     .distinct
    end

    @recent_swaps  = current_user.all_swaps.limit(5)
    @pending_swaps = current_user.received_swaps.pending
  end
end
