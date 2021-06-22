Vagrant.configure("2") do |config|

  # All server set
  config.vm.box = "centos/8"
  config.vm.box_check_update = true

  # Create cent1
  config.vm.define "cent1" do |cent1|
    cent1.vm.hostname = "cent1"
    cent1.vm.network "private_network", ip: "172.18.1.91"
    cent1.vm.network "private_network", ip: "10.18.1.91"
    cent1.vm.provider "virtualbox" do |v|
      v.name = "cent1"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
      v.gui = false
    end

    cent1.vm.provision "file", source: ".", destination: "/tmp/vagrant"
    cent1.vm.provision "shell", inline: <<-SHELL
      sudo mv /tmp/vagrant /vagrant
      sudo dnf -y install dnf-utils
      sudo dnf -y install nano vim git net-tools tar binutils psmisc wget sysstat dialog epel-release
      sudo dnf -y install stress 
      sudo dnf -y install nginx
    SHELL
    cent1.vm.provision "shell", path: "SHELL/init.sh"
  end

  # Create cent2
  config.vm.define "cent2" do |cent2|
    cent2.vm.hostname = "cent2"
    cent2.vm.network "private_network", ip: "172.18.1.92"
    cent2.vm.network "private_network", ip: "10.18.1.92"
    cent2.vm.provider "virtualbox" do |v|
      v.name = "cent2"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
      v.gui = false
    end

    cent2.vm.provision "file", source: ".", destination: "/tmp/vagrant"
    cent2.vm.provision "shell", inline: <<-SHELL
      mv /tmp/vagrant /vagrant
      cat << EOF >| /etc/yum.repos.d/MariaDB.repo
#MariaDB 10.4 CentOS repository list
#http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos8-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

      sudo dnf -y install dnf-utils
      sudo dnf -y install nano vim git net-tools tar binutils psmisc wget sysstat dialog epel-release
      sudo dnf -y install boost-program-options stress
      sudo dnf -y install mariadb-server --disablerepo=AppStream
      sudo dnf -y install mariadb-client --disablerepo=AppStream
      sudo dnf -y install mariadb-backup --disablerepo=AppStream      
    SHELL
    cent2.vm.provision "shell", path: "SHELL/init.sh"
  end

  # Create cent3
  config.vm.define "cent3" do |cent3|
    cent3.vm.hostname = "cent3"
    cent3.vm.network "private_network", ip: "172.18.1.93"
    cent3.vm.network "private_network", ip: "10.18.1.93"
    cent3.vm.provider "virtualbox" do |v|
      v.name = "cent3"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
      v.gui = false
    end

    cent3.vm.provision "file", source: ".", destination: "/tmp/vagrant"
    cent3.vm.provision "shell", inline: <<-SHELL
      mv /tmp/vagrant /vagrant
      sudo mkdir /nfs              
      sudo dnf -y install dnf-utils
      sudo dnf -y install nano vim git net-tools tar binutils psmisc wget sysstat dialog epel-release
      sudo dnf -y install stress
    SHELL
    cent3.vm.provision "shell", path: "SHELL/init.sh"
  end
end
