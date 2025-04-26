#!/bin/bash

#exit on failure
set -e

# Update libs
yum update  -y
yum install -y python3
yum install -y git
yum install -y mariadb105-server.x86_64 

python3 -m ensurepip
python3 -m pip install --upgrade pip

cd /home/ec2-user

git clone https://github.com/rriquelme/flask_sql_ec2.git

cd flask_sql_ec2

python3 -m pip install -r requirements.txt

cd src

systemctl start mariadb.service

mysql <<EOF
CREATE DATABASE my_database;
USE my_database;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(100),
    email VARCHAR(100)
);
CREATE USER 'flask_user'@'localhost' IDENTIFIED BY 'flask_pass';
GRANT ALL PRIVILEGES ON my_database.* to 'flask_user'@'localhost';
FLUSH PRIVILEGES;
EOF

python3 main.py