%w{base response content}.each do |api|
  require "citygrid/api/#{api}"
end