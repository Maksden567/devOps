#!/bin/bash

# Скрипт для створення LVM та монтування ext4 файлової системи на /mnt/storage

# Перевірка прав адміністратора
if [[ $EUID -ne 0 ]]; then
   echo "Цей скрипт повинен виконуватися з root правами!" >&2
   exit 1
fi

# 1. Створення Physical Volume
pvcreate /dev/sdb
# pvcreate — перетворює диск або розділ у фізичний том LVM.

# 2. Створення Volume Group
vgcreate vg_storage /dev/sdb
# vgcreate — створює групу томів із зазначених PV.
# 'vg_storage' — назва Volume Group.

# 3. Створення Logical Volume
lvcreate -n lv_storage -l 100%FREE vg_storage
# lvcreate — створює логічний том.
# -n lv_storage — ім'я Logical Volume.
# -l 100%FREE — займає весь вільний простір VG.

# 4. Форматування файлової системи ext4
mkfs.ext4 /dev/vg_storage/lv_storage
# mkfs.ext4 — створює файлову систему ext4 на LV.

# 5. Створення точки монтування
mkdir -p /mnt/storage

# 6. Монтування LV
mount /dev/vg_storage/lv_storage /mnt/storage

