default["postgresql"]["config"]["wal_level"] = "hot_standby"
default["postgresql"]["config"]["archive_mode"] = "on"
default["postgresql"]["config"]["archive_command"] = "/usr/local/bin/postgresql_archive \"%p\""
default["postgresql"]["config"]["archive_timeout"] = 600

default["omnipitr"]["tmp"] = "/postgresql/tmp"
default["postgresql"]["backup_time"] = "00:30"
default["postgresql"]["backup_path"] = "/postgresql/backups"
default["postgresql"]["wal_path"] = "/postgresql/WAL"