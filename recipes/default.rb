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
