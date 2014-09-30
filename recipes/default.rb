#
# Cookbook Name:: logstash
# Recipe:: default
#
# Copyright 2014, Jacques Marneweck
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/logstash-#{node['logstash']['version']}.tar.gz" do
  source "https://download.elasticsearch.org/logstash/logstash/logstash-#{node['logstash']['version']}.tar.gz"
  checksum node['logstash']['checksum']
end

include_recipe "elasticsearch::default"

package "openjdk7" do
  action :install
end

directory "/opt/logstash" do
  owner "root"
  group "root"
  mode "0755"
end

execute "extract-logstash" do
  command "gtar -zxvf #{Chef::Config[:file_cache_path]}/logstash-#{node['logstash']['version']}.tar.gz"
  cwd "/opt/logstash"
  not_if { ::File.exists?("/opt/logstash/logstash-#{node['logstash']['version']}") }
end

execute "svccfg-import-logstashmanifest" do
  command "/usr/sbin/svccfg import /var/chef/cookbooks/logstash/files/default/manifests/logstash.xml"
  not_if "/usr/bin/svcs -H logstash"
end

execute "svccfg-import-logstash-web-manifest" do
  command "/usr/sbin/svccfg import /var/chef/cookbooks/logstash/files/default/manifests/logstash-web.xml"
  not_if "/usr/bin/svcs -H logstash-web"
end

service "logstash" do
  action [ :enable ]
end

service "logstash-web" do
  action [ :enable ]
end
