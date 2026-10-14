#!/system/bin/sh
# BOBtheBlinker
# Copyright (C) 2019-Present A-Team Digital Solutions
#
# Load the installed ROM identity before Qualcomm KeyMint starts.
# KeyMint binds storage keys to the Android and vendor patch levels.

LOG=/tmp/rtwo-crypto-identity.log

SYSTEM_DEVICE=/dev/block/mapper/system
VENDOR_DEVICE=/dev/block/mapper/vendor

SYSTEM_MOUNT=/tmp/rtwo-system
VENDOR_MOUNT=/tmp/rtwo-vendor

log_message() {
    MESSAGE="rtwo-crypto-identity: $*"
    echo "$MESSAGE" >> "$LOG"
    echo "<6>$MESSAGE" > /dev/kmsg 2>/dev/null
}

mount_readonly() {
    DEVICE="$1"
    TARGET="$2"
    NAME="$3"

    mkdir -p "$TARGET"
    umount "$TARGET" 2>/dev/null

    for TYPE in erofs ext4; do
        if mount -t "$TYPE" -o ro "$DEVICE" "$TARGET" 2>/dev/null; then
            log_message "mounted $NAME as $TYPE"
            return 0
        fi
    done

    if mount -o ro "$DEVICE" "$TARGET" 2>/dev/null; then
        log_message "mounted $NAME with automatic detection"
        return 0
    fi

    log_message "ERROR: unable to mount $NAME from $DEVICE"
    return 1
}

read_property() {
    PROPERTY="$1"
    shift

    for FILE in "$@"; do
        [ -r "$FILE" ] || continue

        while IFS= read -r LINE; do
            case "$LINE" in
                "$PROPERTY"=*)
                    printf '%s' "${LINE#*=}"
                    return 0
                    ;;
            esac
        done < "$FILE"
    done

    return 1
}

cleanup_mounts() {
    umount "$VENDOR_MOUNT" 2>/dev/null
    umount "$SYSTEM_MOUNT" 2>/dev/null
}

rm -f "$LOG"

setprop sys.rtwo.crypto_identity.ready 0
setprop sys.rtwo.crypto_identity.failed 0

log_message "waiting for logical system/vendor mappings"

ATTEMPT=0

while [ "$ATTEMPT" -lt 60 ]; do
    if [ -e "$SYSTEM_DEVICE" ] && [ -e "$VENDOR_DEVICE" ]; then
        break
    fi

    ATTEMPT=$((ATTEMPT + 1))
    sleep 1
done

if [ ! -e "$SYSTEM_DEVICE" ] || [ ! -e "$VENDOR_DEVICE" ]; then
    log_message "ERROR: logical system/vendor mappings unavailable"
    setprop sys.rtwo.crypto_identity.failed 1
    exit 1
fi

if ! mount_readonly "$SYSTEM_DEVICE" "$SYSTEM_MOUNT" system; then
    cleanup_mounts
    setprop sys.rtwo.crypto_identity.failed 1
    exit 1
fi

if ! mount_readonly "$VENDOR_DEVICE" "$VENDOR_MOUNT" vendor; then
    cleanup_mounts
    setprop sys.rtwo.crypto_identity.failed 1
    exit 1
fi

SYSTEM_FILES="
$SYSTEM_MOUNT/system/build.prop
$SYSTEM_MOUNT/build.prop
"

VENDOR_FILES="
$VENDOR_MOUNT/build.prop
$VENDOR_MOUNT/etc/build.prop
"

ALL_FILES="$SYSTEM_FILES $VENDOR_FILES"

OS_RELEASE="$(read_property ro.build.version.release $SYSTEM_FILES)"
OS_SDK="$(read_property ro.build.version.sdk $SYSTEM_FILES)"
OS_PATCH="$(read_property ro.build.version.security_patch $SYSTEM_FILES)"

VENDOR_RELEASE="$(
    read_property ro.vendor.build.version.release $VENDOR_FILES
)"
VENDOR_SDK="$(
    read_property ro.vendor.build.version.sdk $VENDOR_FILES
)"
VENDOR_PATCH="$(
    read_property ro.vendor.build.security_patch $VENDOR_FILES
)"

BOOT_PATCH="$(
    read_property ro.bootimage.build.version.security_patch $ALL_FILES
)"

VENDOR_BOOT_PATCH="$(
    read_property ro.vendor.boot_security_patch $ALL_FILES
)"

FIRST_API="$(
    read_property ro.product.first_api_level $ALL_FILES
)"

BOARD_FIRST_API="$(
    read_property ro.board.first_api_level $ALL_FILES
)"

cleanup_mounts

if [ -z "$OS_RELEASE" ] ||
   [ -z "$OS_SDK" ] ||
   [ -z "$OS_PATCH" ] ||
   [ -z "$VENDOR_RELEASE" ] ||
   [ -z "$VENDOR_SDK" ] ||
   [ -z "$VENDOR_PATCH" ]; then

    log_message "ERROR: installed ROM identity is incomplete"
    log_message "OS_RELEASE=${OS_RELEASE:-missing}"
    log_message "OS_SDK=${OS_SDK:-missing}"
    log_message "OS_PATCH=${OS_PATCH:-missing}"
    log_message "VENDOR_RELEASE=${VENDOR_RELEASE:-missing}"
    log_message "VENDOR_SDK=${VENDOR_SDK:-missing}"
    log_message "VENDOR_PATCH=${VENDOR_PATCH:-missing}"

    setprop sys.rtwo.crypto_identity.failed 1
    exit 1
fi

resetprop ro.build.version.release "$OS_RELEASE"
resetprop ro.build.version.sdk "$OS_SDK"
resetprop ro.build.version.security_patch "$OS_PATCH"

resetprop ro.vendor.build.version.release "$VENDOR_RELEASE"
resetprop ro.vendor.build.version.sdk "$VENDOR_SDK"
resetprop ro.vendor.build.security_patch "$VENDOR_PATCH"

if [ -n "$BOOT_PATCH" ]; then
    resetprop ro.bootimage.build.version.security_patch "$BOOT_PATCH"
fi

if [ -n "$VENDOR_BOOT_PATCH" ]; then
    resetprop ro.vendor.boot_security_patch "$VENDOR_BOOT_PATCH"
fi

[ -n "$FIRST_API" ] && resetprop ro.product.first_api_level "$FIRST_API"
[ -n "$BOARD_FIRST_API" ] && resetprop ro.board.first_api_level "$BOARD_FIRST_API"

log_message \
    "loaded system=${OS_RELEASE}/SDK${OS_SDK}/SPL${OS_PATCH}"

log_message \
    "loaded vendor=${VENDOR_RELEASE}/SDK${VENDOR_SDK}/SPL${VENDOR_PATCH}"

setprop sys.rtwo.crypto_identity.ready 1
exit 0
