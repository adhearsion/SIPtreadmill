name              "treadmill"
maintainer        "Mojo Lingo LLC"
maintainer_email  "ops@mojolingo.com"
license           "proprietary"
description       "Sets up treadmill dev environment"
recipe            "database", "Sets up a database for Treadmill dev"

%w{ ubuntu debian }.each do |os|
  supports os
end
