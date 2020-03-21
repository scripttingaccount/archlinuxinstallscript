#!/bin/bash
## script initial installation archlinux using lvm on luks alongside detached /boot via seperate drive
contains_element(){ 
	#check if an element exist in a string
	for e in "${@:2}"; do [[ $e == $1 ]] && break; done;
}

pause_function(){
	print_line 
	if [[ AUTOMATIC_MODE -eq 0 ]]; then
		read -e -sn 1 -p "Press enter to continue..."
	fi
} 

print_line(){
	printf "%$(tput cols)s\n"|tr ' ' '-'
} 

select_device(){
	device_list=(`lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
	PS3="$prompt1"
	echo -e "Attached Devices /dev/sdx:\n"
	lsblk -lnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,129,130,131,132,133,134,135,259 | awk '{print $1, $4, $6, $7}'| column -t 
	echo -e "\n"
	echo -e "Select Device:\n"
	select device in "${device_list[@]}"; do 
		if contains_element "${device}" "${device_list[@]}"; then
			break
		lz /else
			echo -e "invalid_option function:\n"
		fi
	done
	selected_device=$device
	echo -e $selected_device
}


#select_random(){
#	random_list=("/dev/random" "/dev/urandom");
#	PS3="$prompt1"
#	select random in "${random_list[@]}"; do
#		if contains_element "${random}" in "${random_list[@]}"; then
#			break
#		else
#			echo -e "invalid_option function\n:"
#		fi
#	done
#	random=${random}
#	echo -e "$random"
#}

#select_type(){
#	type_list=("luks" "luks1" "luks2" "plain" "loopaes" "tcrypt");
#	PS3="$prompt1"
#	select type in "${type_list[@]}"; do
#		if contains_element "$type" in "${type_list[@]}"; then
#			break
#		else
#			echo -e "invalid_option function\n:"
#		fi
#	done
#	type=${type}
#	echo -e "$type"
#}

wipe_device(){
	select_device
	sgdisk -z $selected_device
	crypt_chosen=$selected_device
	#echo -e "here is the man page for cryptsetup"
	#man cryptsetup
	#cryptsetup wipe selected device
	echo -e "#####################################################################################################"
	echo -e "cryptsetup will open a container on selected then container will be wiped"
	echo -e "#####################################################################################################"
	echo -e "\n"
	echo -e "#####################################################################################################"
	echo -e "\n"
	echo -e "\n"
	echo -e "\n"
	echo -e "#####################################################################################################"
	echo -e "please input selection decisions for cryptsetup command"	
	echo -e "#####################################################################################################"
	select_cipher(){
		echo -e "select proper cipher"
		cipher_list=("aes-xts-plain64" "AES256" "AES192" "AES" "SHA256" "SHA512")
		PS3="$prompt1"
		select cipher in "${cipher_list[@]}"; do
			if contains_element "${cipher}" "${cipher_list[@]}"; then
				break
			else
				echo -e "invalid_option function:\n"
			fi
		done
		cipher=${cipher}
	echo -e "#####################################################################################################"
		echo -e "$cipher"
	echo -e "#####################################################################################################"
		# need function select only cipher name out of less selection
	}		

	select_hash(){
			echo -e "select proper hash"
			hash_list=("sha512")
			PS3="$prompt1"
			select hash in "${hash_list[@]}"; do
				if contains_element "${hash}" "${hash_list[@]}"; then
					break
				else 
					echo -e "invalid_option function:\n"
				fi
			done
			hash=${hash}
	echo -e "####################################################################################################"
		echo -e "$hash"
	echo -e "####################################################################################################"
		}



	select_keysize(){
		read -p "please enter an appropriate keysize: " key_size
	}
	echo -e "##################################################################################################"
	echo -e "enter cryptsetup container name:" crypt_name
	echo -e "##################################################################################################"
	read -p "enter cryptsetup container name: " crypt_name
	select_type
	select_cipher
	select_hash
	select_keysize
	echo -e "##################################################################################################"
	cryptsetup -v --cipher $cipher --key-size $key_size --hash $hash --use-random luksFormat $crypt_chosen
	echo -e "##################################################################################################"
	cryptsetup open $crypt_chosen $crypt_name
	echo -e "##################################################################################################"
	dd if=/dev/zero of=/dev/mapper/${crypt_name} status=progress
	echo -e "##################################################################################################"
	echo -e "closing wipe container"
	echo -e "##################################################################################################"
	cryptsetup close /dev/mapper/${crypt_name}
	echo -e "container closed"
	echo -e "##################################################################################################"

}
#wipe_device
#wipe_device

	partition_usb(){
	select_device
	for i in ${selected_device}
	do
		sgdisk ${selected_device}
		sgdisk -n 1:0:+512M -t 1:EF00 -p ${selected_device}
		sgdisk -n 2:0:+200M -t 2:8300 -p ${selected_device}
		sgdisk --largest-new=num -p ${selected_device}
	done
	}
	partition_usb

	select_device_partition(){
	device_list=(`fdisk -l | grep '^/dev' | cut -d ' ' -f1`);
	PS3="$prompt1"
	echo -e "Attached Devices /dev/sdx:\n"
	lsblk -lnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,129,130,131,132,133,134,135,259 | awk '{print $1, $4, $6, $7}'| column -t 
	echo -e "\n"
	echo -e "Select Device:\n"
	select device in "${device_list[@]}"; do 
		if contains_element "${device}" "${device_list[@]}"; then
			break
		lz /else
			echo -e "invalid_option function:\n"
		fi
	done
	selected_device_partition=$device
	echo -e $selected_device
	}	

	cryptsetup_usb(){
	select_device_partition
	crypt_chosen_usb=${selected_device_partition}
	select_cipher(){
		echo -e "select proper cipher"
		cipher_list=("aes-xts-plain64")
		PS3="$prompt1"
		select cipher in "${cipher_list[@]}"; do
			if contains_element "${cipher}" "${cipher_list[@]}"; then
				break
			else
				echo -e "invalid_option function:\n"
			fi
		done
		cipher=${cipher}
	echo -e "#####################################################################################################"
		echo -e "$cipher"
	echo -e "#####################################################################################################"
		# need function select only cipher name out of less selection
	}		


	#select_type(){
	#	type_list=("luks");
	#	PS3="$prompt1"
	#	echo -e "Please select type option"
	#	select OPT in "${type_list[@]}"; do
	#		if contains_element "$OPT" in "${type_list[@]}"; then
	#			break
	#		else
	#			echo -e "invalid_option function\n:"
	#		fi
	#	done
	#	type=$OPT
	#echo -e "####################################################################################################"
	#	echo -e "$type"
	#echo -e "####################################################################################################"
	#}

	select_keysize(){
		keysize_list=("256" "512");
			PS3="$prompt1"
			echo -e "please select wanted keysize"
			select OPT in "${keysize_list[@]}"; do
				if contains_element "$OPT" in "${keysize_list[@]}"; then
					break
				else
					echo -e "invalid option selected"
				fi
			done
			key_size=${OPT}
	}

	select_hash(){
			echo -e "select proper hash"
			hash_list=("sha256" "sha512")
			PS3="$prompt1"
			select hash in "${hash_list[@]}"; do
				if contains_element "${hash}" "${hash_list[@]}"; then
					break
				else 
					echo -e "invalid_option function:\n"
				fi
			done
			hash=${hash}
	echo -e "####################################################################################################"
		echo -e "$hash"
	echo -e "####################################################################################################"
		}

	select_itertime(){
	itertime_list=("2000" "5000");
	PS3="$prompt1"
	echo -e "please select desired iter time"
	select OPT in "${itertime_list[@]}"; do
		if contains_element "$OPT" "${itertime_list[@]}"; then
			break
		else
			echo -e "invalid options selected"
		fi
	done
	iter_time=$OPT
	echo -e "####################################################################################################"
	echo -e "$iter_time"
	echo -e "####################################################################################################"
	}

	echo -e "##################################################################################################"
	echo -e "enter cryptsetup container name:"
	echo -e "##################################################################################################"
	read -p "enter cryptsetup container name: " crypt_name_usb
	select_cipher
	#select_type
	select_keysize
	select_hash
	select_itertime
	echo -e "##################################################################################################"
	cryptsetup -v --type luks1 --cipher $cipher --key-size $key_size --hash $hash --iter-time $iter_time --use-random luksFormat $crypt_chosen_usb
	echo -e "##################################################################################################"
	cryptsetup open $crypt_chosen_usb $crypt_name_usb
	echo -e "##################################################################################################"

	echo -e "##################################################################################################"

	echo -e "##################################################################################################"
	select_filesize(){
	filesize_list=("4M" "16M" "32M" "64M")
	PS3="$prompt1"
	echo -e "please select desired file size for key.img"
	select OPT in "${filesize_list[@]}"; do
		if contains_element "$OPT" "${filesize_list[@]}"; then
			break
		else
			echo -e "invalid options selected"
		fi
	done
	file_size=$OPT
	echo -e "##################################################################################################"
	echo -e "$filesize_list"
	echo -e "##################################################################################################"
	}
	select_filesize
	echo -e "select efi partition for formatting"
	select_device_partition
	mkfs.fat -F32 ${selected_device_partition}
	echo -e "formatting boot partition"
	mkfs.ext4 /dev/mapper/${crypt_name_usb}
	mount /dev/mapper/${crypt_name_usb} /mnt
	dd if=/dev/urandom of=/mnt/key.img bs=$file_size count=1
	cryptsetup luksFormat /mnt/key.img
	cryptsetup open /mnt/key.img lukskey
	}
	cryptsetup_usb


####################################################################################
# ommitted 
####################################################################################


	format_partition(){
			select_filesystem
			mkfs.${filesystem} $1 \
				$([[ ${filesystem} == xfs || ${filesystem} == btrfs || ${filesystem} == reiserfs ]] && echo "-f") \
				$([[ ${filesystem} == vfat ]] && echo "-F32") \
				$([[ $TRIM -eq 1 && ${filesystem} == ext4 ]] && echo "-E discard")
			fsck -p $1
			mkdir -p $2
			#mount -t ${filesystem} $1 $2
			#disable_partition
	}


	format_partitions(){
		block_list=(`lsblk | grep 'part\|lvm' | awk '{print substr($1,3)}'`)

		if [[ ${#block_list[@]} -eq 0 ]]; then
			echo "no partition found"
			exit 0
		fi
	
		partitions_list=()
		for OPT in ${block_list[@]}; do
			check_lvm=`echo $OPT | grep mvg`
			if [[ -z $check_lvm ]]; then
				partitions_list+=("/dev/$OPT")
			else
				partitions_list+=("/dev/mapper/$OPT")
			fi
		done
	
		if [[ $UEFI -eq 1 ]]; then
			partition_name=("root" "EFI" "swap" "another")
		else
			partition_name=("root" "swap" "another")
		fi
	}



	select_main(){
		device_list=(`lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
		PS3="$prompt1"
		echo -e "Attached Devices /dev/sdx:\n"
		lsblk -lnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,129,130,131,132,133,134,135,259 | awk '{print $1, $4, $6, $7}'| column -t 
		echo -e "\n"
		echo -e "Select Device:\n"
		select device in "${device_list[@]}"; do 
			if contains_element "${device}" "${device_list[@]}"; then
				break
			else
				echo -e "invalid_option function:\n"
			fi
		done	
		select_main=$device
		echo -e $select_main
	}

	setup_main(){
		read -p "select appropriate keyfile offset: " keyfileoffset
		read -p "select appropriate keyfile size: " keyfilesize
		read -p "select appropriate name main: " main_name
		select_main
		truncate -s 16M /mnt/header.img
		cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset="${keyfileoffset}" --keyfile-size="${keyfilesize}" luksFormat ${select_main} --header /mnt/header.img
		cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset="${keyfileoffset}" --keyfile-size="${keyfilesize}" "${select_main}" "${main_name}"
		cryptsetup close lukskey
		umount /mnt
		LUKS=1
		LUKS_DISK=`echo ${OPT} | sed 's/\/dev\///'`
	}	
	setup_main


	


###################################################################
# following section needs personalization 			  #
###################################################################

	#setup_luks(){
	#	block_list=(`lsblk | grep 'part' | awk '{print "/dev/" substr($1,3)}'`)
	#		PS3="$prompt1"
	#	echo -e "select partition:"
	#	select OPT in "${block_list[@]}"; do
	#		if contains_element "$OPT" "${block_list[@]}"; then
	#		 cryptsetup --cipher "${cipher}" --key-size "${key-size}" --iter-time "${iter-time}" --use-random --verify-passphrase luksFormat $OPT
	#		 cryptsetup open --type luks $([[ $TRIM -eq 1 ]] && echo "--allow-discards") $OPT "${crypt_name}" 
	#		 LUKS=1
	#		 LUKS_DISK=`echo ${OPT} | sed 's/\/dev\///'`
	#		break
	#		elif [[ $OPT == "Cancel" ]]; then
	#		 break
	#		else
	#		  invalid_option
	#		fi
	#	done
	#}
	#setup_luks

	setup_lvm(){
		if [[ $LUKS -eq 1 ]]; then
			pvcreate /dev/mapper/${main_name}
			vgcreate mvg /dev/mapper/${main_name}
		else
			block_list=(`lsblk | grep 'part' | awk '{print "/dev/" substr($1, 3)}'`)
			PS3="$prompt1"
			echo -r "selection partition: "
			select OPT in "${block_list[@]}"; do
				if contains_element "$OPT" "${block_list[@]}"; then
					pvcreate $OPT
					vgcreate mvg $OPT
					break
				else
					invalid_option
				fi
			done
		fi
		read -p "Enter number logical volumes for formatting [ex: 2]: " number_partitions
		i=1
		while [[ $i -le $number_partitions ]]; do
			read -p "Enter $i partition name [ex: home]: " partition_name
			if [[ $i -eq $number_partitions ]]; then
				lvcreate -l 100%FREE mvg -n ${partition_name}
			else
				read -p "enter $i partition size [ex: 25G, 200M]: " partition_size
				lvcreate -L ${partition_size} mvg -n ${partition_name}
				
			fi
			i=$(( i + 1 ))
		done
		LVM=1
	}
	setup_lvm


	select_filesystem(){
		filesystems_list=("btrfs" "ext2" "ext3" "ext4" "f2fs" "jfs" "nilfs2" "ntfs" "reiserfs" "vfat" "xfs");
		PS3="$prompt1"
		echo -e "selection filesystem:\n"
		select filesystem in "${filesystems_list[@]}"; do
			if contains_element "${filesystem}" "${filesystems_list[@]}"; then
				break
			else
				invalid_option
			fi
		done
	}	

# new select device function list logical volume management
# include within select filesystem or create separate select file system
# the function for finding lvm

	select_device_lvm(){
		lvm_candidate_list=(`lvs -a | awk '{ print "/dev/mvg/"$1 }'`)
		PS3="$prompt1"
		echo -e "select lvm candidate"
		select OPT in "${lvm_candidate_list[@]}"; do
			if contains_element "${OPT}" "${lvm_candidate_list[@]}"; then
				break
			else
				echo -e "invalid selection made"
			fi
		done
		selected_device_lvm=${OPT}
		echo -e "${selected_device_lvm}"
	}

	format_partition(){
			select_filesystem
			select_device_lvm	
			mkfs.${filesystem} ${selected_device_lvm} \
				$([[ ${filesystem} == xfs || ${filesystem} == btrfs || ${filesystem} == reiserfs ]] && echo "-f") \
				$([[ ${filesystem} == vfat ]] && echo "-F32") \
				$([[ ${filesystem} == ext4 ]])
	}


	format_partitions(){
		lvm_format_list=(`lvs -a | awk '{ print "/dev/mvg/"$1 }'`)
		PS3="$prompt1"
		read -p "enter number logical volumes for formatting: " partition_number
		i=1
		while [[ $i -le ${partition_number} ]]; do
			select_filesystem
			select_device_lvm
			mkfs.${filesystem} ${selected_device_lvm}
				$([[ ${filesystem} == xfs || ${filesystem} == btrfs || ${filesystem} == reiserfs ]] && echo " -f") \
				$([[ ${filesystem} == vfat ]] && echo "-F32") \
				$([[ ${filesystem} == ext4 ]])
			i=$(( i + 1 ))
			
		done
	}
	format_partitions	

	further_further_further_mount(){
		mount_list001=(`fdisk -l | awk '{ print $2 }' | grep '/dev' | sed 's/://g' | sed 's/-/\//g' | sed 's/mapper//g' | sed 's/\/mvg/mvg/g'`)
		echo -e " create directory for number of needed ie. home: "
				read -p "enter number of directories to create: " directory_number
				i=1
			        while [[ $i -le ${directory_number} ]]; do
				PS3="$prompt1"
				select OPT001 in "${mount_list001[@]}";do
					if contains_element "${OPT001}" "${mount_list001[@]}"; then	
						read -p "enter directory name to create for selected: " directory
						mkdir /mnt/${directory} 
						mount $OPT001 /mnt/${directory}
						break
					else
						echo -e "place holder"
					fi
				done
				i=$(( i + 1 ))	
				done			
			
				
			
	}

	further_further_further_mount

	make_swap(){
		swap_list=(`fdisk -l | awk '{ print $2 }' | grep '/dev' | sed 's/://g' | sed 's/-/\//g' | sed 's/mapper//g' | sed 's/\/mvg/mvg/g'`)
		echo -e " mkswap swapon swap partition: "
		PS3="$prompt1"
		select OPT003 in "${swap_list[@]}";do
			if contains_element "${OPT003}" "${swap_list[@]}"; then
				mkswap ${OPT003}
				swapon ${OPT003}
				break
			else
				echo -e "place holder text"
			fi
		done
	}
	make_swap

	mount /dev/mvg/root /mnt
	
	further_mount(){
		mount_list=(`dmsetup ls --target crypt | awk '{ print "/dev/mapper/"$1 }'`)
		PS3="$prompt1"
		echo -e " mount /mnt/boot to correct "
		select OPT in "${mount_list[@]}"; do
			if contains_element "${OPT}" "${mount_list[@]}"; then
				mkdir /mnt/boot
				mount ${OPT} /mnt/boot
				break
			else	
				echo -e " improper selection "
			fi
		done

	}
	further_mount

	further_further_mount(){
		mount_list000=(`fdisk -l | awk '{print $1}' | grep /dev/sd`)
		PS3="$prompt1"
		echo -e " mount /mnt/efi to correct "
		select OPT000 in "${mount_list000[@]}"; do
			if contains_element "${OPT000}" "${mount_list000[@]}"; then
				mkdir /mnt/efi
				mount ${OPT000} /mnt/efi
				break
			else
				echo -e " improper selection "
			fi
		done
	}	
	further_further_mount
	

	pacstrap /mnt base base-devel linux linux-hardened

	genfstab -U /mnt >> /mnt/etc/fstab

        arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Japan /etc/localtime

	arch-chroot /mnt hwclock --systohc	

	arch-chroot /mnt locale-gen

	cat > /mnt/etc/locale.conf << END
	LANG=en_US.UTF-8
END

	cat > /mnt/etc/hosts << END
	127.0.0.1 	localhost
	::1		localhost 

END



	mkinitcpio(){
		byidlist000=(`ls -l /dev/disk/by-id | awk '{ print $9 }'`)
		byidlist001=(`ls -l /dev/disk/by-id | awk '{ print $9 }'`)
		byidname000=(`dmsetup ls --target crypt | awk '{ print $1 }'`)
		byidname001=(`dmsetup ls --target crypt | awk '{ print $1 }'`)
		
		echo -e " select usb drive part two "
		PS3="$prompt1"
		select OPT in "${byidlist000[@]}";do
			if contains_element "${OPT}" "${byidlist000[@]}"; then
				usbdriveparttwo=${OPT}
				break

			else 
				echo -e "invalid option"
			fi
		done

		echo -e " select harddrive "
		PS3="$prompt1"
		select OPT in "${byidlist001[@]}";do
			if contains_element "${OPT}" "${byidlist001[@]}"; then
				harddrive=${OPT}
				break
			else
				echo -e "invalid option"
			fi
		done

		echo -e "select usb drive name"
		PS3="$prompt1"
		select OPT in "${byidname000[@]}";do
			if contains_element "${OPT}" "${byidname000[@]}"; then
				usbname=${OPT}
				break
			else
				echo -e "invalid option"
			fi
			
		done

		echo -e "select harddrive name"
		PS3="$prompt1"
		select OPT in "${byidname001[@]}";do
			if contains_element "${OPT}" "${byidname001[@]}"; then
				harddrivename=${OPT}
				break
			else
				echo -e "invalid option"
			fi
		done

		read -p "enter keyfile offset as before: " offset
		read -p "enter keyfile size as before: " size

		cat > /mnt/etc/initcpio/hooks/customencrypthook << END 
		#!/usr/bin/ash

		run_hook(){
			modprobe -a -q dm-crypt >/dev/null 2>&1
			modprobe loop
			[ "${quiet}" = "y" ] && CSQUIET=">/dev/null"

			while [ ! -L '/dev/disk/by-id/${usbdriveparttwo}' ]; do
				echo 'Waiting for USB'
				sleep 1
			done
	
			cryptsetup open /dev/disk/by-id/${usbdriveparttwo} ${usbname}
			mkdir -p /mnt
			mount /dev/mapper/${usbname} /mnt
			cryptsetup open /mnt/key.img lukskey
			cryptsetup --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=${offset} --keyfile-size=${size} open /dev/disk/by-id/${harddrive} ${harddrivename}
			cryptsetup close lukskey
			umount /mnt
		}
END
	}
mkinitcpio	

	arch-chroot /mnt sed -i '6s/""/"${quiet}"/'/etc/initcpio/hooks/customencrypthook
        arch-chroot /mnt cp /etc/initcpio/hooks/customencrypthook /etc/initcpio/install/customencrypthook
	
	arch-chroot /mnt cp /usr/lib/initcpio/install/encrypt /etc/initcpio/install/customencrypthook

	arch-chroot /mnt pacman -S lvm2
	arch-chroot /mnt pacman -S vim
	arch-chroot /mnt sed -i 's/MODULES=()/MODULES=(loop)/' /etc/mkinitcpio.conf
	arch-chroot /mnt sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck/HOOKS=(base udev autodetect modconf block customencrypthook lvm2 filesystems keyboard fsck/' /etc/mkinitcpio.conf

	genfstab -U /mnt >> /mnt/etc/fstab
	arch-chroot /mnt mkinitcpio -p linux 
	arch-chroot /mnt mkinitcpio -p linux-hardened
	arch-chroot /mnt pacman -S grub efibootmgr
	arch-chroot /mnt sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/' /etc/default/grub
	arch-chroot /mnt sed -i 's/GRUB_PRELOAD_MODULES="part_gpt part_msdos"/GRUB_PRELOAD_MODULES="part_gpt part_msdos lvm"/' /etc/default/grub
	arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB	
	arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
	arch-chroot /mnt sudo pacman -S dhcpcd
	arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	arch-chroot /mnt locale-gen

