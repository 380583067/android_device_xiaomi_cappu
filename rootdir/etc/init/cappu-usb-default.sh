#!/system/bin/sh

# Android 12 UsbDeviceManager stores the screen-unlocked USB function choice
# in this device-protected SharedPreferences file. Seed only a missing file:
# a pre-existing file represents the user's saved choice and must never be
# overwritten by a later OTA or reboot.
PREFS=/data/system_de/0/UsbDeviceManagerPrefs.xml
TEMP=${PREFS}.cappu-tmp

if [ -e "$PREFS" ]; then
    exit 0
fi

# On a clean userdata image Android may not have created the system-user DE
# subdirectory yet. Build it with the same owner/mode and inherited DE label.
/system/bin/mkdir -p /data/system_de/0 || exit 1
/system/bin/chown system:system /data/system_de/0 || exit 1
/system/bin/chmod 0770 /data/system_de/0 || exit 1
/system/bin/restorecon /data/system_de/0 || exit 1

# Write atomically before system_server starts reading the preferences. The
# file uses the same key and value as UsbDeviceManager.setScreenUnlockedFunctions.
umask 077
/system/bin/printf '%s\n' \
    '<?xml version="1.0" encoding="utf-8" standalone="yes" ?>' \
    '<map>' \
    '    <string name="usb-screen-unlocked-config-0">mtp,adb</string>' \
    '</map>' > "$TEMP" || exit 1

/system/bin/chown system:system "$TEMP" || exit 1
/system/bin/chmod 0600 "$TEMP" || exit 1
/system/bin/restorecon "$TEMP" || exit 1
/system/bin/mv "$TEMP" "$PREFS" || exit 1
/system/bin/restorecon "$PREFS"
