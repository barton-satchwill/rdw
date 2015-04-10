# -----------------------------------------------------------------------
# Cookbook Name:: rdw
# Recipe:: default
# Description::
#
# Copyright 2015, Cybera, inc.
# All rights reserved
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License. 
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
# -----------------------------------------------------------------------
# - all of this needs a major re-factoring, and a clean-up of attributes
# - replace 'create-db' task with a utility script
# - add log directory
# -----------------------------------------------------------------------

template "/etc/motd" do
	source "motd.erb"
end

template "/tmp/createdb.sql" do
	source "createdb.sql"
end

execute "create-db" do
	user "postgres"
	command "psql -f /tmp/createdb.sql -v db='#{node[:postgresql][:db]}' -v passwd='#{node[:postgresql][:passwd]}' -v user='#{node[:postgresql][:role]}'"
end

directory "/science-path" do
	action :create
	recursive true
	mode 755
end
	

cron "backup-fs" do
	hour node[:backup][:db_cron_hour]
	minute node[:backup][:db_cron_minute]
	command "/usr/bin/rsync -e 'ssh -o StrictHostKeyChecking=no' -a /science-path/ #{node[:backup][:ipaddress]}:#{node[:backup][:fs]}/"
end

cron "backup-db" do
	hour node[:backup][:db_cron_hour]
	minute node[:backup][:db_cron_minute]
	command "/usr/bin/rsync -e 'ssh -o StrictHostKeyChecking=no' -a #{node[:postgresql][:backup_path]}/ #{node[:backup][:ipaddress]}:#{node[:backup][:db]}/"
end

