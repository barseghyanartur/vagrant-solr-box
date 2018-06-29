##################################################
######### Solr 7.1 installer for Vagrant #########
##################################################

#################### Install Java 8 ##############
echo "Java 8 installation"
apt-get install --yes python-software-properties
apt-get install --yes software-properties-common
add-apt-repository ppa:webupd8team/java
apt-get update -qq
echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
echo debcosnf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections
apt-get install --yes oracle-java8-installer
yes "" | apt-get -f install
sudo apt-get install oracle-java8-set-default
sudo echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc
source ~/.bashrc

############ Install other requirements ##########
echo "Update software indexes"
sudo apt-get update && apt-get upgrade -y

# Install other requirements
echo "Install other requirements: libxml2-dev libxslt1-dev"
sudo apt-get install libxml2-dev libxslt1-dev -y

echo "Install other requirements: git-core, nano, curl, unzip"
sudo apt-get install git-core nano curl vim

################## Install Solr ##################
echo "Download Solr"
# curl -L https://archive.apache.org/dist/lucene/solr/7.1.0/solr-7.1.0.tgz | tar zx --directory=/vagrant/solr --strip-components 1
wget https://archive.apache.org/dist/lucene/solr/7.1.0/solr-7.1.0.tgz
tar xzf solr-7.1.0.tgz solr-7.1.0/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-7.1.0.tgz
# echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections 
# echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

echo "Starting Solr on port 8983"
# sudo /opt/solr/bin/solr start
sudo service solr start

echo "Starting Solr with techproducts on port 8984"
sudo /opt/solr/bin/solr start -e techproducts -p 8984 -force

################### Install banana ###############
echo "Download Banana"
wget https://github.com/lucidworks/banana/archive/release.zip
unzip release.zip
sudo mv banana-release/src/ /opt/solr/server/solr-webapp/webapp/banana/
rm release.zip

echo "Restart Solr on port 8983"
sudo service solr restart

echo "Restart Solr on port 8984"
sudo /opt/solr/bin/solr restart -e techproducts -p 8984 -force
