# Cookbook Name:: go
# Recipe:: default

package "tar" do
	action :install
end

remote_file node[:go][:cache] do
	source node[:go][:packageurl]
	owner "root"
	group "root"
	mode 0644
	not_if do
		File.exists?(node[:go][:cache])
	end
end

# Create target directory if it does not exists
directory "#{node[:go][:target]}" do
	owner "root"
	group "root"
	mode 0755
	recursive true
	action :create
end

# Remove old go installation
directory "#{node[:go][:target]}/go" do
	recursive true
	action :delete
end

execute "tar" do
	user "root"
	group "root"
	cwd node[:go][:target]
	command "tar xf #{node[:go][:cache]}"
end

# Set $PATH and $GOROOT for everyone
template "/etc/profile.d/go.sh" do
	source "go.sh.erb"
	owner "root"
	group "root"
	mode 0644
	variables(
		:target => node[:go][:target]
	)
end




