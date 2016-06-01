---
title: Instalação de Seismic Unix e Cmp_toy em arquitetura Power 
layout: page 
date: 2016-05-20
author: Guilherme Lucas
---

# Tutorial de instalação do cmp_toy em Máquinas Power

Esse é um breve tutorial de como foi para instalar e rodar o código sísmico cmp_toy nas máquinas Power, acessado pelo sistema de MiniCloud. 
Todo o processo foi feito usando uma máquina com Ubuntu 16.04 instalado, mas também deve funcionar em máquinas com sistemas Debian Based.

## Resolução de problemas nos pacotes 
Ao logar na máquina, tive alguns problemas com pacotes quebrados. Para arrumar esse problema usei os comandos comandos do dpkg e do apt-get, respectivamente:

```
sudo dpkg --configure -a
sudo apt-get -f install
```

## Primeiros Softwares e Pacotes necessários
O primeiro software que precisei, foi o editor de texto Vim, muito poderoso e eficiente, ainda mais quando estamos acessando uma máquina remotamente. Para instalá-lo basta executar:
```
sudo apt-get install vim
```

Após copiar o meu .vimrc para a máquina remota, baixei os dois compiladores necessários para rodar o código. Pra esse, preciso do compilador de C e C++, e por preferências pessoais instalei o gcc e g++. Segue os comandos para instalação de cada um deles:

```
sudo apt-get install gcc
sudo apt-get install g++
```

Link do repositório do cmp_toy:
```
github.com/gga-cepetro/cmp
```

Durante a instalação é necessário rodar o CMake, que também não esta instalado. Para acertar esse problema, rode:

```
sudo apt-get install cmake
```
Vale lembrar que todos os comandos desde o início do desse tutorial devem ser feitos logado na máquina remota.

## Trocando arquivos remotamente e instalando do software
Como fazemos acesso às máquinas com o comando `ssh -p` , ou seja, acessamos por meio de uma porta específica, temos que executar o comando scp de maneira diferente também, para copiar um arquivo local para uma máquina remota. Nesse caso, queremos copiar o arquivo cmp_toy.tar.gz (você deve estar no diretório desse arquivo, ou seja, na sua máquina física e não logado nas máquinas remotas).

```
scp -P <numero da porta> cmp_toy.tar.gz  seu_usuario@host_remoto:/algum/diretorio/remoto
```

Agora, se conectado na máquina remota, e vá até o diretório onde mandou o arquivo. Voce deve encontrar o cmp_toy.tar.gz. Agora para instalá-lo, rode os seguintes comandos:

```
tar -xzf cmp_toy.tar.gz
cd cmp_toy
mkdir build
cd build
cmake ..
make 
```

Agora que a instalação do software foi feita com sucesso, precisamos testá-lo. Para isso, basta ir para o diretório pai e rodar o script de teste, que usa uma imagem pronta para teste.

```
cd ..
./test-cmp.sh
```

Após um tempinho, você deve receber uma saída que segue o seguinte padrão (não necessariamente com os mesmos números):

```
[100%] Processing CDP 300

real	0m59.968s
user	0m59.908s
sys	0m0.056s
```

Basicamente, os passos são esses. Tentei fazer esse tutorial da maneira mais detalhada possível. Se ainda restarem dúvidas, não exitem em entrar em contato.
