# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{citygrid_api}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Elpizo Choi"]
  s.date = %q{2011-07-18}
  s.description = %q{Ruby wrapper for CityGrid APIs}
  s.email = %q{fu7iin@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "citygrid_api.gemspec",
    "lib/citygrid.rb",
    "lib/citygrid/abstraction.rb",
    "lib/citygrid/abstraction/collection.rb",
    "lib/citygrid/abstraction/item.rb",
    "lib/citygrid/abstraction/requestable.rb",
    "lib/citygrid/abstraction/super_array.rb",
    "lib/citygrid/abstraction/super_hash.rb",
    "lib/citygrid/api.rb",
    "lib/citygrid/api/base.rb",
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
    "test/helper.rb",
    "test/publisher_helper.rb.sample",
    "test/test_citygrid.rb",
    "test/test_details.rb",
    "test/test_listing.rb",
    "test/test_search.rb",
    "test/test_super_array.rb",
    "test/test_super_hash.rb"
  ]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Ruby wrapper for CityGrid APIs}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["~> 0.7.8"])
      s.add_development_dependency(%q<awesome_print>, ["~> 0.4.0"])
      s.add_development_dependency(%q<riot>, ["~> 0.12.4"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, ["~> 0.7.8"])
      s.add_dependency(%q<awesome_print>, ["~> 0.4.0"])
      s.add_dependency(%q<riot>, ["~> 0.12.4"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, ["~> 0.7.8"])
    s.add_dependency(%q<awesome_print>, ["~> 0.4.0"])
    s.add_dependency(%q<riot>, ["~> 0.12.4"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

