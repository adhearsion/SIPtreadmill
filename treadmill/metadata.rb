name              "treadmill"
maintainer        "Mojo Lingo LLC"
maintainer_email  "ops@mojolingo.com"
license           "proprietary"
description       "Sets up treadmill dev environment"
recipe            "database", "Sets up a database for Treadmill dev"
depends           "openssl"
depends           "postgresql"
depends           "database"
depends           "rvm"
depends           "redis"
depends           "sudo"
depends           "sipp"

%w{ ubuntu debian }.each do |os|
  supports os
end
