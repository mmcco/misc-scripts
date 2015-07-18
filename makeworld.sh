#!/bin/sh
# makeworld.sh
# shared by user 'risc' on the Freenode #openbsd channel
# to be run as root, obviously
echo "Rebuilding userland and Xenocara."
echo "Please be patient this will take a while..."
        #rebuild OpenBSD userland
        rm -rf /usr/obj/*
        cd /usr/src
        make obj
        cd /usr/src/etc && env DESTDIR=/ make distrib-dirs
        cd /usr/src
        make build
                #rebuild Xenocara
                rm -rf /usr/xobj/*
                cd /usr/xenocara
                make bootstrap
                make obj
                make build
echo ""
echo "Rebuild complete."
echo ""
echo "Please press ENTER to reboot the system."
read ENTER
reboot
