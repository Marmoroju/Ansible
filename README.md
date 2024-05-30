# ANSIBLE
O `Ansible` irá se comunicar com os servidores remotos através de SSH.
Não precisa de agente instalado nos servidores remotos, mas
para isso será necessário ter instalado o Python nos servidores `Workers` gerenciados pelo Control-Node

* Saiba mais em: https://docs.ansible.com/ansible/latest/getting_started/introduction.html
<hr>

### Base box = Centos 7
- https://app.vagrantup.com/centos/boxes/7

### Base box = Ubuntu 20.04 LTS
- https://app.vagrantup.com/ubuntu/boxes/focal64

### Base box =  Windows 10 versão 22H2
- https://app.vagrantup.com/jtarpley/boxes/w10_22h2_base

<hr>

## Passo a Passo - Entendendo o Ambiente

1. Dentro do diretório Control-Node estão os arquivos de configuração do Ansible e
dentro do diretório Workers estão os arquivos de configuração das VM que serão gerenciadas pelo Ansible (Control-Node)

2. A primeira etapa será iniciar o Control-Node para realizar sua configuração de inventário 
e gerar a chave de confiança. O Passo a passo está no tópico `CONFIGURAÇÃO ANSIBLE`

3. Após gerar a hash da chave pública `id_rsa.pub` ela deverá ser adicionada no arquivo `workers_provision.sh`
dentro do diretório Workers.

4. A segunda etapa será iniciar os Workers. 
5. Reinicie o Control-Node ao término das configurações através do comando `vagrant reload --no-provision`
6. Acesse a pasta Workers e inicie as outras máquinas virtuais.
Quando todas as configurações acima forem finalizadas, acesse o Control-Node e execute os comandos: 

```bash
# Através desses comandos é possível checar se o ambiente está pronto.
$ ansible -m ping all
$ ssh vagrant@worker_hostname
```

<hr>

`OBS.:` A configuração inicial de cada servidor (Docker e Jenkins, p.ex.) poderia ser realizada através do próprio VAGRANT, mas 
o objetivo AQUI é realizar essa configuração incial através do ANSIBLE.
Com o Ansible, a VM precisa estar desligada para que seja realizado um novo provisionamento. Já com o Ansible 
esse provisionamento é realizado com a VM ligada.
<hr>

# CONFIGURAÇÃO ANSIBLE
Acesse a VM do Ansible e siga as instruções abaixo.

## Passo 1: Gerar Chave de Confiança:

1. Executar o comando `$ ssh-keygen`
este comando irá gerar a chave privada `id_rsa` e a chave pública `id_rsa.pub` 
que estarão no diretório `/home/vagrant/.ssh/` junto a authorized_keys.

2. Após o comando será solicitado algumas informações, preeencha dessa forma:
- Será solicitado um nome e senha que poderá ser vazio. Apenas pressione o Enter até o final

3. Acesse o diretório `/home/vagrant/.ssh`, verifique se o arquivo id_rsa e 
id_rsa.pub foram criados. Se criou, e execute o comando cat id_rsa.pub
- Copie a hash completa (p.ex. [início da hash] `ssh-rsa AAA...Hqj21 vagrant@ansible` [fim da hash] ), 
pois ela será adicionada no authorized_keys de cada Worker-Node

4. Agora, FORA da VM acesse o diretório Workers, onde futuramente serão iniciadas as VMs e cole a hash no workers_provision.sh, substituindo onde está
escrito `hash`, como no item 6 abaixo.

5. Para adicionar a chave pública individualmente precisa copiar e colar a hash dentro do arquivo authorized_keys 
da máquina virtual desejada. Ou criar um arquivo provision e fazer o reload. Ou simplesmente, 
copiar e colar o código abaixo no terminal da VM e pressionar Enter.

```bash
$ cat << EOT >> /home/vagrant/.ssh/authorized_keys 
hash 
EOT
```

## Passo 2: INVENTÁRIO
- Inventário host do Ansible Control-Node pode ser conferido com o comando `$ cat /etc/hosts`

### OPÇÃO 1 [Utilizada aqui]
Acrescentar diretamente os IPs e Hostname no arquivo de provisionamento através do EOT

### OPÇÃO 2
Acrescentar diretamente os IPs e Hostname no arquivo host
1. Em `/etc/hosts` será adicionado ao final do arquivo o IP e Hostname de cada servidor. 
Por exemplo, ao executar o comando `$ cat /etc/hosts` certamente a última linha será `127.0.1.1 Ansible Ansible`
abaixo dela será adicionado os IPs e Hostnames dos Workers. 
No meu caso: 

```bash
127.0.1.1 Ansible Ansible 
192.168.56.11   Jenkins 
192.168.56.12   Docker 
```

### OPÇÃO 3
Criar um arquivo hosts que sempre será passado com o parâmetro -i nome_do_arquivo sempre que precisar configurar ou acessar outra VM.
p.ex: `ansible -i hosts all -k -m ping`. Porém, será adicionado somente os IPs e Hostnames desejados.

### Passo 3: INVENTÁRIO DE GRUPOS

A criação de grupos no Inventário Host é a mágica do Ansible, pois ao invés 
de acessar servidor por servidor, se um grupo com n servidores foi criado será 
necessário apenas apontar a nova atualização ou configuração para aquele grupo.

Acesse o arquivo hosts dentro do diretório `/etc/ansible`. Neste arquivo os grupos serão acrescentados bem no topo, como no exemplo abaixo:

```bash
[Ubuntu] 
Docker

[RedHat] 
Jenkins 

[Bancos] 
oracle 
Redis 

[Services] 
Jenkins 
Docker  

[Web] 
Nginx 
Apache

# No mesmo local também é possível criar um grupo composto de outros grupos, chamados de CHILDREN, como no exemplo abaixo. 
# Sempre que quiser atualizar apenas nesses grupos, basta apontar para noDB, neste caso. 

[noDB:children] 
Services 
Web 
```
<hr>

## Passo 4: Chave Privada de Confiança do Ansible Control-Node no arquivo /etc/ansible/ansible.cfg

Quando foi gerada uma chave pública nos passos anteriores para adicionar no Workers 
também foi gerada uma chave privada, e será com ela que será realizada a autenticação 
do Control-Node com os Worker-Node.
Para configurar a chave pública será necessário acessar o diretório `/etc/ansible`, 
abrir o arquivo ansible.cfg.
Como root edite o arquivo `ansible.cfg` da seguinte maneira:
Com o editor vi é possível mostrar as linhas através do comando `:set number`

1. Encontre a linha 71 `#host_key_checking = False` e descomente.

2. Encontre a linha 136 `#private_key_file = /path/to/file`, descomente e troque o caminho 
para o local que foi gerada a chave privada. Provavelmente estará em /home/vagrant
- Em `/home/vagrant` procure o arquivo `id_rsa` sem `.pub` 
- Agora, altere aquela linha como o exemplo: `private_key_file = /home/vagrant/.ssh/id_rsa`
- Pronto! quando fizer o acesso a partir do control-node para as workers a sua chave privada será passada como parâmetro

<hr>

# CONFIGURAÇÃO WINDOWS

## Criar do zero uma Box do windows
1. Baixar a ISO do Windows
2. Criar VM e instalar a ISO
3. Alterar nome da VM para `VagrantPC` ou `Vagrant`
4. Criar usuario e senha vagrant
5. No terminal, navegue até o diretório onde a máquina virtual foi criada.
`Obs.:` neste ponto, antes de proseguir para criação da `BOX`, pode ser primeiramente
configurado o `WinRm' para que as suas outras bases já contenham a configuração para
receber os comandos do Ansible.

6. Execute o seguinte comando para criar a `Box do Vagrant`:
- Precisa estar com a VM desligada. Caso contrário o comando irá forçar o desligamento.
- `vagrant package --base nome_da_sua_máquina_virtual`
- Isso criará um arquivo package.box no diretório atual.
- Ex.: `vagrant package --base Vagrant`
- A exportação da VM é um pouco demorada (Depndendo da configuração do PC).
- Logo após exportar, será realizada a compressão do arquivo que levará um tempo também.
- O Arquivo final terá em média 5GB a 6GB.

7. Adicione a box à sua biblioteca do Vagrant:
- Execute o seguinte comando para adicionar a “box” à sua biblioteca do Vagrant:
- `vagrant box add Win10v22H2x64 package.box`
- Isso adicionará a box do Windows 10 à sua biblioteca LOCAL do Vagrant com o nome Win10v22H2x64.

8. Crie um Vagrantfile para iniciar a máquina virtual:
- `vagrant init Win10v22H2x64`

## Habilitar WinRm [Windows Remote Manager]

- Saiba mais em: https://docs.ansible.com/ansible/latest/collections/ansible/windows/index.html

- `Obs.:` Os passos a seguir podem ser realizados antes de criar a imagem na base do Vagrant.

1. Habilitar no VirtualBox as opções `Bi-direcional` de `Área de Transferência Compartilhada`e `Arrastar e Soltar` 

2. Habilitar o `Adapdator 2` da Placa de Rede como `Placa de rede exclusiva de hospedeiro (host-only)`,
`Modo Promíscuo` manter recusado.

3. O IP da VM Windows será o valor do `Servidor DHCP IPv4`

4. Acesse a VM Windows, abra o PowerShell, caso esteja instalado e execute o comando `$PSVersiontable`, caso a versão seja `>=7` será preciso baixar uma nova versão.

5. Na VM Windows, acesse o navegador e `realize o download e instalação` da versão atual do PowerShell compatível com seu sistema operacional.
- `Link:` https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4

6. 









