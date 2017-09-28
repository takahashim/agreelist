module SidekiqWebContraint
  def sidekiq_web_constraint
    lambda do |request|
      current_user = Individual.find(request.session[:user_id]) if request.session[:user_id]
      current_user.present? && current_user.can_access_sidekiq?
    end
  end
end
