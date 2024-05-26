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
end