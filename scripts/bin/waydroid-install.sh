#! /usr/bin/env bash

# Start waydroid via `waydroid show-full-ui`
# 1. Extract xapk
# 2. `adb install <name>`
# 3. `adb push `Android/obb/<name> /storage/emulated/0`
# 4. `sudo waydroid shell` >>
#     chmod 777 -R /sdcard/Android
#     chmod 777 -R /data/media/0/Android 
#     chmod 777 -R /sdcard/Android/data
#     chmod 777 -R /data/media/0/Android/obb 
#     chmod 777 -R /mnt/*/*/*/*/Android/data
#     chmod 777 -R /mnt/*/*/*/*/Android/obb
# Steps 3/4 might need to be swapped or step 3 needs to be manually done in a file manager in Waydroid
# https://github.com/casualsnek/waydroid_script?tab=readme-ov-file#granting-full-permission-for-apps-data-hack