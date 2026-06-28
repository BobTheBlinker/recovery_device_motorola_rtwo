#!/system/bin/sh
# BOBtheBlinker
# Copyright (C) 2019-Present A-Team Digital Solutions

TAG="rtwo-vab-state"
META="/metadata"
META_DEV="/dev/block/bootdevice/by-name/metadata"
OTA_DIR="${META}/ota"
STATE_FILE="${OTA_DIR}/state"
SNAPSHOT_DIR="${OTA_DIR}/snapshots"
LOG_FILE="/tmp/rtwo-vab-state.log"

log_msg() {
    echo "${TAG}: $*" >> "${LOG_FILE}"
}

log_msg "starting guarded Virtual A/B state check"

# Wait for metadata to become mounted, or mount it ourselves once its
# block-device node becomes available.
COUNT=0
while [ "${COUNT}" -lt 80 ]; do
    if grep -q " ${META} " /proc/mounts; then
        break
    fi

    if [ -e "${META_DEV}" ]; then
        mkdir -p "${META}"
        mount -t f2fs "${META_DEV}" "${META}" >/dev/null 2>&1 || true

        if grep -q " ${META} " /proc/mounts; then
            break
        fi
    fi

    sleep 0.25
    COUNT=$((COUNT + 1))
done

if ! grep -q " ${META} " /proc/mounts; then
    log_msg "metadata unavailable; leaving OTA state untouched"
    exit 0
fi

if [ ! -f "${STATE_FILE}" ]; then
    log_msg "no OTA state file present"
    exit 0
fi

if [ -s "${STATE_FILE}" ]; then
    log_msg "OTA state file is non-empty; preserving it"
    exit 0
fi

if [ ! -d "${SNAPSHOT_DIR}" ]; then
    log_msg "snapshot directory missing; preserving state file"
    exit 0
fi

if find "${SNAPSHOT_DIR}" \
    -mindepth 1 \
    -maxdepth 1 \
    -print -quit 2>/dev/null |
    grep -q .; then
    log_msg "snapshot directory is not empty; preserving state file"
    exit 0
fi

# Only the known harmless entries may exist. Anything else could represent
# genuine OTA state, so fail safely and preserve everything.
UNEXPECTED="$(
    find "${OTA_DIR}" \
        -mindepth 1 \
        -maxdepth 1 \
        ! -name state \
        ! -name snapshots \
        ! -name allow-forward-merge \
        -print -quit 2>/dev/null
)"

if [ -n "${UNEXPECTED}" ]; then
    log_msg "unexpected OTA entry found: ${UNEXPECTED}; preserving state file"
    exit 0
fi

rm -f "${STATE_FILE}"

if [ -e "${STATE_FILE}" ]; then
    log_msg "failed to remove empty OTA state file"
    exit 0
fi

sync
log_msg "removed empty OTA state file; no snapshots were present"
exit 0
