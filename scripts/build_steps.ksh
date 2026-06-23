#! /bin/ksh
# 
# Purpose:
# Control the build of the STEPS database at SAAS.
# Script must be run from the scripts directory.
#
# Parameters:
# none
#
# Inputs (prompted)
# sgas password
# edm password
# target - select from one of
#           :: user (default)
#           :: dev
#           :: sit
#           :: uat
#           :: prod
##
# Modification History:
# Ref:  Date:   Author:             Desc:
#      02.09.08 S Durkin     Add "new" option for DB selection to allow SID to be typed in manually.
#      04.03.08 S Durkin (Sopra UK) Initial Version
#
# CONFIGURATION MANAGEMENT:
# $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/scripts/build_steps.ksh $
# $Author: $
# $Date: 2008-10-01 14:26:02 +0100 (Wed, 01 Oct 2008) $
# $Revision: 1236 $
#

#-----------------------
# Set up user functions
#-----------------------
# Logging
log()
{
  echo $* | tee -a $LOGFILE
}

# debugging
donotrun()
{
 log $*
}

# User exit
userExit () {
rightNow=`date "+%d-%m-%y %H:%M:%S"`
  echo "Build cancelled at $rightNow at user request"
  exit 1;
 }

 # Confirm details before execution:
getConfirmation() {
echo "Target environment: $TARGET_ENV"
echo "sgas schema: $SGAS_SCHEMA"
echo "edm schema: $EDM_SCHEMA"
echo "Target database: $ORACLE_SID"
read ans?"Proceed? [Y/N]? "
if [ $ans != 'Y' ] && [ $ans != 'y' ]
then
  userExit;
else
    rightNow=`date "+%d-%m-%y %H:%M:%S"`
    echo "STEPS build started at $rightNow" >> $LOGFILE
    echo "Target environment: $TARGET_ENV" >> $LOGFILE
    echo "sgas schema: $SGAS_SCHEMA" >> $LOGFILE
    echo "edm schema: $EDM_SCHEMA" >> $LOGFILE
    echo "Target database: $ORACLE_SID" >> $LOGFILE
fi
}

trap 'userExit' INT SIG

#----------------------------------
# Set up the runtime environment
#----------------------------------

# Set default schemas and directories first:
export SGAS_SCHEMA=SGAS
export EDM_SCHEMA=EDM
BUILD_HOME=`cd ../..; pwd`
export BUILD_HOME

if [ ! -d $BUILD_HOME/logs ] 
then
  mkdir $BUILD_HOME/logs; 
fi
export LOGFILE=$BUILD_HOME/logs/steps_build_log.`date +"%y%m%d"`
if [ -f $LOGFILE ]
then
 rm $LOGFILE
fi
touch $LOGFILE
chmod 777 $LOGFILE

# User configuration:
echo "Please select the target environment: "
select TARGET_ENV in   prod  uat sit dev user new  ; 
do 
case $TARGET_ENV in
    prod)export ORACLE_SID="prod" ;;
    uat)  export ORACLE_SID="uat" ;;
    sit)    export ORACLE_SID="STEPSSIT";;
    dev)    export ORACLE_SID="STEPDEVE" ;;
    new)   read ORACLE_SID?"Please enter the ORACLE_SID: " ;
        export ORACLE_SID;;
    *) export ORACLE_SID="STEPDEVE" ;
        export SGAS_SCHEMA="Z311185";
        export EDM_SCHEMA="Z311185";;
esac;
break;
done
GRASS_DB_LINK="GRASS";

# Get passwords:
echo Please enter passwords at the prompt
stty -echo
read SGAS_PWD?"SGAS: "
echo
 read EDM_PWD?"EDM:  "
echo
stty echo

# Set connection strings:
export SGAS_CONN=$SGAS_SCHEMA/$SGAS_PWD@$ORACLE_SID;
export EDM_CONN=$EDM_SCHEMA/$EDM_PWD@$ORACLE_SID;
# echo "Please enter the name of the db_link from STEPS to GRASS:"
# read GRASS_DB_LINK?" > "
echo "Please enter the year of the current application session (for replication of GRASS data to STEPS): "
read APP_SESSION?" > "
echo "Please enter the year of the current travel session (for replication of GRASS data to STEPS): " 
read TRAV_SESSION?" > "

# final confirmation before the job runs - (echo details)
getConfirmation;

# TEST Connection details:
sqlplus -logon -silent $SGAS_SCHEMA/$SGAS_PWD@$ORACLE_SID << !
exit;
!
sgas_status=$?
sqlplus -logon -silent $EDM_SCHEMA/$EDM_PWD@$ORACLE_SID << !
exit;
!
edm_status=$?
if [ sgas_status -ne 0 -o edm_status -ne 0 ]
then 
   echo "Database connection details are not valid. Please check and try again."
   echo $SGAS_CONN
   echo $EDM_CONN
   exit 1
fi

log "-------------------------"
log "Create Database users"
log "-------------------------"
# Create USER ACCOUNTS AS SYS - the following script must be owned by ora102 with suid set.
read ans?"Build accounts? [Y/N]? "
if [ $ans = 'Y' ] || [ $ans = 'y' ]
then
   if [ `ls -l build_user_accounts.ksh | awk '{print $3; }'` = 'ora102' ]
   then
      if [ -u build_user_accounts.ksh ]
      then
         build_user_accounts.ksh
      else
         log "build_user_accounts.ksh owned by ora1092 but suid has not been set"
      fi
   else
      log "build_user_accounts.ksh not owned by user ora102"
   fi
 else
  log "Option not selected"
  log ""
fi

log "-------------------------"
log "Create Database links"
log "-------------------------"
# Create database linkes as SYS user - the following script must be owned by ora102 with suid set.
if [ `ls -l build_db_links.ksh | awk '{print $3; }'` = 'ora102' ]
then
   if [ -u build_db_links.ksh ]
   then
      build_db_links.ksh
   else
      log "build_db_links.ksh is owned by ora1092 but suid is not set. Please set the suid then try again."
      exit 1
   fi
else
   log "build_db_links.ksh is not owned by user ora102. Please set ownership to ora102 and set the suid then try again."
   exit 1
fi

log "-------------------------"
log "Build SGAS schema"
log "-------------------------"
log "SQL to build structures and insert exported ref data:"
(
cd $BUILD_HOME/steps/sgas
sqlplus $SGAS_CONN @BUILD_SGAS.sql
) >> $LOGFILE 2>&1
wait
 log "Flat file data loaded with SQLLDR:"
(
cd $BUILD_HOME/steps/sgas/data
sqlldr $SGAS_CONN parfile=POSTCODE_ARCHIVE.par
) >> $LOGFILE 2>&1
wait
log "Build materialised views of GRASS reference data on steps."
(
cd $BUILD_HOME/steps/sgas/views
build_grass2steps_mviews.sh $SGAS_SCHEMA/$SGAS_PWD $GRASS_DB_LINK $APP_SESSION $TRAV_SESSION
) >> $LOGFILE 2>&1
wait
log "TODO: Build logs for STEPS tables to be published as materialised views on the web DB."
(
cd $BUILD_HOME/steps/scripts
build_mview_logs.sh $SGAS_SCHEMA/$SGAS_PWD@$ORACLE_SID
) >> $LOGFILE 2>&1
wait

log "-------------------------"
log "Recompile invalid objects"
log "-------------------------"
# Recompile the specified schemas. (Connects as SYS - the following script must be owned by ora102 with suid set.)
$BUILD_HOME/scripts/recompile.ksh SGAS

log "-------------------------"
log  "Build EDM schema"
log "-------------------------"
# SQL to build structures:
(
cd $BUILD_HOME/steps/edm
sqlplus $EDM_CONN @BUILD_EDM.sql
) >> $LOGFILE 2>&1
wait

#-------------------------
log "Apply BT Updates"
#-------------------------
. apply_BT_updates.ksh $SGAS_SCHEMA $SGAS_PWD $EDM_SCHEMA $EDM_PWD $LOGFILE

chmod 755 $LOGFILE
