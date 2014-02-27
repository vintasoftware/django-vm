name              "default"
maintainer        "Flávio Juvenal"
maintainer_email  "flavio@vinta.com.br"
license           "MIT"
description       "Bootstrapping for django webapp"
version           "0.3"
recipe            "default", "Django webapp bootstrapping"

%w{ ubuntu debian }.each do |os|
  supports os
end
