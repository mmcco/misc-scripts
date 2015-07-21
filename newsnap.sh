# checks whether your OpenBSD mirror's snapshot is synced with the mothership
# uses mirror if so, mothership otherwise
# needs to be updated for your mirror of choice and for each release

set -e    # fail on command error
# use a persistent junk dir so that we can later check whether there's a newer snapshot
cd ~/junk

ARCH=`uname -m`
MOTHERSHIP=http://ftp3.usa.openbsd.org/pub/OpenBSD/snapshots/${ARCH}/
# TODO: set your preferred mirror here!
MIRROR=http://openbsd.mirrors.pair.com/snapshots/${ARCH}/

MOTHERSHIP_HASH=`ftp -o - ${MOTHERSHIP}SHA256 | grep install58.fs`
MIRROR_HASH=`ftp -o - ${PAIR_MIRROR}SHA256 | grep install58.fs`
if [ "$MOTHERSHIP_HASH" = "$MIRROR_HASH" ]; then 
    CHOSEN_MIRROR=$PAIR_MIRROR
else 
    CHOSEN_MIRROR=$MOTHERSHIP
fi

ftp ${CHOSEN_MIRROR}{install58.fs,SHA256,SHA256.sig}
SNAP_HASH=`sha256 install58.fs`
SIG_HASH=`grep install58.fs SHA256`
SIG_VER=`signify -V -p /etc/signify/openbsd-58-base.pub -m SHA256`

if [ $? ] && [ "$SNAP_HASH" = "$SIG_HASH" ]; then
    echo "\n\tReady to image!"
else
    echo "\n\tDANGER, WILL ROBINSON!!!"
fi
