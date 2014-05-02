#
# Cookbook Name:: dockworker
# Recipe:: base_image
#
# Copyright 2012-2014, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'docker'
include_recipe 'packer'

chef_gem 'berkshelf'

git "#{Chef::Config[:file_cache_path]}/dockworker" do
  repository "https://github.com:micgo/dockworker.git"
  reference "master"
  action :sync
end

execute 'Install dependent cookbooks for dockworker' do
  cwd '/var/chef/cache/dockworker'
  command "/opt/chef/embedded/bin/berks vendor #{Chef::Config[:file_cache_path]}/cookbooks"
end

cookbook_file "#{Chef::Config[:file_cache_path]}/ubuntu-docker-base.json" do
  source "ubuntu-docker-base.json"
  owner "root"
  group "root"
  mode "0644"
end

execute 'Create ubuntu base image' do
  cwd "#{Chef::Config[:file_cache_path]}"
  command 'packer build ubuntu-docker-base.json'
  not_if ::File.exists?("#{Chef::Config[:file_cache_path]}/ubuntu_base.tar")
end

docker_image 'elasticsearch_base' do
  source "#{Chef::Config[:file_cache_path]}/ubuntu_base.tar"
  action :import
end