# -----------------------------------------------------------------------
# Cookbook Name:: rdw
# Recipe:: sensor-server
# Description:: installs a simple web server to serve up fake sensor data
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

package "python-pip" do
        action :install
end

execute "pip install flask"

directory "/usr/local/bin/sensor-server" do
	owner "ubuntu"
	group "ubuntu"
	mode "0755"
	action :create
end


template "/usr/local/bin/sensor-server/sensor-server.py" do
	source "sensorserver/sensor-server.py.erb"
	mode 0755
end

template "/etc/init.d/sensorserver" do
	source "sensorserver/etc.initd.sensorserver.erb"
	mode 0755
end

template "/usr/local/bin/sensorserver" do
	source "/sensorserver/usr.local.bin.sensorserver.erb"
	mode 0755
end


