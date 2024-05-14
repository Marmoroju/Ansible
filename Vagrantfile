Vagrant.configure("2") do |config|
    config.vm.define "Ansible" do |vm_ansible|
        vm_ansible.vm.box = "centos/7"
        vm_ansible.vm.network "private_network", ip: "192.168.56.10"
        vm_ansible.vm.hostname = "Ansible"
        vm_ansible.vm.provision "shell", path: "ansible_provision.sh"            
        vm_ansible.vm.provider "virtualbox" do |v|
            v.name = "Ansible"
            v.memory = 4096
            v.cpus = 2
        end
    end

    config.vm.define "Jenkins" do |vm_jenkins|
        vm_jenkins.vm.box = "centos/7"
        vm_jenkins.vm.network "private_network", ip: "192.168.56.11"
        vm_jenkins.vm.hostname = "Jenkins"
        vm_jenkins.vm.provider "virtualbox" do |v|
            v.name = "Jenkins"
            v.memory = 1024
            v.cpus = 2
        end
    end   

    config.vm.define "Docker" do |vm_docker|
        vm_docker.vm.box = "ubuntu/focal64"
        vm_docker.vm.network "private_network", ip: "192.168.56.12"
        vm_docker.vm.hostname = "Docker"
        vm_docker.vm.provider "virtualbox" do |v|
            v.name = "Docker"
            v.memory = 512
            v.cpus = 1
        end
    end
    
    config.vm.define "Windows" do |vm_windows|
        vm_windows.config.vm.boot_timeout = 60
        vm_windows.vm.box = "Win10v22H2x64"
        vm_windows.vm.hostname = "Windows"
        vm_windows.vm.provider "virtualbox" do |v|
            v.name = "Windows"
            v.memory = 4096
            v.cpus = 2
        end
    end
end



