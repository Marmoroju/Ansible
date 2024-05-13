# O Ansible se comunica com os servidores remotos através de SSH.
# Não precisa de agente instalado nos servidores remotos.
# Mas é necessário instalar o Python nos servidores gerenciados pelo Control-Node

# Base box = Centos 7
https://app.vagrantup.com/centos/boxes/7

# Base box = 20.04 LTS
https://app.vagrantup.com/ubuntu/boxes/focal64

# Base box =  Windows 10 versão 22H2
https://app.vagrantup.com/jtarpley/boxes/w10_22h2_base

# Criar do zero uma Box do windows 10
1 - Baixar a ISO do Windows 10 
2 - Criar VM e instalar a ISO
3 - Alterar nome da VM para "VagrantPC" ou "Vagrant"
4 - Criar usuario e senha "vagrant"
5 - No terminal, navegue até o diretório onde a máquina virtual foi criada

6 - Execute o seguinte comando para criar a “box” do Vagrant:
6.1 - Precisa estar com a VM desligada. Caso contrário o comando irá forçar o desligamento.
6.2 - vagrant package --base nome_da_sua_máquina_virtual
6.3 - Isso criará um arquivo package.box no diretório atual.
6.4 - Ex.: vagrant package --base Vagrant
6.5 - A exportação da VM é um pouco demorada (Depndendo da configuração do PC).
6.6 - Logo após exportar, será realizada a compressão do arquivo que levará um tempo também.
6.7 - O Arquivo final terá em média 5GB a 6GB.

7 - Adicione a “box” à sua biblioteca do Vagrant:
7.1 - Execute o seguinte comando para adicionar a “box” à sua biblioteca do Vagrant:
7.2 - vagrant box add Win10v22H2x64 package.box
7.3 - Isso adicionará a “box” do Windows 10 à sua biblioteca "LOCAL" do Vagrant com o nome Win10v22H2x64.

8 - Crie um Vagrantfile para iniciar a máquina virtual:
8.1 - vagrant init Win10v22H2x64

9 - A VM Windows terá outro IP que está descrito no campo "Servidor DHCP IPv4"
em detalhes da conexão de rede em um segundo adaptador de rede.



