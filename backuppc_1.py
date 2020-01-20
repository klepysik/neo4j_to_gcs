#!/usr/bin/env python

import os.path, time

######################################
# First we print current time

now = time.time()

######################################
#Then we list the files in the folder and print their time


fileCreation = os.path.getctime('/Users/olgakurtzer/Downloads')
time.ctime(os.path.getctime('/Users/olgakurtzer/Downloads'))

######################################
# Compare current date with the files modification date

twodays_ago = now - 60*60*24*2 # Number of seconds in two days
if fileCreation < twodays_ago:
    print "File is more than two days old"
else:
    print "File is less than two days old"

#if (file_mod_time - should_time) < args.time:
 #   print "CRITICAL: {} last modified {:.2f} minutes. Threshold set to 30 minutes".format(last_time, file, last_time)
#else:
 #   print "OK. Command completed successfully {:.2f} minutes ago.".format(last_time)


######################################
# send information to signalfx

