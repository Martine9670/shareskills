class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Vous devez être connecté pour accéder à cette page."
      redirect_to login_path
    end
  end

  def require_admin
    unless logged_in? && current_user.is_admin?
      flash[:alert] = "Accès réservé aux administrateurs."
      redirect_to dashboard_path
    end
  end
end
