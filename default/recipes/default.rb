nginx_site 'default' do
  enable false
end

directory "/apps" do
  owner 'vagrant'
  group 'vagrant'
end

directory "/apps/#{node.app.name}.git" do
  owner 'vagrant'
  group 'vagrant'
end

directory "/apps/#{node.app.name}" do
  owner 'vagrant'
  group 'vagrant'
end

directory "/apps/#{node.app.name}/logs" do
  owner 'vagrant'
  group 'vagrant'
end

python_virtualenv "/apps/#{node.app.name}/env" do
  action :create
  owner 'vagrant'
  group 'vagrant'
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}" do
  source "site.erb"
  owner node.nginx.user
  group node.nginx.user
end

nginx_site "#{node.app.name}"

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{node.app.db.name}"
    not_if "psql -U postgres --list | grep #{node.app.db.name}"
end
