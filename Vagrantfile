Vagrant.configure("2") do |config|
  # Configuração da primeira máquina (servidor WireGuard com Docker)
  config.vm.define "vm1" do |vm1|
    config.vm.box = "bento/ubuntu-23.10"
    config.vm.box_version = "202402.01.0"

    vm1.vm.synced_folder "C:\Users\leobd\wireguard", "/home/vagrant/shared", create: true
    
    # Configuração de rede - NAT para acesso à internet
    vm1.vm.network "public_network"
    
    # Rede privada para comunicação entre as VMs
    vm1.vm.network "private_network", ip: "192.168.56.10"
    
    # Configuração da VM - adaptável conforme necessário
    vm1.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end

    # Port Forwarding - Redirecionar porta 51820 UDP para o host
    #vm1.vm.network "forwarded_port", guest: 51820, host: 51820, protocol: "udp"    

    # Provisão para instalação do Docker e WireGuard no container
    vm1.vm.provision "shell", inline: <<-SHELL
      # Atualizar pacotes
      sudo apt-get update
      
      # Instalar Docker
      sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
      sudo apt-get update
      sudo apt-get install -y docker-ce
      sudo usermod -aG docker vagrant
      newgrp docker

        # Instalar Docker Compose
      sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose

    SHELL
  end

  # Configuração da segunda máquina (cliente WireGuard)
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "bento/ubuntu-23.10"
    
    # Configuração de rede - NAT para acesso à internet
    
    #vm2.vm.network "public_network"
    
    # Rede privada para comunicação entre as VMs
    vm2.vm.network "private_network", ip: "192.168.56.11"
    
    # Configuração da VM - adaptável conforme necessário
    vm2.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end

    # Provisão para instalação do WireGuard como cliente
    vm2.vm.provision "shell", inline: <<-SHELL
      # Atualizar pacotes

      #remove rota default
      sudo ip route del default || true
      #add nova rota usando a VM1 como GW
      sudo ip route add default via 192.168.56.10

      sudo apt-get update
      
      # Instalar WireGuard
      sudo apt-get install -y wireguard
      
      # Gerar chave WireGuard para o cliente
      wg genkey | tee /vagrant/client_private.key | wg pubkey > /vagrant/client_public.key
    SHELL
  end
end
