#!/bin/bash
set -e


# only run the uid/gid creation on first run
if [ ! -f /app/runonce ]; then

   echo "Performing first time setup"
   
   #sanity check uid/gid
   if [ $NZBGET_UID -ne 0 -o $NZBGET_UID -eq 0 2>/dev/null ]; then
      if [ $NZBGET_UID -lt 100 -o $NZBGET_UID -gt 65535 ]; then
         echo "[warn] NZBGET_UID out of (100..65535) range, using default of 500"
         NZBGET_UID=500
      fi
   else
      echo "[warn] NZBGET_UID non-integer detected, using default of 500"
      NZBGET_UID=500
   fi

   if [ $NZBGET_GID -ne 0 -o $NZBGET_GID -eq 0 2>/dev/null ]; then
      if [ $NZBGET_GID -lt 100 -o $NZBGET_GID -gt 65535 ]; then
         echo "[warn] NZBGET_GID out of (100..65535) range, using default of 500"
         NZBGET_GID=500
      fi
   else
      echo "[warn] NZBGET_GID non-integer detected, using default of 500"
      NZBGET_GID=500
   fi

   # add UID/GID or use existing
   groupadd --gid $NZBGET_GID nzbget || echo "Using existing group $NZBGET_GID"
   useradd --gid $NZBGET_GID --no-create-home --uid $NZBGET_UID nzbget
   
   # set runonce so it... runs once
   touch /app/runonce

fi

# copy default nzbget config if none found
if [ -f /config/nzbget.conf ]; then
  echo "nzbget.conf exists"
else
  cp /app/configs/nzbget.conf /config/
fi

# make nzbget destination directory and take control of folders
mkdir -p /downloads/dst
chown -R $NZBGET_UID:$NZBGET_GID /config
chown -R $NZBGET_UID:$NZBGET_GID /downloads


# spin it up
exec su nzbget -c "/usr/bin/nzbget --daemon --configfile /config/nzbget.conf"
                          