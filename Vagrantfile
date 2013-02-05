# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :ls do |ls|
    ls.vm.box        = "precise32"
    ls.vm.host_name  = "ls"
    ls.vm.customize    ["modifyvm", :id, "--memory", "1024"]
    ls.vm.share_folder "module", 
                       "/tmp/vagrant-puppet/modules/logstash", 
                       ".", 
                       :create => true
    ls.ssh.max_tries = 150

    # Upgrade Vagrant's inline Puppet to 3.x:
    ls.vm.provision :shell do |shell|
      shell.inline = "/opt/vagrant_ruby/bin/gem update puppet --no-ri --no-rdoc"
    end

    # Run apt-get update:
    ls.vm.provision :shell do |shell|
      shell.inline = "/usr/bin/apt-get update"
    end

    MANIFESTS = [
      'vagrant-prereq.pp', # prerequisites, e.g. other Puppet modules
      'vagrant.pp'         # the Logstash configuration we're testing
    ]

    # Run the Puppet provisioner for each manifest
    for manifest in MANIFESTS
      ls.vm.provision :puppet do |puppet|
        puppet.manifests_path = "tests"
        puppet.manifest_file = manifest
        puppet.options = ["--modulepath", "/tmp/vagrant-puppet/modules"]
      end
    end
  end
end
