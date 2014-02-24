nginx_site 'default' do
  enable false
end

directory "/apps"
directory "/apps/#{node.app.name}"
directory "/apps/#{node.app.name}/logs"

template "#{node.nginx.dir}/sites-available/#{node.app.name}" do
  source "site.erb"
  owner node.nginx.user
  group node.nginx.user
end

nginx_site "#{node.app.name}"
