#!/system/bin/sh
# rtwo: show the marketing name that matches this unit's SKU
SKU=$(getprop ro.boot.hardware.sku)
case "$SKU" in
    XT2301-1*) NAME="Motorola Edge+ 2023" ;;
    XT2301-4*) NAME="Motorola Edge 40 Pro" ;;
    XT2301-5*) NAME="Motorola Moto X40" ;;
    *) exit 0 ;;
esac
for RP in /system/bin/resetprop /sbin/resetprop; do
    [ -x "$RP" ] && break
done
[ -x "$RP" ] || exit 0
"$RP" ro.product.model "$NAME"
"$RP" ro.display.series "$NAME"
