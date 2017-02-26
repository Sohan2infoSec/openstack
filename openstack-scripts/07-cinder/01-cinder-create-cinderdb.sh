#!/bin/bash
#Make sure you set the variable for the MySQL root password
MYSQL_ROOT_PW=Password1

#Create SQL file with SQL code to create DB
cat > create-cinderdb.sql << END
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'Password1';
SHOW GRANTS FOR 'cinder'@'%'
END

#Import SQL File
mysql -u root -p$MYSQL_ROOT_PW < create-cinderdb.sql
