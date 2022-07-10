#!/bin/bash
LAT_V="$(wget -qO- https://api.github.com/repos/LunaMultiplayer/LunaMultiplayer/releases/latest | jq -r '.tag_name')"
CUR_V="$(find ${DATA_DIR} -name "LMP-v*" 2>/dev/null | cut -d '-' -f2 | sed 's/v//g')"

if [ -z $LAT_V ]; then
  if [ -z $CUR_V ]; then
    echo "---Can't get latest version of Luna Multiplayer, putting container into sleep mode!---"
    sleep infinity
  else
    echo "---Can't get latest version of Luna Multiplayer, falling back to v${CUR_V}---"
    LAT_V=$CUR_V
  fi
fi

if [ -z "${LMP_V}" ]; then
  echo "---No Luna Multiplayer version set, falling back to 'stable'!---"
elif [ "${LMP_V}" == "latest" ]; then
  LMP_V="Release"
elif [ "${LMP_V}" == "nightly" ]; then
  LMP_V="Debug"
else
  echo "---Luna Multiplayer version malformed, falling back to 'stable'!---"
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
  echo "---Luna Multiplayer not found, downloading and installing v${LAT_V}...---"
  cd ${DATA_DIR}
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/LMP-v${LAT_V}-${LMP_V}.zip "https://github.com/LunaMultiplayer/LunaMultiplayer/releases/download/${LAT_V}/LunaMultiplayer-Server-${LMP_V}.zip" ; then
    echo "---Successfully downloaded Luna Multiplayer v${LAT_V}---"
  else
    echo "---Something went wrong, can't download Luna Multiplayer v${LAT_V}, putting container into sleep mode!---"
    sleep infinity
  fi
  unzip -o ${DATA_DIR}/LMP-v${LAT_V}-${LMP_V}.zip
  cp -R ${DATA_DIR}/LMPServer/* ${DATA_DIR}
  rm -rf ${DATA_DIR}/LMPServer
elif [ "${CUR_V}" != "${LAT_V}" ]; then
  echo "---Version missmatch, installed v${CUR_V}, downloading and installing v${LAT_V}...---"
  cd ${DATA_DIR}
  mkdir -p /tmp/LMP
  cp -R ${DATA_DIR}/Config ${DATA_DIR}/Universe ${DATA_DIR}/Plugins ${DATA_DIR}/logs /tmp/LMP 2>/dev/null
  rm -rf ${DATA_DIR}/*
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/LMP-v${LAT_V}-${LMP_V}.zip "https://github.com/LunaMultiplayer/LunaMultiplayer/releases/download/${LAT_V}/LunaMultiplayer-Server-${LMP_V}.zip" ; then
    echo "---Successfully downloaded Luna Multiplayer v${LAT_V}---"
  else
    echo "---Something went wrong, can't download Luna Multiplayer v${LAT_V}, putting container into sleep mode!---"
    echo "---Restoring Backup to server directory!---"
    cp -R /tmp/LMP/Config /tmp/LMP/Universe /tmp/LMP/Plugins /tmp/LMP/logs ${DATA_DIR}/ 2>/dev/null
    rm -rf /tmp/LMP
    sleep infinity
  fi
  cp -R /tmp/LMP/Config /tmp/LMP/Universe /tmp/LMP/Plugins /tmp/LMP/logs ${DATA_DIR}/ 2>/dev/null
  rm -rf /tmp/LMP
  unzip -o ${DATA_DIR}/LMP-v${LAT_V}-${LMP_V}.zip
  cp -R ${DATA_DIR}/LMPServer/* ${DATA_DIR}
  rm -rf ${DATA_DIR}/LMPServer
elif [ "${CUR_V}" == "${LAT_V}" ]; then
  echo "---Luna Multiplayer v${CUR_V} up-to-date---"
fi

echo "---Preparing Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
cd ${DATA_DIR}
dotnet ${DATA_DIR}/Server.dll ${GAME_PARAMS}