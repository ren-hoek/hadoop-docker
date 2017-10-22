CREATE DATABASE metastore;
USE metastore;
SOURCE /opt/hive/scripts/metastore/upgrade/mysql/hive-schema-2.1.0.mysql.sql;

CREATE USER 'hive'@'localhost' IDENTIFIED BY 'mypassword';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hive'@'localhost';
GRANT ALL PRIVILEGES ON metastore.* TO 'hive'@'localhost';
FLUSH PRIVILEGES;
