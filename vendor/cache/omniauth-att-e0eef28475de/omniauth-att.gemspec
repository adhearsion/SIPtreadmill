# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "omniauth-att"
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Lerner", "Michael Fairchild"]
  s.date = "2013-09-23"
  s.description = "Use this OmniAuth to connect to the AT&T Foundry identity services"
  s.email = ["arilerner@mac.com", "mfairchild@tfoundry.com"]
  s.files = [".env.sample", ".gitignore", "Gemfile", "Gemfile.lock", "LICENSE", "Procfile", "README.md", "config.ru", "config/newrelic.yml", "example/example_omniauth_app.rb", "lib/omniauth-att.rb", "lib/omniauth-att/version.rb", "lib/omniauth/strategies/att.rb", "omniauth-att.gemspec"]
  s.homepage = ""
  s.require_paths = ["lib"]
  s.rubyforge_project = "omniauth-att"
  s.rubygems_version = "1.8.25"
  s.summary = "OmniAuth extension to use AT&T accounts"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_runtime_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<thin>, [">= 0"])
      s.add_runtime_dependency(%q<omniauth>, [">= 0"])
      s.add_runtime_dependency(%q<omniauth-oauth2>, [">= 0"])
      s.add_development_dependency(%q<shotgun>, [">= 0"])
      s.add_development_dependency(%q<heroku>, [">= 0"])
      s.add_development_dependency(%q<omniauth-github>, [">= 0"])
      s.add_development_dependency(%q<omniauth-facebook>, [">= 0"])
      s.add_development_dependency(%q<omniauth-twitter>, [">= 0"])
    else
      s.add_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<omniauth>, [">= 0"])
      s.add_dependency(%q<omniauth-oauth2>, [">= 0"])
      s.add_dependency(%q<shotgun>, [">= 0"])
      s.add_dependency(%q<heroku>, [">= 0"])
      s.add_dependency(%q<omniauth-github>, [">= 0"])
      s.add_dependency(%q<omniauth-facebook>, [">= 0"])
      s.add_dependency(%q<omniauth-twitter>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth>, ["~> 1.0"])
    s.add_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<omniauth>, [">= 0"])
    s.add_dependency(%q<omniauth-oauth2>, [">= 0"])
    s.add_dependency(%q<shotgun>, [">= 0"])
    s.add_dependency(%q<heroku>, [">= 0"])
    s.add_dependency(%q<omniauth-github>, [">= 0"])
    s.add_dependency(%q<omniauth-facebook>, [">= 0"])
    s.add_dependency(%q<omniauth-twitter>, [">= 0"])
  end
end
