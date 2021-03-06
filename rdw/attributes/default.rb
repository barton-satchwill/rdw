default[:postgresql][:role] = "ubuntu"
default[:postgresql][:db] = "rdw"
default[:postgresql][:passwd] = "change-me"

default[:postgresql][:config][:wal_level] = "hot_standby"
default[:postgresql][:config][:archive_mode] = "on"
default[:postgresql][:config][:archive_command] = "/usr/local/bin/postgresql_archive \"%p\""
default[:postgresql][:config][:archive_timeout] = 600

default[:omnipitr][:tmp] = "/postgresql/tmp"

default[:remote][:backup][:ipaddress] = "199.116.235.151"
default[:remote][:backup][:db][:path] = "/backups/db"
default[:remote][:backup][:db][:time] = "00:40"
default[:remote][:backup][:fs][:path] = "/backups/fs"
default[:remote][:backup][:fs][:time] = "00:50"

default[:local][:backup][:db][:path] = "/postgresql/backups"
default[:local][:backup][:wal][:path] = "/postgresql/WAL"
default[:local][:backup][:db][:time] = "00:30"

default[:OS_AUTH_URL] = "<object storage service url"
default[:OS_PASSWORD] = "<object storage password>"
default[:OS_REGION_NAME] = "<object storage region>"
default[:OS_TENANT_ID] = "<object storage project id>"
default[:OS_TENANT_NAME] = "<object storage project name>"
default[:OS_USERNAME] = "<object storage username>"

