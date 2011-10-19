# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "citygrid_api"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Elpizo Choi"]
  s.date = "2011-10-19"
  s.description = "Ruby wrapper for CityGrid APIs"
  s.email = "fu7iin@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "citygrid_api.gemspec",
    "citygrid_api.yml.sample",
    "lib/citygrid.rb",
    "lib/citygrid/abstraction.rb",
    "lib/citygrid/abstraction/collection.rb",
    "lib/citygrid/abstraction/item.rb",
    "lib/citygrid/abstraction/requestable.rb",
    "lib/citygrid/abstraction/super_array.rb",
    "lib/citygrid/abstraction/super_hash.rb",
    "lib/citygrid/api.rb",
    "lib/citygrid/api/ad_center.rb",
    "lib/citygrid/api/ad_center/account.rb",
    "lib/citygrid/api/ad_center/ad_group.rb",
    "lib/citygrid/api/ad_center/ad_group_ad.rb",
    "lib/citygrid/api/ad_center/ad_group_criterion.rb",
    "lib/citygrid/api/ad_center/ad_group_geo.rb",
    "lib/citygrid/api/ad_center/authentication.rb",
    "lib/citygrid/api/ad_center/budget.rb",
    "lib/citygrid/api/ad_center/campaign.rb",
    "lib/citygrid/api/ad_center/category.rb",
    "lib/citygrid/api/ad_center/geolocation.rb",
    "lib/citygrid/api/ad_center/image.rb",
    "lib/citygrid/api/ad_center/method_of_payment.rb",
    "lib/citygrid/api/ad_center/places.rb",
    "lib/citygrid/api/ad_center/reports.rb",
    "lib/citygrid/api/ad_center/user.rb",
    "lib/citygrid/api/content.rb",
    "lib/citygrid/api/content/offers.rb",
    "lib/citygrid/api/content/places.rb",
    "lib/citygrid/api/content/places/detail.rb",
    "lib/citygrid/api/content/places/search.rb",
    "lib/citygrid/api/content/reviews.rb",
    "lib/citygrid/api/response.rb",
    "lib/citygrid/details.rb",
    "lib/citygrid/listing.rb",
    "lib/citygrid/offers.rb",
    "lib/citygrid/reviews.rb",
    "lib/citygrid/search.rb",
    "lib/citygrid_api.rb",
    "lib/request_ext.rb",
    "test/api/ad_center/test_account.rb",
    "test/api/ad_center/test_ad_group.rb",
    "test/api/ad_center/test_ad_group_ad.rb",
    "test/api/ad_center/test_ad_group_criterion.rb",
    "test/api/ad_center/test_ad_group_geo.rb",
    "test/api/ad_center/test_authentication.rb",
    "test/api/ad_center/test_budget.rb",
    "test/api/ad_center/test_campaign.rb",
    "test/api/ad_center/test_category.rb",
    "test/api/ad_center/test_geolocation.rb",
    "test/api/ad_center/test_method_of_payment.rb",
    "test/api/ad_center/test_places.rb",
    "test/api/ad_center/test_reports.rb",
    "test/api/content/test_places.rb",
    "test/helper.rb",
    "test/publisher_helper.rb.sample",
    "test/test_config.rb",
    "test/test_details.rb",
    "test/test_listing.rb",
    "test/test_search.rb",
    "test/test_super_array.rb",
    "test/test_super_hash.rb"
  ]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby wrapper for CityGrid APIs"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["~> 0.7.8"])
      s.add_runtime_dependency(%q<json>, ["= 1.5.3"])
      s.add_development_dependency(%q<awesome_print>, ["~> 0.4.0"])
      s.add_development_dependency(%q<riot>, ["~> 0.12.4"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, ["~> 0.7.8"])
      s.add_dependency(%q<json>, ["= 1.5.3"])
      s.add_dependency(%q<awesome_print>, ["~> 0.4.0"])
      s.add_dependency(%q<riot>, ["~> 0.12.4"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, ["~> 0.7.8"])
    s.add_dependency(%q<json>, ["= 1.5.3"])
    s.add_dependency(%q<awesome_print>, ["~> 0.4.0"])
    s.add_dependency(%q<riot>, ["~> 0.12.4"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

