module StaticPagesHelper
  def link_to_statement(text)
    s = Statement.find_by_content(text)
    s ? link_to(text, statement_path(s)) : ""
  end
end
