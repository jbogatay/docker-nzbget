docker-nzbget
================

Ubuntu:1404 based nzbget

Complete run command with all options

    docker run -d -p 6789:6789 -v /myconfgidir:/config -v /mydownloaddir:/downloads -v /etc/localtime:/etc/localtime:ro -e NZBGET_UID=500 -e NZBGET_GID=500 jbogatay/nzbget


Change directory mappings as appropriate (myconfigdir, mydownloaddir)

NZBGET_UID and NZBGET_GID are optional, but will default to 500/500.   Specify the UID/GID that corresponds to the **HOST** UID/GID you want to own the downloads and config directories.