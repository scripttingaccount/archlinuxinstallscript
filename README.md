# archlinuxinstallscript

proceed with caution. archlinux installation script one and two tested against vagrant &amp;&amp; virtualbox
more testing and debugging neccesary 

These two scripts are meant to be utilitzed alongside not from within an arch linux iso usb
havent been tested together or in tandem, however in theory should work aside from minor bugs

first script installs an arch linux distribution with a seperate usb for an encrypted boot paritition
second script then configures the new environment to install everthing up until a dwm st and tmux configuration
systemctl units files are used to put dwm st and tmux together as systemd user services 
upon logging in as a newly created user

utilize systemctl --user start <unit_file_to_be> in order to begin all services again dwm st tmux. 

xorg@.socket
xorg@.service
dwm.service
st.service
tmux.service

upon first inspection tmux will appear not to be running however it's in the background 
running tmux or (and then) tmux ls should give you the session already open in as well as creating a new one
this is good for latter session automation

still needs
fixing auto launch dwm from dwm.service
session automation 
persistent firewall configuration/service
hardening as per the arch wiki

A.M.S wrote this 
