#!/bin/bash

diskId=1;
label="$1"

case $label in
    'c')
        diskId=2
        ;;
    'd')
        diskId=4
        ;;
    'e')
        diskId=5
        ;;
    *)
        exit 1;
        ;;
esac

if [ "$2" = 'u' ];then
	exec sudo umount /home/liukairui/FileTrans/$label;
else
    sudo mount /dev/nvme0n1p$diskId /home/liukairui/FileTrans/$label;
    if [ "$2" = 'd' -o "$3" = 'd' ];then
        exec dolphin /home/liukairui/FileTrans/$label --new-window 2>/dev/null
    fi
fi
