#!/bin/sh
#
# File   : mail-wrapper.sh
# Author : Len Kawamoto (len.kawamoto@gmail.com)
# Date   : March 4, 2021 (Happy Marching Music Day!)
# Version: 1.0
#
# apcupsd relies on the OS's mail command for event notifications, but the
# dockerized system doesn't have it installed.  This results in no mail
# notifications being delivered to the sysadmin.
#
# This script is a wrapper to provide a mechanism to call sendmail (which
# is provided by busybox) in order to do the mail notifications.
#
# Since this script uses STARTTLS when connecting to the SMTP server,
# it also depends on openssl, but will auto-install the package using apk
# if it doesn't locate the binary.
#
#
#
# Installation
# ------------
#   1. edit the configuration values (below) to meet your needs
#
#   2. map this script to the container in /usr/local/sbin (or any other
#   location in the $PATH).
#         docker -v ./mail-wrapper.sh:/usr/local/sbin/mail ...
#      OR
#         volumes:
#           - ./mail-wrapper.sh:/usr/local/sbin/mail
#
##############################################################################
#
# Configuration
#

# The full path to our logfile
#    Hint: comment out (and don't set) logfile to disable logging
#
#    Hint: map the log directory to your host
#             docker -v ./logs:/var/log/apcupsd ...
#          OR
#             volumes:
#               - ./logs:/var/log/apcupsd
logfile="/var/log/apcupsd/mail.log"

# The TO email address (the recipient of the mail notifications)
mailTo="sysadmin@my.domain"

# The FROM email address (the sender of the mail notifications)
mailFrom="apcupsd@my.domain"

# The next 2 config items define the SMTP server to which this script
# will communicate.  You might use your ISP provided smtp server
# or google, yahoo, hotmail, or some other email provider.
#
# The smtp server name/address
#    Hint: Be sure to use an smtp server that enforces STARTTLS
mailServer="smtp.my.isp"

# The smtp server port number
#    Hint: Be sure to select a port that supports STARTTLS
mailPort=807

# The next 2 authentication config items are for allowing this script
# to send email through the above defined smtp server.  Most (if not all)
# require authentication to prevent spam-bots from relaying through their
# servers.
#
# If you're provider allows for "Application Specific Passwords", you might
# consider using that feature to help protect your account.
#
# The smtp authentication username
mailUsername="smtp-user@my.domain"

# The smtp authentication password
mailPassword="superstrongpassword"

#
# You probably don't need to modify this value, unless you're experimenting...
#
# The full path to the openssl binary
openssl="/usr/bin/openssl"

##############################################################################
#
# You shouldn't have to change anything below here.
#

myLog() {
   if [ ! -z "$logfile" ]; then
      # for busybox DATE command
      echo -e "$(date -Iseconds | tr 'T' ' ') $@" >> $logfile
      #
      # for GNU coreutils DATE command
      #echo "$(date --rfc-3339=seconds) $@" >> $logfile
   fi
}

myLog "--- Start of script ---"

# Check that openssl exists so that we can do STARTTLS from sendmail
if [ ! -f $openssl ]; then
   # it's not found, so let's install it
   myLog "openssl is missing!"
   apk add openssl
   if [ $? -eq 0 ]; then
      myLog "Successfully installed openssl"
   else
      # we had an error during the apk add command
      myLog "Failed to install openssl"
      exit 1
   fi
fi

myMessage=`cat`
#myLog "Message:\n$myMessage\n--- --- ---"
echo "$myMessage" | sendmail -H "openssl s_client -quiet -tls1 -starttls smtp -connect $mailServer:$mailPort" -f "$mailFrom" -amLOGIN -au"$mailUsername" -ap"$mailPassword" $mailTo
if [ $? -eq 0 ]; then
   myLog "sendmail completed successfully!"
else
   myLog "sendmail returned an error"
fi

myLog "--- End of script ---"
