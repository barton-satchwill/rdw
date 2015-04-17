
#===========================================================================#
#                                                                           #
#                    Caution: This file is managed by Chef                  #
#                                                                           #
#===========================================================================#


import psycopg2
import sys
import json
import urllib
import urllib2
import ast

# sudo pip install psycopg2
# sudo apt-get install libpq-dev python-dev
# sudo pip install psycopg2


url = 'http://199.116.235.151:5000/read_sensor'
response = ast.literal_eval(urllib2.urlopen(url).read())
sql = 'insert into sensor_reading ('
attributes = ""
values = ""
for k,v in response.items():
	for attrib, reading in v.items():
		attributes = attributes + attrib + ", "
		values = values + str(reading) + ", "

sql = sql + attributes[:-2] + ") values (" + values[:-2] + ");"
insert = "psql -d rdw -c '" + sql + "'"
print insert


conn = None

try:
	conn = psycopg2.connect(database='rdw', user='ubuntu') 
	curr = conn.cursor()
	curr.execute(sql)
	conn.commit()
	curr.close()

except psycopg2.DatabaseError, e:
	print 'Error %s' % e
	sys.exit(1)

finally:
	if conn:
		conn.close()

