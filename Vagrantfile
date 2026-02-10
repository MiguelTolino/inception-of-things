Vagrant.configure("2") do |config|
  # Use the latest Fedora box
  config.vm.box = "bento/fedora-latest"

  # Configure VirtualBox provider
  config.vm.provider "virtualbox" do |vb|
    # Enable GUI
    vb.gui = true

    # Allocate 4GB RAM
    vb.memory = "4096"

    # Allocate 4 CPU cores
    vb.cpus = 4

    vb.name = "Fedora VM"
    #AMD-V
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
  end

  # Install GNOME desktop environment
  config.vm.provision "shell", inline: <<-SHELL
    sudo dnf update -y
    sudo dnf install @cinnamon-desktop-environment -y
    sudo systemctl set-default graphical.target
    #Dependencies
    sudo dnf install -y @development-tools kernel-devel kernel-headers dkms elfutils-libelf-devel qt5-qtx11extras zlib-devel perl gcc make
    #VirtualBox
    wget https://download.virtualbox.org/virtualbox/7.2.2/VirtualBox-7.2-7.2.2_170484_fedora40-1.x86_64.rpm
    sudo dnf install -y ./VirtualBox-7.2-7.2.2_170484_fedora40-1.x86_64.rpm
    rm VirtualBox-7.2-7.2.2_170484_fedora40-1.x86_64.rpm
    # Add user to vboxusers group (replace $USER if needed)
    sudo usermod -aG vboxusers vagrant

    # Add VirtualBox to PATH permanently
    echo 'export PATH=$PATH:/usr/lib/virtualbox' | sudo tee /etc/profile.d/virtualbox.sh
    sudo chmod +x /etc/profile.d/virtualbox.sh
    source /etc/profile.d/virtualbox.sh
    
    #Vagrant
    wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
    sudo yum list available | grep hashicorp
    sudo dnf update -y
    sudo dnf -y install vagrant

    sudo reboot

    #sudo /sbin/vboxconfig
    #sudo modprobe -r kvm_amd
  SHELL
end