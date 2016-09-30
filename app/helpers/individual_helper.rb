module IndividualHelper
  def percentage(statement)
    (statement.supporters_count * 100.0 / statement.agreements.size).round
  end
end
