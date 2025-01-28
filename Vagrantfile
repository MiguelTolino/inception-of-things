Vagrant.configure("2") do |config|
  # Use an Ubuntu box (e.g., Ubuntu 20.04)
  config.vm.box = "ubuntu/focal64"

  # Configure VirtualBox provider
  config.vm.provider "virtualbox" do |vb|
    # Enable GUI
    vb.gui = true

    # Allocate 4GB RAM
    vb.memory = "4096"

    # Allocate 4 CPU cores
    vb.cpus = 4

    vb.name = "Ubuntu VM"
  end

  # Install a desktop environment (e.g., GNOME)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y ubuntu-desktop

    # Instalamos dependencias básicas
    sudo apt-get install -y build-essential dkms linux-headers-$(uname -r) apt-transport-https ca-certificates curl software-properties-common

    # Instalamos VirtualBox
    sudo apt-get install -y virtualbox

    # Instalamos Vagrant
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update -y
    sudo apt-get install -y vagrant

    # Instalamos herramientas adicionales
    sudo apt-get install -y git vim unzip wget
  SHELL
end