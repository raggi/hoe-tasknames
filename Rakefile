#!/usr/bin/env rake

require 'hoe'
Hoe.plugin :doofus, :git, :minitest

# Bad practice normally, but I actually want this loaded from local:
$LOAD_PATH << File.expand_path('lib', Dir.pwd)

Hoe.plugin :tasknames

Hoe.spec 'hoe-tasknames' do
  developer 'James Tucker', 'raggi@rubyforge.org'
  extra_dev_deps << %w(hoe-doofus >=1.0)
  extra_dev_deps << %w(hoe-seattlerb >=1.2)
  extra_dev_deps << %w(hoe-git >=1.3)

  self.extra_rdoc_files = FileList["**/*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.rubyforge_name   = 'libraggi'
end