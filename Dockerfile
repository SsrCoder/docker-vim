FROM ubuntu

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive

COPY ./sources.list /etc/apt/sources.list
COPY ./.vimrc /root/.vimrc

RUN apt-get update && \
      apt-get install -y tzdata git cmake libncurses5-dev python-dev python3-dev build-essential curl golang npm && \
      git clone https://github.com/vim/vim.git --depth=1 && \
      cd vim && \
      ./configure \
          --with-features=huge \
          --enable-rubyinterp \
          --enable-luainterp \
          --enable-perlinterp \
          --enable-pythoninterp \
          --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ \
          --enable-python3interp=yes \
          --with-python3-config-dir=/usr/lib/python3.8/config-3.8-x86_64-linux-gnu/ \
          --enable-gui=gtk2 \
          --enable-cscope --prefix=/usr && \
      make && \
      make install && \
      cd /root && \
      rm -rf vim && \
      vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa" -V && \
      cd /root/.vim/plugged/YouCompleteMe && \
      python3 install.py --all && \
      apt-get autoclean && \
      apt-get clean && \
      apt-get autoremove


