class String
  def to_regexp
    Regexp.new Regexp.escape(self), Regexp::IGNORECASE
  end
end
