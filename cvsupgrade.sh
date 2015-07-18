#!/bin/sh
# cvsupgrade.sh
# shared by user 'risc' on the Freenode #openbsd channel
# BEWARE: this will reinstall your system!
# to be run as root, obviously
KERNEL=$(uname -v | sed -e 's/#.*//')
VERSION="OPENBSD_"$(uname -r | sed 's/[.]/_/g')
ARCH=$(uname -m)
# See http://www.openbsd.org/anoncvs.html#CVSROOT for your local mirror
# uncomment this if lazy
#CVSROOT=anoncvs@anoncvs.au.openbsd.org:/cvs
        echo "Fetching OpenBSD "$(uname -r)"-stable source code..."
                # checkout OpenBSD stable source code
               cd /usr
			   # 'checkout' is equivalent to 'update -d' when the repo already exists
			   # add -r (e.g. -r OPENBSD_5_7) to use a release rather than current
               cvs -d$CVSROOT checkout -r$VERSION -P src ports xenocara
        echo "Done."
        echo ""
        echo "Please press ENTER to start building "$KERNEL" kernel, or CTRL C to quit."
        read ENTER
                # build the correct kernel
                cd /usr/src/sys/arch/$ARCH/conf
                config $KERNEL
                cd ../compile/$KERNEL
                make clean && make
        echo ""
        echo "Please press ENTER to install new kernel, or CTRL C to quit."
        read ENTER
                # install the new kernel
                make install
        echo ""
        echo "New kernel has been installed.  The machine must be rebooted."
        echo "Once rebooted log in as root and run the 'makeworld.sh' script."
        echo ""
        echo "Please press ENTER to reboot the system."
        read ENTER
reboot
