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
# 	- build a better db script
# - add log directory
# -----------------------------------------------------------------------

package "libpq-dev"
package "python-dev"
package "python-pip" 
execute "pip install flask"


template "/etc/motd" do
	source "motd.erb"
end

template "/tmp/createdb.sql" do
	source "db/createdb.sql"
end

execute "create-db" do
	user "postgres"
	command "psql -f /tmp/createdb.sql -v db='#{node[:postgresql][:db]}' -v passwd='#{node[:postgresql][:passwd]}' -v user='#{node[:postgresql][:role]}'"
end

directory "/science-path" do
	action :create
	recursive true
	mode 0755
end

# configuration files
directory "/etc/rdw" do
	action :create
	recursive true
	mode 0755
end


cron "backup-fs" do
	hour node[:remote][:backup][:fs][:time].split(":").first.to_i
	minute node[:remote][:backup][:fs][:time].split(":").last.to_i
	command "/usr/bin/rsync -e 'ssh -o StrictHostKeyChecking=no' -a /science-path/ #{node[:remote][:backup][:ipaddress]}:#{node[:remote][:backup][:fs][:path]}/"
end

cron "backup-db" do
	hour node[:remote][:backup][:db][:time].split(":").first.to_i
	minute node[:remote][:backup][:db][:time].split(":").last.to_i
	command "/usr/bin/rsync -e 'ssh -o StrictHostKeyChecking=no' -a #{node[:local][:backup][:db][:path]}/ #{node[:remote][:backup][:ipaddress]}:#{node[:remote][:backup][:db][:path]}/"
end


# ---------- this should probably be in it's own recipe ----------
# TODO: set the swift environment variables

package "python-swiftclient"

# create a .csv extract of the database
template "/usr/local/bin/create-db-archive" do
	source "db/archive/create-db-archive.erb"
	owner "ubuntu"
	group "ubuntu"
	mode "0755"
end

template "/etc/rdw/db-archive-header" do
	source "db/archive/db-archive-header.erb"
	owner "ubuntu"
	group "ubuntu"
	mode "0644"
end

cron "create-archive-db" do
	hour 23
	minute 17
	user "ubuntu"
	command "/usr/local/bin/create-db-archive"
end


# upload the .csv extract to the archive storage
template "/usr/local/bin/archive-db" do
	source "db/archive/archive.py.erb"
	owner "ubuntu"
	group "ubuntu"
	mode "0755"
end

cron "archive-db" do
	hour 23
	minute 23
	user "ubuntu"
	command "/usr/local/bin/archive-db"
end

