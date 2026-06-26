#!/system/bin/sh

resetprop ro.build.version.release 16
resetprop ro.build.version.sdk 36
resetprop ro.build.version.security_patch 2026-06-01

resetprop ro.vendor.build.version.release 16
resetprop ro.vendor.build.version.sdk 36
resetprop ro.vendor.build.security_patch 2025-09-01

resetprop ro.product.first_api_level 33
resetprop ro.board.first_api_level 33

resetprop ro.crypto.type file
