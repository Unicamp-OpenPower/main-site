---
title:  Installing spaCy on POWER8 and POWER9.
layout: page
date: 2018-05-19
author: Gustavo Salibi
---

<center><img src="./spacy-img/SpaCy_logo.svg" alt="Bazel Logo" width="40%"/></center>

<br>

[spaCy](https://spacy.io) is an open-source software library for advanced Natural Language Processing, written in Python and Cython. The library is published under the MIT license and currently offers statistical neural network models for English, German, Spanish, Portuguese, French, Italian, Dutch and multi-language NER, as well as tokenization for various other languages.

Its installation is very straightforward using the [pip](https://pypi.org/project/pip/) package manager. Entretando, você não obterá sucesso se tentar fazê-la em um processador Power. However, you will not succeed if you try to make it into a POWER processor. This is due to a problem with the headers of the Numpy library when using the pip. Thus, the easiest way to install spaCy is by using another package manager, [Conda](https://www.anaconda.com).

Conda is an open source, cross-platform, language-agnostic package manager and environment management system. It is released under the Berkeley Software Distribution License by Continuum Analytics.

------------
# Installing Python 3.7

To install spaCy, you will need to have python 3.7. To verify that you have it installed, simply use the command:
```
python3.7 --version
```

If you have not installed it, use the package manager of your system to install.
* Start by updating the packages and installing the prerequisites:
```
sudo apt update
sudo apt install software-properties-common
```

* Add the deadsnakes PPA to your sources list:
```
sudo add-apt-repository ppa:deadsnakes/ppa
```

* Once the repository is enabled, install Python 3.7 with:
```
sudo apt install python3.7
```

------------
# Installing Conda
**1.** Download the [Anaconda installer for POWER8 and POWER9](https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-ppc64le.sh).

**2.** Enter the following on the download directory:
```
bash Anaconda3-2019.03-Linux-ppc64le.sh
```
3. The installer prompts “In order to continue the installation process, please review the license agreement.” Click Enter to view license terms.

**4.** Using Enter, scroll to the bottom of the license terms and enter “Yes” to agree to them.

**5.** Click Enter to accept the default install location.

**6.** Enter "yes" to initialize Anaconda3 by running conda init.

**7.** Close and open your terminal window for the installation to take effect.
```
source ~/.bashrc.
```


------------
# Installing spaCy
You only need to use the following command:
```
conda install -c conda-forge spacy
```

