#
# Cookbook Name:: eclipse
# Recipe:: default
#
# Copyright (C) 2013 Geocent, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['eclipse']['url'].empty?
  eclipse_url_lead = 'http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release'
  eclipse_url_tail = "/#{node['eclipse']['version']}/#{node['eclipse']['release_code']}/eclipse-#{node['eclipse']['suite']}-#{node['eclipse']['version']}-#{node['eclipse']['release_code']}-#{node['eclipse']['os']}-#{node['eclipse']['arch']}.tar.gz&r=1"
  eclipse_url = eclipse_url_lead + eclipse_url_tail
else
  eclipse_url = node['eclipse']['url']
end

# Install eclipse defined in attributes
eclipse node['eclipse']['version'] do
  action          :install
  url             eclipse_url
  checksum        node['eclipse']['checksum'] if node['eclipse']['checksum']
  append_env_path true
end

# Install plugins defined in attributes
unless node['eclipse']['plugins'].empty?
  node['eclipse']['plugins'].each do |plugin_group|
    repo, plugins = plugin_group.first
    eclipse_plugin plugins do
      action :install
      url repo
    end
  end
end
