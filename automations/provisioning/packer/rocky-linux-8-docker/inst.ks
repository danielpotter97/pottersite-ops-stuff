#version=RHEL8
# Partition clearing information
clearpart --none --initlabel
# Use graphical install
# graphical
# Use CDROM installation media

# Keyboard layouts
keyboard --vckeymap=hu --xlayouts='hu'
# System language
lang en_US.UTF-8

user --name=potteradmin --groups=wheel --password=

# Network information
network --bootproto=dhcp --device=ens18 --noipv6 --activate
#repo --name=AppStream --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever
# Root password
rootpw
# Run the Setup Agent on first boot
firstboot --disabled
# Do not configure the X Window System
skipx
# System services
services --disabled="kdump" --enabled="sshd,chronyd"
firewall --disabled
selinux --disabled
# System timezone
timezone Etc/UTC --isUtc
# Disk partitioning information
part / --fstype="xfs" --grow --size=6144
part swap --fstype="swap" --size=512

eula --agreed
services --enabled=NetworkManager,sshd

reboot


%packages
@^minimal-environment
openssh-server
openssh-clients
sudo
kexec-tools


# unnecessary firmware
-aic94xx-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'
%end

%post


echo "potteradmin      ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

#install necessary packages and enable qemu agent
yum -y install curl wget unzip python3 python3-libselinux qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

%end
