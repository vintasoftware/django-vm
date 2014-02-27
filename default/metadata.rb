name              "default"
maintainer        "Flávio Juvenal"
maintainer_email  "flavio@vinta.com.br"
license           "MIT"
description       "Create directories for webapps"
version           "0.2"
recipe            "default", "Webapps directory cration"

%w{ ubuntu debian }.each do |os|
  supports os
end
