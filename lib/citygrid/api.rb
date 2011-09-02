def api_require path
  require "citygrid/api/#{path}"
end

api_require "base"
api_require "response"

# Content APIs
api_require "content/offers"
api_require "content/places/detail"
api_require "content/places/search"
api_require "content/reviews"

# AdCenter APIs
api_require "ad_center/authentication"
api_require "ad_center/campaign"