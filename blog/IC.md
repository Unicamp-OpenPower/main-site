---
title: Instalação de Seismic Unix e Cmp_toy em arquitetura Intel
layout: page 
date: 2016-05-20
author: Guilherme Lucas
---
# Instalação do SU e do Cmp_toy na máquina pessoal

## Instalação do SU
Seismic Unix é um conjunto de ferramentas extremamente úteis para o processamento de dados sísmicos. Para instalá-lo no Ubuntu 14.04, precisei baixar algumas bibliotecas. Segue quais são e como instalá-las:

<X11/Xlib.h> 
```
sudo apt-get install libx11-dev
```

<X11/Intrinsic.h>
```
<X11/Intrinsic.h> - sudo apt-get install libxt-dev
```

Também precisamos do CMake para completar a instalação do Seismic Unix. Rode:
```
sudo apt-get install cmake
```

Link do repositório do cmp_toy:
```
github.com/gga-cepetro/cmp
```

Agora para realmente terminar a instalção, basta rodar os seguintes comandos:

```
install_dir=~/src/cwp
mkdir -p $install_dir && cd $install_dir
export CWPROOT=$PWD
echo "export CWPROOT=$PWD" >> ~/.bashrc
echo 'export PATH=$PATH:$CWPROOT/bin' >> ~/.bashrc
wget ftp://ftp.cwp.mines.edu/pub/cwpcodes/cwp_su_all_44R1.tgz
tar zxf cwp_su_all_44R1.tgz
cd src
sed -i 's/^XDRFLAG/#XDRFLAG/' Makefile.config
make install ; make xtinstall
```

Agora para testar se o software, basta executar
```
suplane | suximage
```

Uma imagem com três planos deve ser apresentada. Ela parece ser um pouco esquista, a princípio, mas se uma janela com uma imagem foi aberta, então a instalação foi realizada com sucesso.

## Instalação do cmp_toy
Agora para instalar o cmp_toy e obter as curvas desejadas, precisamos executar os seguintes comandos, após obter o cmp_toy.tar.gz :
```
tar -xzf cmp_toy.tar.gz
mkdir build
cd build
cmake ..
make
```
Agora que o software está instalado, vamos testá-lo. É necessário mudar para o diretório pai desse que estamos e rodar o script de teste, que usa uma imagem criada extamente para esse teste:

```
cd ..
./test-cmp.sh
```

A saída desse comando (ao completar 100%) deve seguir o seguinte padrão, com números possivelmente diferentes:

```
[100%] Processing CDP 300
real	0m56.573s
user	0m56.589s
sys	0m0.008s
```

Agora, para testar a imagem gerada, basta rodar o seguinte comando:
```
suximage < cmp.stack.su
```

O output desse comando deve ser uma imagem com o plot de algumas curvas. 

Post escrito por Guilherme Lucas. 
Mais um pouco do meu trabalho no meu Github https://github.com/Guilhermeslucas .
