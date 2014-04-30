#
# Cookbook Name:: dockworker
# Recipe:: provisioner
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

docker_registry 'https://index.docker.io/v1/' do
  email 'mpgoetz@gmail.com'
  username 'micgo'
  password node['dockworker']['registry_password']
end

docker_image 'ubuntu' do
  retries 2
  tag 'latest'
  action :pull_if_missing
end