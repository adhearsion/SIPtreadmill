# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sippy_cup"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Klang", "Will Drexler"]
  s.date = "2013-09-23"
  s.description = "This tool makes it easier to generate SIPp load tests with DTMF interactions."
  s.email = ["bklang&mojolingo.com", "wdrexler&mojolingo.com"]
  s.executables = ["sippy_cup"]
  s.files = [".gitignore", ".rspec", ".ruby-version", ".travis.yml", "CHANGELOG.md", "Gemfile", "Guardfile", "LICENSE", "README.markdown", "Rakefile", "bin/sippy_cup", "lib/sippy_cup.rb", "lib/sippy_cup/media.rb", "lib/sippy_cup/media/dtmf_payload.rb", "lib/sippy_cup/media/pcmu_payload.rb", "lib/sippy_cup/media/rtp_header.rb", "lib/sippy_cup/media/rtp_payload.rb", "lib/sippy_cup/rtp_generator.rb", "lib/sippy_cup/runner.rb", "lib/sippy_cup/scenario.rb", "lib/sippy_cup/tasks.rb", "lib/sippy_cup/version.rb", "sippy_cup.gemspec", "spec/sippy_cup/fixtures/test.yml", "spec/sippy_cup/media_spec.rb", "spec/sippy_cup/runner_spec.rb", "spec/sippy_cup/scenario_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/bklang/sippy_cup"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "SIPp profile and RTP stream generator"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<packetfu>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6.0"])
      s.add_runtime_dependency(%q<activesupport>, ["> 3.0"])
      s.add_runtime_dependency(%q<psych>, ["~> 2.0.0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.11"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<simplecov-rcov>, [">= 0"])
      s.add_development_dependency(%q<fakefs>, [">= 0"])
    else
      s.add_dependency(%q<packetfu>, [">= 0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.6.0"])
      s.add_dependency(%q<activesupport>, ["> 3.0"])
      s.add_dependency(%q<psych>, ["~> 2.0.0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.11"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<simplecov-rcov>, [">= 0"])
      s.add_dependency(%q<fakefs>, [">= 0"])
    end
  else
    s.add_dependency(%q<packetfu>, [">= 0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.6.0"])
    s.add_dependency(%q<activesupport>, ["> 3.0"])
    s.add_dependency(%q<psych>, ["~> 2.0.0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.11"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>, [">= 0"])
    s.add_dependency(%q<fakefs>, [">= 0"])
  end
end
