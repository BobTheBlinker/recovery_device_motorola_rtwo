#!/system/bin/sh
# rtwo: bring up the Kiwi (qca_cld3) wifi stack from the ROM's own
# vendor_dlkm/vendor, so the driver always matches the running kernel.
# Runs at boot (crypto.ready) and again when AERA sets sys.aera.wlan.up=1.
exec >> /tmp/rtwo_wifi.log 2>&1
S=$(getprop ro.boot.slot_suffix)
V=/tmp/wifi_vendor
echo "rtwo_wifi: start (slot $S)"

if [ ! -e /sys/class/net/wlan0 ]; then
    # ROM partitions: vendor_dlkm at /vendor_dlkm (modules.dep uses that path), vendor at $V
    umount /vendor_dlkm/lib/modules 2>/dev/null
    mountpoint -q /vendor_dlkm || mount -o ro /dev/block/mapper/vendor_dlkm$S /vendor_dlkm || exit 1
    mkdir -p $V; mountpoint -q $V || mount -o ro /dev/block/mapper/vendor$S $V || exit 1

    # driver config, found by the firmware loader under /etc/firmware
    mkdir -p /etc/firmware/wlan/qca_cld/kiwi_v2 /data/vendor/wifi
    cat $V/etc/wifi/kiwi_v2/WCNSS_qcom_cfg.ini > /etc/firmware/wlan/qca_cld/kiwi_v2/WCNSS_qcom_cfg.ini

    # the recovery image's bundled mhi is from another build; swap in the ROM's
    for m in qrtr_mhi qdss_bridge mhi_dev_satellite mhi_dev_netdev mhi_dev_uci mhi_dev_dtr mhi_dev_drv mhi_dev_net mhi_cntrl_qcom mhi; do
        rmmod $m 2>/dev/null
    done
    modprobe -d /vendor_dlkm/lib/modules -a mhi mhi_cntrl_qcom qrtr_mhi cnss2

    # cnss-daemon + fs_ready start the chip's calibration, then the wifi driver
    LD_LIBRARY_PATH=$V/lib64:/system/lib64 $V/bin/cnss-daemon -n -l &
    sleep 2
    echo 1 > /sys/kernel/cnss/fs_ready
    modprobe -d /vendor_dlkm/lib/modules qca_cld3_kiwi_v2

    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
        [ -e /sys/class/net/wlan0 ] && break
        sleep 1
    done
fi

if [ ! -e /sys/class/net/wlan0 ]; then
    echo "rtwo_wifi: wlan0 did not appear"
    exit 1
fi
echo "rtwo_wifi: wlan0 up"

# AERA asked for wifi: hand over to wpa_supplicant
if [ "$(getprop sys.aera.wlan.up)" = "1" ]; then
    mkdir -p /tmp/recovery/sockets
    chown 1010:1010 /tmp/recovery/sockets; chmod 0770 /tmp/recovery/sockets
    rm -f /tmp/recovery/sockets/wlan0
    start wpa_supplicant
    setprop sys.aera.wlan.up 0
    echo "rtwo_wifi: wpa_supplicant started"
fi
