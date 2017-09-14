class KpisController < ApplicationController
  before_action :admin_required

  def index
    @individuals_count = Individual.where("email is not null and email != ''").group_by_month.count.sort_by{|k,v| k}
    @opinions_count = Agreement.where("reason is not null and reason != ''").group_by_month.count.sort_by{|k,v| k}
  end
end
