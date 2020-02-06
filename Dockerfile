FROM debian:stable-slim

RUN sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y gnupg git zsh vim sudo make

WORKDIR /usr/share/

# environmnet configuration
RUN echo "" >> ~/.bashrc
RUN echo "# custom" >> ~/.bashrc
RUN echo "## alias" >> ~/.bashrc
RUN echo "alias cp='cp -i'" >> ~/.bashrc
RUN echo "alias mv='mv -i'" >> ~/.bashrc
RUN echo "alias rm='rm -i'" >> ~/.bashrc
RUN echo "alias shred='shred -u -z -n 9'" >> ~/.bashrc

## Put a blank space (Hit spacebar from the keyboard) before any command. The command will not be recorded in history.
RUN export HISTCONTROL=ignorespace

## Automatically clear history at logout.
RUN echo "Automatically clear history at logout" >> ~/.bashrc
RUN echo "unset HISTFILE" >> ~/.bashrc

# vim configuration
RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
RUN sh ~/.vim_runtime/install_awesome_vimrc.sh

# git-secret
RUN git clone https://github.com/sobolevn/git-secret /usr/share/git-secret
WORKDIR /usr/share/git-secret/
RUN make build
RUN PREFIX="/usr/local" make install
WORKDIR /usr/share/
RUN find git-secret/ -type f -print0 | xargs -0 -I {} shred -uf {}
RUN rm -rf git-secret

# remove unusual software
RUN apt-get remove make

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

CMD ["/usr/zsh"]
