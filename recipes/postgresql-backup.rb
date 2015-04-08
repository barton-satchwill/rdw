# -----------------------------------------------------------------------
# Cookbook Name:: rdw
# Recipe:: postgresql-backup
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


template "/usr/local/bin/postgresql_hot_backup" do
	source "postgresql_hot_backup.py.erb"
	owner "postgres"
	group "postgres"
	mode 0700
end

template "/usr/local/bin/postgresql_archive" do
	source "postgresql_archive.py.erb"
	owner "postgres"
	group "postgres"
	mode 0755
end

# Install omnipitr package
directory "/usr/local/stow" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

git "/usr/local/stow/omnipitr" do
	repository "https://github.com/omniti-labs/omnipitr.git"
	action :sync
	notifies :run, "execute[stow omnipitr]", :immediately
end

package "stow"

execute "stow omnipitr" do
	cwd "/usr/local/stow"
	creates "/usr/local/bin/omnipitr-archive"
	action :run
end

# Note that this assumes that either a mountpoint or directory exists at /postgresql

# Create necessary directories for omnipitr backups
[
#	node[:postgresql][:backup_path],
#	node[:postgresql][:wal_path],
#	node[:omnipitr][:tmp],
#	"#{node[:omnipitr][:tmp]}/state"
"/tmp/backup","/tmp/wal","/tmp/temp","/tmp/temp/state"
].each do | dir |

	directory dir do
		owner "postgres"
		group "postgres"
		mode 00755
		recursive true
		action :create
	end

end

# Eliminates warnings about locale when doing backups
["firefox-locale-en","language-pack-en","language-pack-en-base"].each do |language_pack|
  package language_pack do
    action [:install]
  end
end

execute "/usr/share/locales/install-language-pack en_CA" do
  not_if {`locale -a | grep 'en_CA'`.start_with?("en_CA")}
end

service "cron"

bash "set timezone to America/Edmonton" do
  user "root"
  code <<-EOH
    echo "America/Edmonton" >/etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
    hwclock --systohc
  EOH
  not_if { IO.read("/etc/timezone").strip == "America/Edmonton" }
	notifies :restart, "service[cron]"
end

cron "clock sync" do
  minute 3
  command "ntpdate ca.pool.ntp.org"
end

cron "daily postgresql database backup" do
	hour node[:postgresql][:backup_time].split(":").first.to_i
	minute node[:postgresql][:backup_time].split(":").last.to_i
	command "/usr/local/bin/postgresql_hot_backup"
end

