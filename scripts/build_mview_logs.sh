#!/bin/sh
#
# DESCRIPTION
# ===========
#
# Recreate the materialized view logs in the STEPS database.
# The logs hold DML details & are required for fast refresh.
#
# This script should be run against the STEPS database prior to build_steps_web_mviews.sh being
# run against the WEB database.
#
# MODIFICATION HISTORY:
# Ref      Date        Author                                  Desc.
#            28.02.08   S Durkin (Sopra UK)         Initial Version.
#
# Configuration Management:
# $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/scripts/build_mview_logs.sh $
# $Author: $
# $Date: 2008-10-01 14:26:02 +0100 (Wed, 01 Oct 2008) $
# $Revision: 1236 $

# Check usage
if [ $# -ne 1 ]
then
  echo "USAGE: $0 <connect_string>"
  echo
  echo "e.g. $0 sgas/[password]@stepdeve"
  echo
  exit 1
fi

# Assign parameter values
CONNECTSTRING=$1

# Assign internal script/file names
LOGFILE=`basename $0 .sh`.out
SQLSCRIPT=`basename $0 .sh`.sql

echo "Creating SGAS materialized view logs..."
#echo "Run for $CONNECTSTRING [Y/N]?"
#read ans
#if [ $ans != 'Y' ] && [ $ans != 'y' ]
#then
  #echo "Execution terminated without action on user request." | tee $LOGFILE
  #exit 1;
#fi

if [ ! $?ORACLE_HOME ]
then
  echo "ERROR: Exiting because ORACLE_HOME not set"
  exit 1
fi

ORA_VER=`echo $ORACLE_HOME | awk -F\/ '{print $NF}'`
SNAP_OPT=" "

echo Creating objects...
(
sqlplus -s $CONNECTSTRING << sqlsnip
@$SQLSCRIPT
sqlsnip
) | tee  $LOGFILE

echo "Complete. The materialised views may now be built on the web database."
