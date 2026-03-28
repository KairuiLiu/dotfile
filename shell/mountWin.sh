#!/bin/bash

diskId=1;
label="$1"

case $label in
    'c')
        diskId=3
        ;;
    'd')
        diskId=5
        ;;
    'e')
        diskId=6
        ;;
    *)
        exit 1;
        ;;
esac

if [ "$2" = 'u' ];then
	exec sudo umount $HOME/fileTrans/$label;
else
    sudo mount /dev/nvme0n1p$diskId $HOME/fileTrans/$label;
    if [ "$2" = 'd' -o "$3" = 'd' ];then
        exec dolphin $HOME/fileTrans/$label --new-window 2>/dev/null
    fi
fi
