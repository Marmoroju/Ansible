<h2>O Ansible se comunicará com os servidores remotos através de SSH.
Não precisa de agente instalado nos servidores remotos.
Mas é necessário instalar o Python nos servidores gerenciados pelo Control-Node</h2>
<hr>
<h3>Base box = Centos 7</h3>
<p>https://app.vagrantup.com/centos/boxes/7</p>

<h3>Base box = 20.04 LTS</h3>
<p>https://app.vagrantup.com/ubuntu/boxes/focal64</p>

<h3>Base box =  Windows 10 versão 22H2</h3>
<p>https://app.vagrantup.com/jtarpley/boxes/w10_22h2_base</p>
<hr>
<h3>Criar do zero uma Box do windows 10</h3>
<p>1 - Baixar a ISO do Windows 10</p>
<p>2 - Criar VM e instalar a ISO</p>
<p>3 - Alterar nome da VM para "VagrantPC" ou "Vagrant"</p>
<p>4 - Criar usuario e senha "vagrant"</p>
<p>5 - No terminal, navegue até o diretório onde a máquina virtual foi criada</p>
<br>
<p>6 - Execute o seguinte comando para criar a “box” do Vagrant:</p>
<p>6.1 - Precisa estar com a VM desligada. Caso contrário o comando irá forçar o desligamento.</p>
<p>6.2 - vagrant package --base nome_da_sua_máquina_virtual</p>
<p>6.3 - Isso criará um arquivo package.box no diretório atual.</p>
<p>6.4 - Ex.: vagrant package --base Vagrant</p>
<p>6.5 - A exportação da VM é um pouco demorada (Depndendo da configuração do PC).</p>
<p>6.6 - Logo após exportar, será realizada a compressão do arquivo que levará um tempo também.</p>
<p>6.7 - O Arquivo final terá em média 5GB a 6GB.</p>
<br>
<p>7 - Adicione a “box” à sua biblioteca do Vagrant:</p>
<p>7.1 - Execute o seguinte comando para adicionar a “box” à sua biblioteca do Vagrant:</p>
<p>7.2 - vagrant box add Win10v22H2x64 package.box</p>
<p>7.3 - Isso adicionará a “box” do Windows 10 à sua biblioteca "LOCAL" do Vagrant com o nome Win10v22H2x64.</p>
<br>
<p>8 - Crie um Vagrantfile para iniciar a máquina virtual:</p>
<p>8.1 - vagrant init Win10v22H2x64</p>
<br>
<p>9 - A VM Windows terá outro IP que está descrito no campo "Servidor DHCP IPv4"
em detalhes da conexão de rede em um segundo adaptador de rede.</p>



