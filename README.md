<h3>O <strong>Ansible</strong> irá se comunicar com os servidores remotos através de SSH. <br>
Não precisa de agente instalado nos servidores remotos, mas <br> 
antes será necessário ter instalado o Python nos servidores gerenciados pelo Control-Node</h3>
<hr>
<h4><strong>Entendendo os diretórios antes de iniciar o ambiente.</strong></h4>
<p>1 - Dentro do diretório raiz Ansible está os arquivos de configuração do Control-Node e<br>
dentro do diretório Workers estão as VM que serão gerenciadas pelo Ansible (Control-Node)</p>
<p>2 - Primeiro será iniciado o Control-Node para primeiro realizar sua configuração de inventário <br>
e gerar a chave de autorização. Passo a passo está no tópico "<strong>Configuração Ansible</strong>"</p>
<p>3 - Após gerar a hash com a chave de autorização, ela deverá ser adicionada no arquivo "workers_provision.sh" <br>
dentro do diretório "Workers"</p>
<p>4 - Pronto! A partir do diretório Workers após ter gerado a , inicie as VMs</p> 
<br>
<h4>Obs.: A configuração inicial de cada servidor (Docker e Jenkins, p.ex.) poderia ser realizada através do próprio <strong>VAGRANT</strong>, mas <br>
o objetivo <strong>AQUI</strong> é realizar essa configuração incial através do <strong>ANSIBLE</strong>.<BR>
Com o Ansible, a VM precisa estar desligada para que seja realizado um novo provisionamento. Já com o Ansible <br>
esse provisionamento é realizado com a VM ligada.</h4>
<hr>
<br>
<h3>Base box = Centos 7</h3>
<p>https://app.vagrantup.com/centos/boxes/7</p>

<h3>Base box = Ubuntu 20.04 LTS</h3>
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

<h2>Cofiguração Ansible</h2>
<h3>Configuração do Ansible Control-Node</h3>
<p>Após provisionar a VM Ansible (ansible_provision.sh) será necessário <br>
acessar a VM do Ansible e fazer as configurações do host/inventário <br>
e gerar a chave de confiança.</p>
<p> 1 - <strong>Gerar chave de confiança:</strong></p>
<p> 1.1 - Executar o comando "ssh-keygen" <br>
este comando irá gerar a chave privada "id_rsa" e a chave pública "id_rsa.pub" <br>
que estarão no diretório ~/.ssh/</p>
<p>2 - Após o comando será solicitado algumas informações, preeencha dessa forma:</p>
<p>2.1 - Será solicitado um nome que poderá ser vazio, apenas pressionando o Enter, ou <br>
acrescente um nome de sua preferencia, como Ansible, por exemplo.
<p> 2.2 - Será solicitado uma senha que pode ser de sua preferência ou vazia que <br>
basta pressionar novamente o Enter. Logo após a confirmação da senha.</p>
<p>2.3 - </p>
<p>3 - Execute um destes comandos para capturar o hash completo: </p>
<p>3.1 - "cat id_rsa.pub" caso não tenha dado nome ao arquivo quando foi solicitado.</p>
<p>3.2 - "cat Nome_do_Arquivo.pub" caso tenha dado nome ao arquivo quando foi solicitado, p.ex. "cat Ansible.pub"</p>
<p>3.3 - Copie a hash completa (p.ex. [innicio da hash] ssh-rsa AAA...Hqj21 vagrant@Ansible [fim da hash] ), <br>
pois ela será adicionada no "authorized_keys de cada Worker-Node</p>
<p>3.4 - Agora cole a hash no workers_provision.sh dentro do diretório Workes.</p>




