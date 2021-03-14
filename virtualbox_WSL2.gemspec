# frozen_string_literal: true

require_relative "lib/virtualbox_WSL2/version"

Gem::Specification.new do |spec|
  spec.name          = "virtualbox_WSL2"
  spec.version       = VirtualboxWSL2::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.authors       = ["Andrei Lapin"]
  spec.email         = ["karandash8@gmail.com"]

  spec.summary       = "Plugin allows to properly use VirtualBox as Vagrant provider on WSL2."
  spec.description   = "Two things happen on top of normal Vagrant behavior: (1) the second port forwarding entry is created on 0.0.0.0 that allows to ssh to VirtualBox VM from WSL2 on Windows IP. (2) Windows IP is automatically selected for `vagrant ssh` command instean of localhost."
  spec.homepage      = "http://www.vagrantup.com"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "rake"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
