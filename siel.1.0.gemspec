# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "siel"
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Zarkiel"]
  s.date = "2016-01-03"
  s.description = "Creates a web interface that allows to you manage your project."
  s.email = ["zarkiel@gmail.com"]
  s.homepage = "https://github.com/zarkiel/rails-siel"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Siel - Rails Project Admin."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.2.3"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.2.3"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.2.3"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
