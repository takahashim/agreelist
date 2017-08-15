class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?, :admin?, :can_delete_statements?, :has_admin_category_rights?, :main_statement, :has_profession_rights?, :has_update_individual_rights?, :board?, :back_url
  private

  def current_user
    @current_user ||= Individual.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  def admin?
    %w(arpahector emilie_esposito).include?(current_user.try(:twitter).try(:downcase))
  end

  def can_delete_statements?
    current_user.try(:twitter).try(:downcase) == "arpahector"
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
    unless signed_in?
      session[:back_url] = request.url
      flash[:notice] = "Login required for this page"
      redirect_to login_path
    end
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

  def board?
    @statement == main_statement
  end

  def back_url_with_no_parameters
    request.referer.gsub(/\?.*/,'')
  end

  def back_url
    session[:back_url]
  end

  def get_and_delete_back_url
    url = back_url
    if url
      session[:back_url] = nil
      url
    end
  end

  def set_back_url_to_current_page
    session[:back_url] = request.url
  end
end
