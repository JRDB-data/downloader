#!/bin/sh

JRDB_BASE_URL=http://www.jrdb.com/member/data/
EXTENTION=.lzh

filepath() {
  if [ ${FILETYPE} = 'Ks' ]; then
    FILENAME_PREFIX='KZA'
  else
    FILENAME_PREFIX=$(tr '[a-z]' '[A-Z]' <<< $FILETYPE)
  fi

  echo ${FILETYPE}/${FILENAME_PREFIX}${FILEDATE}${EXTENTION}
}

file_exists() {
  curl -u ${JRDB_USER}:${JRDB_PASSWORD} ${JRDB_BASE_URL}$(filepath) -o /dev/null -w '%{http_code}\n' -s
}

download() {
  curl -u ${JRDB_USER}:${JRDB_PASSWORD} ${JRDB_BASE_URL}$(filepath) -L -o ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}$(filepath)
}

decompression() {
  lha -xw=${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE} ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}$(filepath)
}

pre_process() {
  mkdir -p ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE}
}

post_process() {
  rm -f ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}$(filepath)
}

main() {
  pre_process

  STARTDATE=${FILEYEAR}0101
  ENDDATE=${FILEYEAR}1231

  DELTA_S=`expr $(date -d "$ENDDATE" +%s) - $(date -d "$STARTDATE" +%s)`
  DELTA_DAY=`expr ${DELTA_S} / 86400`

  for i in $(seq 0 $DELTA_DAY); do
    FILEDATE=`expr $(date -d "$STARTDATE $i day" +%y%m%d)`

    status_code=`file_exists`
    if [ $status_code != 200 ]
    then
      echo ${JRDB_BASE_URL}$(filepath) is not found.
      continue
    fi

    download
    decompression
    post_process
  done
}

cat <<EOS

Filetype? (ex. Ks)

以下のファイルタイプが選択できます。
===================================
JRDB 騎手データ  : Ks
JRDB 開催データ  : Kab
JRDB 番組データ  : Bac
JRDB 登録馬データ: Kta
JRDB 馬基本データ: Ukc
JRDB 競争馬データ: Kyi
JRDB 成績データ  : Sed 
===================================
EOS

read FILETYPE

cat <<EOS

Fileyear? (ex. 2023)
yyyy の形式で入力してください。
EOS

read FILEYEAR

main
