#!/system/bin/sh

# rm /system/fonts/NotoColorEmoji.ttf
tmpPushed=/magisk
rm -rf $tmpPushed
mkdir $tmpPushed
tar -xvf /magisk.tar --no-same-owner -C $tmpPushed
umount /magisk.tar ; rm -v /magisk.tar
mkdir /sbin
chown root:root /sbin
# chmod 0700 /sbin
chmod 0751 /sbin
cp $tmpPushed/magisk /sbin/
cp $tmpPushed/app-debug.apk /sbin/stub.apk
find /sbin -type f -exec chmod 0755 {} \;
find /sbin -type f -exec chown root:root {} \;
# add /sbin
# /sbin/
# ├── magisk
# └── stub.apk


ln -f -s /sbin/magisk /system/xbin/su
mkdir /product/bin
chmod 751 /product/bin
ln -f -s /sbin/magisk /product/bin/su
# add su (override `/system/xbin/su`)
# /product/bin/
# └── su -> /sbin/magisk

mkdir -p /data/adb/magisk
chmod 700 /data/adb
mv $tmpPushed/busybox /data/adb/magisk/
chmod -R 755 /data/adb/magisk
chmod -R root:root /data/adb/magisk
# /data/adb/
# ├── magisk
# │   └── busybox

# rm -rf $tmpPushed
