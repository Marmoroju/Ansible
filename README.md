<h3>O <b><i>Ansible</b></i> irá se comunicar com os servidores remotos através de SSH. <br>
Não precisa de agente instalado nos servidores remotos, mas <br> 
para isso será necessário ter instalado o Python nos servidores (Workers) gerenciados pelo Control-Node</h3>
<hr>
<p>Saiba mais em: https://docs.ansible.com/ansible/latest/getting_started/introduction.html</p>

<h4><b><i>Passo a Passo - Entendendo o Ambiente</b></i></h4>

<p>1 - Dentro do diretório raiz Ansible estão os arquivos de configuração do Control-Node e<br>
dentro do diretório Workers estão as VM que serão gerenciadas pelo Ansible (Control-Node)</p>

<p>2 - A primeira etapa será iniciar o Control-Node para realizar sua configuração de inventário <br>
e gerar a chave de confiança. O Passo a passo está no tópico "<b><i>CONFIGURAÇÃO ANSIBLE</b></i>"</p>

<p>3 - Após gerar a hash da chave pública (id_rsa.pub) ela deverá ser adicionada no arquivo "workers_provision.sh" <br>
dentro do diretório "Workers"</p>

<p>4 - A segunda etapa será iniciar os Workers.</p> 
<p>5 - Reinicie o Control-Node ao término das configurações através do comando "vagrant reload --no-provision".</p>
<p>6 - Acesse a pasta Workers e inicie as outras máquinas virtuais.</p>
<p>Quando todas as configurações acima forem finalizadas, acesse o Control-Node e execute os comandos: </p>
<p>ansible -m ping all</p>
<p>ssh vagrant@worker_hostname</p>
<p>Através desses comandos é possível checar se o ambiente está pronto.</p>

<p>Obs.: A configuração da máquina Windows será realizada posteriormente.</p>

<br>
<hr>
<p> <b><i>OBS.:</i></b> A configuração inicial de cada servidor (Docker e Jenkins, p.ex.) poderia ser realizada através do próprio <b><i>VAGRANT</b></i>, mas <br>
o objetivo <b><i>AQUI</b></i> é realizar essa configuração incial através do <b><i>ANSIBLE</b></i>.<BR>
Com o Ansible, a VM precisa estar desligada para que seja realizado um novo provisionamento. Já com o Ansible <br>
esse provisionamento é realizado com a VM ligada.</p>
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


<h2>CONFIGURAÇÃO ANSIBLE</h2>
<p>Acesse a VM do Ansible e siga as instruções abaixo.</p>
<br>
<p> 1 - <b><i>Gerar chave de confiança:</b></i></p>
<p> 1.1 - Executar o comando "ssh-keygen" <br>
este comando irá gerar a chave privada "id_rsa" e a chave pública "id_rsa.pub" <br>
que estarão no diretório /home/vagrant/.ssh/ junto a authorized_keys.</p>
<br>

<p>2 - Após o comando será solicitado algumas informações, preeencha dessa forma:</p>
<p>2.1 - Será solicitado um nome e senha que poderá ser vazio. Apenas pressione o Enter até o final</p>

<p>3.1 - Acesse o diretório "/home/vagrant/.ssh", verifique se o arquivo id_rsa e <br>
id_rsa.pub foram criados. Se criou, e execute o comando "cat id_rsa.pub"</p>
<p>3.3 - Copie a hash completa (p.ex. [innicio da hash] ssh-rsa AAA...Hqj21 vagrant@ansible [fim da hash] ), <br>
pois ela será adicionada no "authorized_keys de cada Worker-Node</p>

<p>4 - Agora, <b>FORA</b> da VM acesse o diretório Workers, onde futuramente serão iniciadas as VMs e cole a hash no workers_provision.sh <br>
onde está escrito <i>"cole aqui a hash completa da chave pública id_rsa.pub"</i></p>

<p>5 - Para adicionar a chave pública individualmente precisa copiar e colar a hash dentro do arquivo authorized_keys <br>
da máquina virtual desejada. Ou criar um arquivo provision e fazer o reload. Ou simplesmente, <br>
copiar e colar o código abaixo no terminal da VM e pressionar "Enter".<br>
cat << EOT >> /home/vagrant/.ssh/authorized_keys <br>
"Hash" <br>
EOT</p>
<br>
<h3>Inventário host do Ansible Control-Node</h3>
<p>Pode conferir com o comando "cat /etc/hosts"</p>

<p>OPÇÃO 1 [Utilizada aqui]</p>
<p>Acrescentar diretamente os IPs e Hostname no arquivo de provisionamento através do EOT</p>

<p>OPÇÃO 2</p>
<p>Acrescentar diretamente os IPs e Hostname no arquivo host</p>
<p>1 - Em /etc/hosts será adicionado ao final do arquivo o IP e Hostname de cada servidor. <br>
Por exemplo, ao executar o comando "cat /etc/hosts" certamente a última linha será "127.0.1.1 Ansible Ansible" <br>
abaixo dela será adicionado os IPs e Hostnames dos Workers. <br>
No meu caso: <br>
127.0.1.1 Ansible Ansible <br>
192.168.56.11   Jenkins <br>
192.168.56.12   Docker <br></p>

<p>OPÇÃO 3</p>
<p>Criar um arquivo hosts que sempre será passado com o parâmetro "-i" nome_do_arquivo sempre que precisar configurar ou acessar outra VM.<br>
p.ex: "ansible -i hosts all -k -m ping". Porém, será adicionado somente os IPs e Hostnames desejados.</p>

<p>INVENTÁRIO DE GRUPOS</p>

<p>A criação de grupos no Inventário Host é a mágica do Ansible, pois ao invés <br>
de acessar servidor por servidor, se um grupo com n servidores foi criado será <br>
necessário apenas apontar a nova atualização ou configuração para aquele grupo.</p>
<br>
<p>Acesse o arquivo "hosts" dentro do diretório "/etc/ansible". Neste arquivo os grupos serão acrescentados bem no topo, como no exemplo abaixo:<p>
<p>
[Ubuntu] <br>
Docker<br>
</p>
<p>
[RedHat] <br>
Jenkins <br>
</p>
<p>
[Bancos] <br>
oracle <br>
Redis <br>
</p>
<p>
[Services] <br>
Jenkins <br>
Docker <br> 
</p>
<p>
[Web] <br>
Nginx <br>
Apache <br>
</p>
<p>No mesmo local também é possível criar um grupo composto de outros grupos, chamados de "CHILDREN", como no exemplo abaixo. <br>
Sempre que quiser atualizar apenas nesses grupos, basta apontar para "<b><i>noDB</b></i>", neste caso. </p>
<p>
[noDB:children] <br>
Services <br>
Web <br>
</p>

<hr>
<h3>Chave Privada de Confiança do Ansible Control-Node no arquivo "/etc/ansible/ansible.cfg"</h3>

<p>Quando foi gerada uma chave pública nos passos anteriores para adicionar no Workers <br>
também foi gerada uma chave privada, e será com ela que será realizada a autenticação <br>
do Control-Node com os Worker-Node.</p>
<p>Para configurar a chave pública será necessário acessar o diretório "/etc/ansible", <br>
abrir o arquivo "ansible.cfg".</p>
<p>Como root edite o arquivo ansible.cfg da seguinte maneira:</p>
<p>Com o editor "vi" é possível mostrar as linhas através do comando ":set number"</p>
<br>
<p>14 - Encontre a linha "#host_key_checking = False", (Linha 71), descomente.</p>
<br>
<p>2 - Encontre a linha "#private_key_file = /path/to/file" (Linha 136), descomente e troque o caminho <br>
para o local que foi gerada a chave privada. Provavelmente estará em "/home/vagrant"</p>
<p>2.1 - Em /home/vagrant procure o arquivo id_rsa sem ".pub" </p>
<p>2.2 - Agora, altere aquela linha como o exemplo: private_key_file = /home/vagrant/.ssh/id_rsa</p>
<P>2.3 - Pronto! quando fizer o acesso a partir do control-node para as workers a sua chave privada será passada como parâmetro</P>
<hr>




