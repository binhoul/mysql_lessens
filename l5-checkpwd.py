#!/usr/bin/python

##################
#check the password in mysql database
#author: binhoul
##################

import MySQLdb
import pdb

host = '127.0.0.1'
user = 'root'
password = 'fengmxx'

conn = MySQLdb.connect(host = host, user = user, passwd = password, db = 'mysql', port = 3306)
cur = conn.cursor()
sql = 'select user,host,password from mysql.user';
cur.execute(sql)
results = cur.fetchall()
fh = open('./password.list','r')
for oneuser in results:
    sql = "select password('%s')" % (oneuser[0])
    cur.execute(sql)
    (asuser_enc,) = cur.fetchone()
    if asuser_enc == oneuser[2] or None == oneuser[2]:
        print "user: %s, host: %s use weak password, please modify it!" %(oneuser[0], oneuser[1])
    for line in fh:
        sql = "select password('%s')" % (line.strip('\n'))
        cur.execute(sql)
        (line_enc,) = cur.fetchone()
        if line_enc == oneuser[2]:
            print "user: %s,host: %s use weak password please modify it!"  %(oneuser[0], oneuser[1])
    fh.seek(0)
fh.close()
cur.close()
conn.close()
