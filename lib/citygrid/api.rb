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
api_require "ad_center/account"
api_require "ad_center/ad_group"
api_require "ad_center/ad_group_ad"
api_require "ad_center/ad_group_criterion"
api_require "ad_center/ad_group_geo"
api_require "ad_center/authentication"
api_require "ad_center/budget"
api_require "ad_center/campaign"
api_require "ad_center/category"
api_require "ad_center/method_of_payment"
api_require "ad_center/reports"