#!/bin/sh

FILETYPES=("Ks" "Kab" "Bac" "Kta" "Ukc" "Kyi" "Sed")

cat <<EOS

Filedate? (ex. 220319)
yymmdd の形式で入力してください。
EOS

read FILEDATE

for FILETYPE in "${FILETYPES[@]}"
do
sh $(dirname $0)/downloader.sh << EOS
${FILETYPE}
${FILEDATE}
EOS
done
