#!/bin/bash -ex
#######################################################################
#                                                                     #
# Create Virtualbox VM                                                #
#                                                                     #
# This script creates a simple VM on the Digitesters VirtualBox host  #
# - one CPU, max. capacity 75% of host                                #
# - one network card bridged to LAN, cable connected                  #
# - audiocard to be selected in VM settings below (ac97 or none)      #
# - one SATA hard disk                                                #
# - one IDE DVD player                                                #
# - vrdp enabled (remote desktop) with no authentication              #
#                                                                     #
# Edit the VM settings below before running this script               #
#                                                                     #
#######################################################################
 
 
#######################################################################
### Start of VM Settings                                            ###
### note: do NOT put spaces around the equal sign                   ###
###                                                                 ###
#######################################################################
 
 
## The name of your VM
 
vmname="muki"
 
 
## VM operating system and ISO file
## Run the command "vboxmanage list ostypes |more" to find your Guest OS.
## Use the "ID:" as your ostype. Remember that everything is case-sensitive in linux.
 
ostype="Ubuntu_64"
isofile="/home/bogdanyilaura/Asztal/Telepítők/"
 
 
## Memory and video memory in MB
 
memory="2048"
vram="32"
 
 
## Hard disk size in MB
 
hddsize="8192"
 
 
## Vrde port range (RDP)
 
vrdeport="5041-5049"
 
 
## Audio card (select one of the following and comment-out the other)
 
#audio="alsa --audiocontroller ac97"
audio="none"
 
 
 
#######################################################################
### End of VM Settings                                              ###
### you shoudn't need to edit anything beyond this line             ###
###                                                                 ###
#######################################################################
 
 
 
#######################################################################
### Start of script                                                 ###
###                                                                 ###
#######################################################################
 
hddfile=/home/bogdanyilaura/VirtualBoxMVs/${vmname}/${vmname}.vdi
clear
 
# Create the VM
vboxmanage createvm --name $vmname --ostype $ostype --register
 
# Set memory, vram, audio and vdre port range
vboxmanage modifyvm $vmname --memory $memory --vram $vram --acpi on --ioapic on --cpus 1 --cpuexecutioncap 75 --rtcuseutc on --cpuhotplug on --pae on --hwvirtex on
vboxmanage modifyvm $vmname --nic1 bridged --bridgeadapter1 enp2s0 --cableconnected1 on
vboxmanage modifyvm $vmname --audio $audio
vboxmanage modifyvm $vmname --vrde on --vrdeport $vrdeport --vrdeauthtype null
 
 
# Create and attach HDD and SATA controller
vboxmanage createhd --filename $hddfile --size $hddsize
vboxmanage storagectl $vmname --name "SATA controller" --add sata
vboxmanage storageattach $vmname --storagectl "SATA controller" --port 0 --device 0 --type hdd --medium $hddfile
 
# Create IDE controller and attach DVD
vboxmanage storagectl $vmname --name "IDE controller" --add ide
vboxmanage storageattach $vmname --storagectl "IDE controller"  --port 0 --device 0 --type dvddrive --medium $isofile
 
#######################################################################
### End of script                                                   ###
###                                                                 ###
#######################################################################
