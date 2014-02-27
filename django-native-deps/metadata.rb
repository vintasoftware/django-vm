name              "django-native-deps"
maintainer        "Flávio Juvenal"
maintainer_email  "flavio@vinta.com.br"
license           "MIT"
description       "Installs useful native dependencies for Django projects, including image libraries used by PIL"
version           "0.2"
recipe            "django-native-deps", "Installs useful native dependencies for Django projects, including image libraries used by PIL"

%w{ ubuntu debian }.each do |os|
  supports os
end
