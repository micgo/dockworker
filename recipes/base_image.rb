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

cookbook_file "#{Chef::Config[:file_cache_path]}/Dockerfile" do
  source "Dockerfile"
  owner "root"
  group "root"
  mode "0644"
end

docker_image 'memcached_img' do
  tag 'latest'
  source "#{Chef::Config[:file_cache_path]}/Dockerfile"
  action :build_if_missing
end

docker_image 'micgo/memcached_img' do
  tag 'latest'
  action :push
end