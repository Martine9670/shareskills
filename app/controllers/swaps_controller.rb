class SwapsController < ApplicationController
  before_action :require_login

  def create
    @receiver = User.find(params[:receiver_id])
    @skill    = Skill.find(params[:skill_id])
    @swap     = Swap.new(
      proposer: current_user,
      receiver: @receiver,
      skill:    @skill,
      duration: params[:duration].to_i,
      message:  params[:message]
    )

    if @swap.save
      SwapMailer.swap_proposed(@swap).deliver_later
      flash[:notice] = "Proposition de swap envoyée à #{@receiver.name} ! ✓"
    else
      flash[:alert] = "Impossible de proposer ce swap : #{@swap.errors.full_messages.join(', ')}"
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    @swap = Swap.find(params[:id])

    unless @swap.receiver == current_user
      flash[:alert] = "Action non autorisée."
      return redirect_to dashboard_path
    end

    if params[:action_type] == "accept"
      @swap.accept!
      SwapMailer.swap_accepted(@swap).deliver_later
      flash[:notice] = "Swap accepté ! Les crédits ont été transférés. ✓"
    else
      @swap.reject!
      flash[:notice] = "Swap refusé."
    end
    redirect_back(fallback_location: root_path)
  end
end
