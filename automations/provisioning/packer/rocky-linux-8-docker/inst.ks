#version=RHEL8
ignoredisk --only-use=sda
# Partition clearing information
clearpart --none --initlabel
# Use graphical install
# graphical
# Use CDROM installation media

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --device=ens18 --noipv6 --activate
network  --hostname=pottersite-template01
#repo --name=AppStream --mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever
# Root password
rootpw Packer
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

user --name=potteradmin --groups=wheel --password=Packer --iscrypted

reboot


%packages --ignoremissing --excludedocs
@^minimal-environment
qemu-guest-agent


%end

%addon com_redhat_kdump --enable --reserve-mb='auto'
%end

%post

# sudo
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
echo 'potteradmin ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/potteradmin
chmod 440 /etc/sudoers.d/potteradmin

%end