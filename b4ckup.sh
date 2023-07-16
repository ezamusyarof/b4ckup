#!/bin/bash
source /home/eza/Documents/b4ckup/.conf
source /home/eza/Documents/b4ckup/b4ckup-log.sh > /dev/null

# Backup_Information
ID=$(($(getLogID)+1))                               # id untuk log
# DIR=$1                                              # directory data yg mau di backup   (/home/hary)
DIR=$1                                              # directory data yg mau di backup   (/home/hary)
DIR_DEST=$(basename "$DIR")                         # ambil nama folder yg mau dibackup (hary)
FILE_NAME="$(date +%y%m%d-%H%M%S)-$ID-$DIR_DEST"    # bikin nama file                   (230715-140124-1-hary)
FILE_PATH="$FILE_LOCATION/archieve/$FILE_NAME.zip"  # lokasi file setelah di save       (/home/eza/Documents/b4ckup/230715-140124-1-hary.zip)

# Pesan Yang Akan Dikirim
PESAN_INFO="###   B4CKUP FILE INFORMATION   ###
ID                     : $ID
Date                 : $(date +'%A, %d %B %Y')
Folder Name  : $DIR_DEST
Location         : $DIR
Status             : "

# Proses backup file lokal
output=$(cd $DIR/.. 2>&1)                                       # Mengubah direktori ke direktori tujuan
if [ $? -eq 0 ];then
    cd $DIR/..
    zip $FILE_NAME.zip $DIR_DEST/* 2>&1          # Men-zip folder tujuan
    mv $FILE_NAME.zip $FILE_LOCATION/archieve                    # Memindahkan hasil zip ke lokasi penyimpanan

    # Kirim file backup ke telegram
    output=$(curl -F chat_id="$ID_CHAT" -F document=@"$FILE_PATH" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument")
    output_json=$(echo "$output" | jq -c .)
    ok=$(echo "$output_json" | jq -r '.ok')
    
    # Mengirim pesan berhasil/gagal ke telegram
    if [ $? -eq 0 ] && [[ "$ok" == "true" ]];then
        PESAN="$(date +%H:%M:%S) WIB - Backup Data Berhasil! 📂"
        PESAN_INFO=$PESAN_INFO"Success 📂"
        echo $PESAN
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$ID_CHAT" -d "text=$PESAN" > /dev/null
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$ID_CHAT" -d "text=$PESAN_INFO" > /dev/null
        addLog $FILE_NAME $DIR 1
        exit 1
    fi
fi

PESAN="$(date +%H:%M:%S) WIB - Backup Data Gagal! ⚠️"
echo $PESAN
echo "Silakan periksa pesan error (.error) atau file konfigurasi anda (.conf)"
PESAN_INFO=$PESAN_INFO"Failed ⚠️"
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$ID_CHAT" -d "text=$PESAN" > /dev/null
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$ID_CHAT" -d "text=$PESAN_INFO" > /dev/null
addLog $FILE_NAME $DIR 0
echo "$(date +"%Y-%m-%d %H:%M:%S") Error: $output" >> $FILE_LOCATION/".error"