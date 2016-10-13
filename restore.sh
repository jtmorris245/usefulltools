#! /bin/bash
## Restores a VM to a Golden Image state.
## Note: Default network name will need to be changed.
## Expects folders with "GOLD" in their name to contain a single gold image in qcow2 format.

## Setup Vars ##
PWDLS=`ls -A`


VMIM=`echo "$PWDLS" | grep -i "qcow2"`
if [ "$VMIM" ]
	then
		echo "VM Image Found..."
	else
		echo "No VM Image Found! Quitting..." && exit 1
fi
VMNM=${PWD##*/}
ISVMDEV=`echo "$VMNM"|grep -i "dev"`
if [ "$ISVMDEV" ]
	then
		echo "VM Identified as DEV Class..."
		GPATH=../GOLDDEV
	else
		echo "VM Identified as ENG Class..."
		GPATH=../"GOLD ENG"
fi
if [ -a "$GPATH" ]
	then
		echo "Golden Image Folder Found!"
	else
		echo "No Golden Image Folder Found! Quitting..." && exit 1
fi
GIMG="$GPATH/"`ls "$GPATH" | grep -i "qcow2"`
echo "$GIMG"
if [ -a "$GIMG" ]
 then
                echo "Golden Image Found!"
        else
                echo "No Golden Image Found! Quitting..." && exit 1
fi
echo  "Do you wish to use:$GIMG As the Golden Image? [Y/N]"
read -n 1 YN
if [ $YN == "Y" ]
	then
		echo "Starting Replacement..."
	else
		echo "Quitting..." && exit 1
fi
rm "$VMIM"
qemu-img create -b "$GIMG" -f qcow2 "$VMIM" && echo "Completed!" && exit 0
