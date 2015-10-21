name              "treadmill"
maintainer        "Adhearsion Foundation Inc"
maintainer_email  "info@adhearsion.com"
license           "MIT"
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
