apps_dir = "/apps"
code_dir = "#{apps_dir}/#{node.app.name}"
bare_dir = "#{code_dir}.git"
app_user = 'vagrant'

nginx_site 'default' do
  enable false
end

directory apps_dir do
  owner app_user
  group app_user
end

directory code_dir do
  owner app_user
  group app_user
end

directory bare_dir do
  owner app_user
  group app_user
end

execute "create bare repository" do
  cwd bare_dir
  user app_user
  group app_user
  
  command <<-EOF
    git init --bare
  EOF
  
  not_if do
    ::File.exists?("#{bare_dir}/HEAD")
  end
end

execute "create code repository" do
    cwd code_dir
    user app_user
    group app_user

    command <<-EOF
      git init
      git remote add origin /apps/#{node.app.name}.git
    EOF

    not_if "cd #{code_dir} && git status"  # check if code repository exists
end

directory "#{code_dir}/logs" do
  owner app_user
  group app_user
end

python_virtualenv "#{code_dir}/env" do
  owner app_user
  group app_user
end

template "#{bare_dir}/hooks/post-receive" do
  source "post-receive.erb"
  owner app_user
  group app_user
  mode 0755
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}" do
  source "site.erb"
  owner node.nginx.user
  group node.nginx.user
end

nginx_site "#{node.app.name}"

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{node.app.name}"
    not_if "psql -U postgres --list | grep #{node.app.name}"
end

execute "create plpythonu on database" do
  command "createlang -U postgres plpythonu #{node.app.name}"
  not_if "createlang -U postgres -l #{node.app.name} | grep plpythonu"
end
