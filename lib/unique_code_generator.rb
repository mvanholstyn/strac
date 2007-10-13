class UniqueCodeGenerator
  def self.generate base, time=Time.now
    Digest::SHA1.hexdigest( "#{base}#{time.utc.to_s.split(//).sort_by {rand}.join}" )
  end
end