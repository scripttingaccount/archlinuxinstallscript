#!/bin/bash
echo -e "[ enter password for root account: ] "
passwd root
sudo pacman -S base-devel
sudo pacman -S vim
sudo pacman -S git
sudo pacman -S ranger
sudo pacman -S xorg-server
sudo pacman -S libxft
sudo pacman -S libxinerama
sudo pacman -S dmenu
sudo pacman -S cmus
sudo pacman -S alsa-utils
sudo pacman -S xorg-xinit
sudo pacman -S tmux
sudo pacman -S gvim
sudo pacman -S ttf-anonymous-pro
echo -e "[ setting new user account: ] "
read -p "[ please enter user name new user account: ] " USER_NAME
useradd -m -s /bin/bash ${USER_NAME}
passwd ${USER_NAME}
cat /etc/passwd
export EDITOR=vim visudo
sed -i "80i${USER_NAME} ALL=(ALL) ALL" /etc/sudoers 
sudo -u ${USER_NAME} mkdir /home/${USER_NAME}/configuration
cd /home/${USER_NAME}/configuration
sudo -u ${USER_NAME} git clone https://git.suckless.org/dwm
sudo -u ${USER_NAME} git clone https://git.suckless.org/st
sudo -u ${USER_NAME} git clone https://github.com/scripttingaccount/archlinuxbash.git  
cd /home/${USER_NAME}/configuration/dwm
sudo -u ${USER_NAME} git branch config
sudo -u ${USER_NAME} git checkout config
#download from github configuration files for dwm
sudo -u ${USER_NAME} cp -r /home/${USER_NAME}/configuration/archlinuxbash/dwm.config.def.h /home/${USER_NAME}/configuration/dwm
sudo -u ${USER_NAME} mv /home/${USER_NAME}/configuration/dwm/dwm.config.def.h /home/${USER_NAME}/configuration/dwm/config.def.h
sudo -u ${USER_NAME} cd /home/${USER_NAME}/configuration/st
sudo -u ${USER_NAME} git branch config
sudo -u ${USER_NAME} git checkout config
sudo -u ${USER_NAME} cp -r /home/${USER_NAME}/configuration/archlinuxbash/st.config.def.h /home/${USER_NAME}/configuration/st
sudo -u ${USER_NAME} mv /home/${USER_NAME}/configuration/st/st.config.def.h /home/${USER_NAME}/configuration/st/config.def.h
#sudo -u ${USER_NAME} chown -R ${USER_NAME} /home/${USER_NAME}/
cd /home/${USER_NAME}/configuration/dwm
sudo -u ${USER_NAME} make clean && make clean install
cd /home/${USER_NAME}/configuration/st
sudo -u ${USER_NAME} make clean && make clean install
cd /home/${USER_NAME}
sudo -u ${USER_NAME} cp -r /home/${USER_NAME}/configuration/archlinuxbash/.config /home/${USER_NAME}/
#######################################
#sudo -u ${USER_NAME} mkdir -p /home/${USER_NAME}/.config/ranger/colorschemes
#sudo -u ${USER_NAME} cp -r /home/${USER_NAME}/configuration/archlinuxbash/rangerblackbiclighter.py /home/${USER_NAME}/.config/ranger/colorschemes/
#sudo -u ${USER_NAME} mv /home/${USER_NAME}/configuration/archlinuxbash/rangerblackbiclighter.py /home/${USER_NAME}/.config/ranger/colorschemes/blackbiclighter.py
######################################
#sudo -u ${USER_NAME} chown -R ${USER_NAME} /home/${USER_NAME}
cd /home/${USER_NAME}
cp -r /etc/vimrc /home/${USER_NAME}/.vimrc
sudo -u ${USER_NAME} mkdir -p /home/${USER_NAME}/.vim/colors/
sudo -u ${USER_NAME} cp -r /home/${USER_NAME}/configuration/archlinuxbash/vimcorporation_red.vim /home/${USER_NAME}/.vim/colors/ 
cp -r /home/${USER_NAME}/configuration/archlinuxbash/vimcorporation_red.vim /usr/share/vim/vim82/colors/
mv /usr/share/vim/vim82/colors/vimcorporation_red.vim /usr/share/vim/vim82/colors/corporation_red.vim
sed -i "\$acolorscheme corporation_red" /etc/vimrc
sudo -u ${USER_NAME} sed -i "\$acolorscheme corporation_red" /home/${USER_NAME}/.vimrc
cp -r /etc/X11/xinit/xinitrc /home/${USER_NAME}/.xinitrc
sudo -u ${USER_NAME} sed -i '/term &/d' /home/${USER_NAME}/.xinitrc
sudo -u ${USER_NAME} sed -i '/xterm -geometry 80x20+494-0 &/d' /home/${USER_NAME}/.xinitrc
sudo -u ${USER_NAME} sed -i '/xclock -geometry 50x50-1+1 &/d' /home/${USER_NAME}/.xinitrc
sudo -u ${USER_NAME} sed -i '/xterm -geometry 80x50+494+51 &/d' /home/${USER_NAME}/.xinitrc
sudo -u ${USER_NAME} sed -i '/xterm -geometry 80x66+0+0 -name login/d' /home/${USER_NAME}/.xinitrc
sudo -u ${USER_NAME} sed -i "\$aexec dwm/" /home/${USER_NAME}/.xinitrc
cat <<EOT >> /etc/X11/Xwrappper.config
allowed_users=anybody
needs_root_rights=yes
EOT












