#!/system/bin/sh

kmsg()
{
    echo "rtwo-battery: $*" > /dev/kmsg
}

# Nothing to do if the battery driver is already online.
if [ -e /sys/class/power_supply/battery ]; then
    kmsg "battery power supply already available"
    /system/bin/setprop ctl.restart health-hal-2-1
    exit 0
fi

COUNT=0

while [ ! -e /sys/kernel/boot_adsp/boot ]; do
    COUNT=$((COUNT + 1))

    if [ "$COUNT" -ge 120 ]; then
        kmsg "timed out waiting for /sys/kernel/boot_adsp/boot"
        exit 1
    fi

    sleep 1
done

kmsg "starting ADSP through boot_adsp helper"

if ! echo 1 > /sys/kernel/boot_adsp/boot; then
    kmsg "failed to trigger ADSP startup"
    exit 1
fi

COUNT=0

while [ ! -e /sys/class/power_supply/battery ]; do
    COUNT=$((COUNT + 1))

    if [ "$COUNT" -ge 120 ]; then
        kmsg "timed out waiting for battery power supply"
        exit 1
    fi

    sleep 1
done

kmsg "battery power supply available; restarting health HAL"

/system/bin/setprop ctl.restart health-hal-2-1

kmsg "battery bootstrap complete"
exit 0
