#!/bin/bash
# Apache Process Monitor
# Restart Apache Web Server When It Goes Down
# -------------------------------------------------------------------------
# RHEL / CentOS / Fedora Linux restart command
RESTART="/sbin/service httpd restart"
 
# uncomment if you are using Debian / Ubuntu Linux
#RESTART="/etc/init.d/apache2 restart"
 
#path to pgrep command
PGREP="/usr/bin/pgrep"
 
# Httpd daemon name,
# Under RHEL/CentOS/Fedora it is httpd
# Under Debian 4.x it is apache2
HTTPD="httpd"
 
# find httpd pid
$PGREP ${HTTPD}
 
if [ $? -ne 0 ] # if apache not running 
then
 # restart apache
 $RESTART
fi
