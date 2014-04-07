##Initialice Variables##
TODAY=`date '+%d-%m-%Y'`
SCRIPT_NAME="NodeJS-MongoDB-Git"
VERSION="0.0.1"
TEMP_DIR="/data/tmp"
WEBROOT_DIR="/webroot"

##Create Temp Dir##
echo "Creating temporary directory"
mkdir -p $TEMP_DIR

##Create webroot dir##
echo "Creating webroot directory" $WEBROOT_DIR"/default"
mkdir -p $WEBROOT_DIR/default

##Update OS##
echo "Updating OS to the latest version"
yum update -y

##Install Git##
echo "Installing Git"
yum -y install git

##Install NginX and Start the service##
echo "Downloading and installing NGINX repository"
wget -P $TEMP_DIR http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
rpm -ivh $TEMP_DIR/nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum -y install nginx
echo "Starting NGINX service"
service nginx start
chkconfig nginx on

##Installing MongoDB instead##
echo "Installing MongoDB"
cat <<EOF > /etc/yum.repos.d/mongodb.repo
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
EOF
yum -y install mongo-10gen mongo-10gen-server
echo "Creating DB directory and starting service"
mkdir -p /data/db/
service mongod start
chkconfig mongod on

##Installing NodeJS##
echo "Installing NodeJS...this can take a while"
yum -y groupinstall "Development Tools"
wget http://nodejs.org/dist/v0.10.26/node-v0.10.26.tar.gz
tar zxf node-v0.10.26.tar.gz
cd node-v0.10.26
./configure
make
make install

npm install supervisor -g
npm install forever -g

############# NGINX CONF ############
vi /etc/nginx/conf.d/virtual.conf  
server {
    listen       0.0.0.0:80;
    server_name  107.170.79.107;
    root /webroot/NodeChat;
    access_log  /var/log/nginx/NodeChat.log;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://127.0.0.1:3000;
        proxy_redirect off;
    }
}