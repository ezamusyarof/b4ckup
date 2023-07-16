#!/bin/bash
source /home/<user>/Documents/b4ckup/.conf

if [ "`whoami`" = "root" ]
then
    # halaman utama
    echo "--------------------------"
    echo "#### UAS Kelompok 1 ####"
    echo ""
    read -p "Masukkan waktu cron format (min) (h) (dom) (mon) (dow) : " jadwal_cron
    read -p "Masukkan directory backup  (/path/to/dir)              : " dir
    echo ""
    add_cron_entry(){
      crontab -l > temp_cron
      echo "$jadwal_cron bash $FILE_LOCATION/b4ckup.sh '$dir' > /dev/null 2>&1 " >> temp_cron
      crontab temp_cron
      crontab -l < temp_cron > /dev/null 2>&1
      rm temp_cron
      echo "Entri crontab berhasil ditambahkan"
    }
    add_cron_entry
else
    echo "Maaf, hanya root yang menjalankan Script Menambahkan Cronjob"
fi
