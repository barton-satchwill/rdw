default["postgresql"]["role"] = "ubuntu"
default["postgresql"]["db"] = "rdw"
default["postgresql"]["passwd"] = "change-me"

default["postgresql"]["config"]["wal_level"] = "hot_standby"
default["postgresql"]["config"]["archive_mode"] = "on"
default["postgresql"]["config"]["archive_command"] = "/usr/local/bin/postgresql_archive \"%p\""
default["postgresql"]["config"]["archive_timeout"] = 600

default["omnipitr"]["tmp"] = "/postgresql/tmp"
default["postgresql"]["backup_time"] = "00:30"
default["postgresql"]["backup_path"] = "/postgresql/backups"
default["postgresql"]["wal_path"] = "/postgresql/WAL"

default["backup"]["ipaddress"] = "199.116.235.151"
default["backup"]["db"] = "/backups/db"
default["backup"]["fs"] = "/backups/fs"
