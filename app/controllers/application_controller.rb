class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?, :admin?, :has_admin_category_rights?, :main_statement, :has_profession_rights?, :has_update_individual_rights?
  private

  def current_user
    @current_user ||= Individual.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  def admin?
    %w(arpahector emilieesposito).include?(current_user.try(:twitter).downcase)
  end

  def has_admin_category_rights?
    %w(emilie_esposito arpahector ryryanryanry).include?(current_user.try(:twitter).try(:downcase))
  end

  def has_profession_rights?
    has_admin_category_rights?
  end

  def has_update_individual_rights? # required for professions because it calls individuals controller #update
    has_admin_category_rights?
  end

  def login_required
    redirect_to "/", notice: "login required" unless signed_in?
  end

  def admin_required
    redirect_to "/", notice: "admin required" unless admin?
  end

  def category_admin_required
    redirect_to "/", notice: "admin required" unless has_admin_category_rights?
  end

  def profession_rights_required
    redirect_to "/", notice: "admin required" unless has_profession_rights?
  end

  def main_statement
    Rails.env.test? ? Statement.first : Statement.find(7)
  end
end
