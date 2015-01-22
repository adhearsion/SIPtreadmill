# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "omniauth-github"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh"]
  s.date = "2015-01-22"
  s.description = "Official OmniAuth strategy for GitHub."
  s.email = ["michael@intridea.com"]
  s.files = [".gitignore", ".rspec", "Gemfile", "Guardfile", "README.md", "Rakefile", "lib/omniauth-github.rb", "lib/omniauth-github/version.rb", "lib/omniauth/strategies/github.rb", "omniauth-github.gemspec", "spec/omniauth/strategies/github_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/intridea/omniauth-github"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Official OmniAuth strategy for GitHub."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_runtime_dependency(%q<omniauth-oauth2>, ["~> 1.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_dependency(%q<omniauth-oauth2>, ["~> 1.1"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth>, ["~> 1.0"])
    s.add_dependency(%q<omniauth-oauth2>, ["~> 1.1"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
