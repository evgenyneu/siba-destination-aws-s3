# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "siba-destination-aws-s3/version"

Gem::Specification.new do |s|
  s.name        = "siba-destination-aws-s3"
  s.version     = Siba::Destination::AwsS3::VERSION
  s.authors     = ["Evgeny Neumerzhitskiy"]
  s.email       = ["sausageskin@gmail.com"]
  s.homepage    = "https://github.com/evgenyneu/siba-destination-aws-s3"
  s.summary     = %q{An extention for SIBA backup and restore utility}
  s.description = %q{An extension for SIBA backup and restore utility. Allows to use Amazon S3 as a backup destination.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency     'siba', '~>0.4'
  s.add_runtime_dependency     'aws-s3', '~>0.6'

  s.add_development_dependency  'minitest', '~>2.10'
  s.add_development_dependency  'rake', '~>0.9'
  s.add_development_dependency  'guard-minitest', '~>0.4'
end
