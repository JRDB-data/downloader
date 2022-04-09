#!/bin/sh

JRDB_BASE_URL=http://www.jrdb.com/member/data/
EXTENTION=.lzh

filepath() {
  FILENAME_PREFIX=${FILETYPE}/$(tr '[a-z]' '[A-Z]' <<< $FILETYPE)_
  echo ${FILENAME_PREFIX}${YEAR}${EXTENTION}
}

file_exists() {
  curl -u ${JRDB_USER}:${JRDB_PASSWORD} ${JRDB_BASE_URL}$(filepath) -o /dev/null -w '%{http_code}\n' -s
}

pre_process() {
  mkdir -p ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE}/${YEAR}
}

download() {
  curl -u ${JRDB_USER}:${JRDB_PASSWORD} ${JRDB_BASE_URL}$(filepath) -L -o ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE}/${YEAR}/tmp${EXTENTION}
}

decompression() {
  lha -xw=${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE}/${YEAR} ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE}/${YEAR}/tmp${EXTENTION}
}

post_process() {
  rm -f ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}${FILETYPE}/${YEAR}/*${EXTENTION}
}

main() {
  pre_process

  status_code=`file_exists`
  if [ $status_code != 200 ]
  then
    echo ${JRDB_BASE_URL}$(filepath) is not found.
    exit 0
  fi

  download
  decompression
  post_process
}

cat <<EOS

Filetype? (ex. Ukc)

以下のファイルタイプが選択できます。
===================================
JRDB 馬基本データ: Ukc
===================================
EOS

read FILETYPE

cat <<EOS

Fileyear? (ex. 2021)
YYYY の形式で入力してください。
EOS

read YEAR

main
