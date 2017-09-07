# Install and configure puppetserver.
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y puppetserver puppet-agent
ln -sf /opt/puppetlabs/bin/* /usr/bin

# REF: https://tickets.puppetlabs.com/browse/SERVER-528
systemctl stop puppet
systemctl stop puppetserver
rm -rf /etc/puppetlabs/puppet/ssl/private_keys/*
rm -rf /etc/puppetlabs/puppet/ssl/certs/*
echo 'autosign = true' >> /etc/puppetlabs/puppet/puppet.conf
systemctl start puppetserver

# Puppet agent looks for the server called "puppet" by default.
# In this case, we want that to be us (the loopback address).
echo '127.0.0.1 localhost puppet' > /etc/hosts

# Install puppet-logstash dependencies.
for module in puppetlabs-stdlib puppetlabs-apt elastic-elastic_stack; do
  /opt/puppetlabs/bin/puppet module install \
    --target-dir=/etc/puppetlabs/code/environments/production/modules \
    $module
done

# Install Java 8 for Logstash.
yum install -y java-1.8.0-openjdk-devel
java -version 2>&1

# Place a manifest to test the Logstash module.
cat <<EOF > /etc/puppetlabs/code/environments/production/manifests/site.pp
class { 'logstash':
  manage_repo  => true,
  version      => '5.5.2',
}

logstash::configfile { 'basic_config':
  content => 'input { tcp { port => 2000 } } output { null {} }'
}
EOF
