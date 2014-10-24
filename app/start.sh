#!/bin/bash
set -e

# only run the uid/gid creation on first run
if [ ! -f /app/runonce ]; then

   echo "Performing first time setup"

   # determine UID
   if [ -z "${NZBGET_UID}" ]; then
      echo "NZBGET_UID not specified, using 500 as a default"
      NZBGET_UID=500
   fi

   # determine GID
   if [ -z "${NZBGET_GID}" ]; then
      echo "NZBGET_GID not specified, using $NZBGET_UID as a default"
      NZBGET_GID=$NZBGET_UID
   fi


   # add UID/GID or use existing
   groupadd --gid $NZBGET_GID nzbget || echo "Using existing group $NZBGET_GID"
   useradd --gid $NZBGET_GID --no-create-home --shell /usr/sbin/nologin --uid $NZBGET_UID nzbget || echo "Using existing user $NZBGET_UID"

   # create startup service
cat > /etc/supervisor/conf.d/nzbget.conf <<EOF
[program:nzbget]
directory=/downloads
command=nzbget -D -c /config/nzbget.conf
user=$NZBGET_UID
autostart=true
autorestart=true
EOF

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
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
                          