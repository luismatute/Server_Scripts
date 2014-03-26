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