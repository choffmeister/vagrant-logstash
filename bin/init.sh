#!/bin/bash

# update APT
apt-get update

# install basic components
apt-get install vim zip git -y
apt-get install openjdk-7-jre-headless -y
apt-get install nginx -y

# install kibana
cd
wget --quiet http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip
unzip kibana-latest.zip
mv ~/kibana-latest /usr/share/nginx/kibana
sed -i 's/#listen   80;/listen   81;/' /etc/nginx/sites-available/default
sed -i 's/root \(.*\);/root \/usr\/share\/nginx\/kibana;/' /etc/nginx/sites-available/default
service nginx restart

# install elasticsearch
cd
wget --quiet https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.0.deb
dpkg -i elasticsearch-1.3.0.deb
update-rc.d elasticsearch defaults 95 10
/etc/init.d/elasticsearch start

# install logstash
cd
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
echo "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list
apt-get update
apt-get install logstash -y
/etc/init.d/logstash start

# configure example data source
cd
apt-get install apache2 -y
sleep 1
chmod +x /vagrant/bin/testrequests.sh
/vagrant/bin/testrequests.sh
sleep 1
chmod 755 /var/log/apache2
chmod 644 /var/log/apache2/access.log
cp /vagrant/conf.d/* /etc/logstash/conf.d
/etc/init.d/logstash stop
/etc/init.d/logstash start

exit 0
