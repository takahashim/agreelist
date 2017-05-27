module StatementsHelper
  def shorten_if_too_long(string)
    max = 85
    string.size > max ? "#{string[0..(max - 1)]}..." : string
  end
end
