#! /bin/sh

# dowloads and unpacks .deb packages for defined arch
# this needs coreutils, dctrl-tools and wget added to
# build-packages when used via snapcraft.yaml

if [ $# -lt 4 ]; then
    printf "Usage: %s <arch> <series> <folder> <PACKAGE_NAME...>\n" \
           "$(basename "$0")"
    exit 1
fi

ARCH=$1
SERIES=$2
FOLDER=$3
shift 3

PKGLIST="$*"
echo "$(basename "$0"): obtaining packages for $ARCH: $PKGLIST"

case $ARCH in
    armhf|arm64)
        SERVER="http://ports.ubuntu.com"
        ;;
    *)
        SERVER="http://archive.ubuntu.com/ubuntu"
        ;;
esac

for pkg in $PKGLIST; do
    PKGPATH=""
    for POCKET in universe main; do
        PACKAGES=$SERVER/dists/$SERIES/$POCKET/binary-$ARCH/Packages.gz
        UPACKAGES=$SERVER/dists/$SERIES-updates/$POCKET/binary-$ARCH/Packages.gz
        if wget -q -O- "$UPACKAGES" | zcat | grep-dctrl -P "${pkg}" |
                grep Filename | grep -q "/${pkg}_"; then
            PKGPATH="$(wget -q -O- "$UPACKAGES" | zcat | grep-dctrl -P "${pkg}" |
                grep Filename | grep "${pkg}_" | sed 's/^Filename: //')"
        elif wget -q -O- "$PACKAGES" | zcat | grep-dctrl -P "${pkg}" |
                grep Filename | grep -q "/${pkg}_"; then
            PKGPATH="$(wget -q -O- "$PACKAGES" | zcat | grep-dctrl -P "${pkg}" |
                grep Filename | grep "${pkg}_" | sed 's/^Filename: //')"
        else
            PKGPATH=""
        fi
        if [ -n "$PKGPATH" ]; then
            echo "unpacking $pkg from $SERVER/$PKGPATH"
            wget -q -O- $SERVER/$PKGPATH | dpkg -x - "$FOLDER"
        fi
    done
done
