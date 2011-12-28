# monkey patch camel-casing

class String
  def camelcase
    self.gsub(/(_(.))/) { $2.upcase}.gsub(/^(.)/) { $1.upcase }
  end
end