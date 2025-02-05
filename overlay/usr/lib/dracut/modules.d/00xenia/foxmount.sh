# !/bin/bash

echo "--- foxmount ---"

echo "foxmount: Mounting roots"
mount -L ROOTS /sysroot/roots # probably not necessary, leaving in just in case
mount -o rw,remount /sysroot/roots

etc_path="/sysroot/overlay"
var_path="/sysroot/overlay"
usr_path="/sysroot/overlay"

get_filesystem() {
    label="$1"

    # Get the partition information using the 'blkid' command
    partition_info=$(blkid -o value -s TYPE -l -t LABEL="$label")

    # Extract the filesystem from the partition information
    filesystem=$(echo "$partition_info" | awk 'NR==1{print}')

    # Return the filesystem
    echo "$filesystem"
}

recovery() {
    echo "foxmount: Unmounting overlays"
    umount -l /sysroot/usr
    umount -l /sysroot/etc
    umount -l /sysroot/var
    echo "foxmount: Mounting recovery"

    # Okay - this is a bit stupid but let me try and explain this.
    # Mounting an overlay over sysroot itself didn't work - so we mount every directory as an overlay
    # We need a tmpfs as an upper dir along with the read-only overlay, otherwise OpenRC won't boot - so we create that and mount a tmpfs
    # Lastly, we mount the overlay with the .recovery acting as a read-only overlay and the tmpfs as the read-write part.

    [ ! -d /sysroot/roots/.recovery ] && mkdir /sysroot/roots/.recovery/
    mount -t tmpfs tmpfs /sysroot/roots/.recovery/

    cd /sysroot/.recovery && for d in */ ; do
        mkdir -p /sysroot/roots/.recovery/.$d
        mkdir -p /sysroot/roots/.recovery/.w_$d
        mount -t overlay overlay -o lowerdir=/sysroot/.recovery/$d:/sysroot/$d,upperdir=/sysroot/roots/.recovery/.$d,workdir=/sysroot/roots/.recovery/.w_$d /sysroot/$d
    done
}

foxmount() {
    echo "foxmount: Checking for recovery"
    for p in $(getargs recovery=); do
        if [ $p = "true" ]; then
            recovery
            return 0
        fi
    done

    echo "foxmount: Checking for config"
    if [ -f "/sysroot/roots/foxmount.sh" ]; then
        echo "foxmount: Running config"
        source /sysroot/roots/foxmount.sh
        return 0
    fi


    if [[ $(get_filesystem OVERLAY) != "" ]]
    then
        echo "foxmount: Overlays on label, traditional FS layout"

        echo "foxmount: Mounting overlay location"
        mount -L OVERLAY /sysroot/overlay
        
        echo "foxmount: Mounting home"
        mount -L HOME /sysroot/home

    elif [[ $(get_filesystem ROOTS) = "btrfs" ]]
    then
        echo "foxmount: btrfs found, remounting with compression"
        mount -L ROOTS -o remount,compress=zstd /sysroot/roots

        echo "foxmount: Mounting overlay subvolume"
        mount -L ROOTS -o subvol=overlay /sysroot/overlay

        echo "foxmount: Mounting home"
        mount -L ROOTS -o subvol=home /sysroot/home

        echo "foxmount: Setting overlay paths"
        etc_path="/sysroot/overlay/etc"
        var_path="/sysroot/overlay/var"
        usr_path="/sysroot/overlay/usr"

    elif [[ $(get_filesystem MARIA) = "zfs_member" ]] # this won't work, no label on ZFS - find another way
    then
        echo "foxmount: zfs found"
        /sbin/modprobe zfs

        # cow: please help mount ZFS?
    elif [[ $(get_filesystem MARIA) = "crypto_LUKS" ]]
    then
        echo "foxmount: LUKS found"
        plymouth ask-for-password --command='cryptsetup luksOpen /dev/disk/by-label/MARIA maria' --prompt='Enter decryption key'
        echo "foxmount: Mounting overlay subvolume"
        mount /dev/mapper/maria -o subvol=overlay,compress=zstd /sysroot/overlay

        echo "foxmount: Mounting home"
        mount /dev/mapper/maria -o subvol=home /sysroot/home

        echo "foxmount: Setting overlay paths"
        etc_path="/sysroot/overlay/etc"
        var_path="/sysroot/overlay/var"
        usr_path="/sysroot/overlay/usr"    
    else
        echo "foxmount: FATAL: could not find overlays!"
        recovery
        return 0
    fi

    echo "foxmount: Creating overlay directories if they don't exist"
    [ ! -d "${etc_path}/etc" ] && mkdir ${etc_path}/etc
    [ ! -d "${var_path}/var" ] && mkdir ${var_path}/var
    [ ! -d "${usr_path}/usr" ] && mkdir ${usr_path}/usr

    echo "foxmount: Creating overlay work directories if they don't exist"
    [ ! -d "${etc_path}/etcw" ] && mkdir ${etc_path}/etcw
    [ ! -d "${var_path}/varw" ] && mkdir ${var_path}/varw
    [ ! -d "${usr_path}/usrw" ] && mkdir ${usr_path}/usrw

    echo "foxmount: Checking for foxsnapshot revert"
    if [ -s /sysroot/roots/.revert ]; then
        btrfs subvolume delete /sysroot/overlay/usr
        btrfs subvolume snapshot /sysroot/roots/.foxsnapshot/$(cat /sysroot/roots/.revert) /sysroot/overlay/usr
        rm /sysroot/roots/.revert
    fi

    echo "foxmount: Mounting overlays on /sysroot"
    mount -t overlay overlay -o lowerdir=/sysroot/usr,upperdir=${usr_path}/usr,workdir=${usr_path}/usrw,ro /sysroot/usr
    mount -t overlay overlay -o lowerdir=/sysroot/etc,upperdir=${etc_path}/etc,workdir=${etc_path}/etcw,rw /sysroot/etc
    mount -t overlay overlay -o lowerdir=/sysroot/var,upperdir=${var_path}/var,workdir=${var_path}/varw,rw /sysroot/var
    echo "foxmount: Finished mounting overlays"
}

foxmount