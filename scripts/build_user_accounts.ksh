#! /bin/ksh
# 
# CONNECTIONS: (Hard coded)
# gv36eda: This script MUST be owned by ora102 with the su id bit set,
# this will allow an externally identified connection to the database as SYS.
#
# PURPOSE:
# Control the build of user accounts on the STEPS database at SAAS.
# This script must be run from the scripts directory.
#
# PARAMETERS:  
# None
#
# Modification History:
# Ref:  Date:   Author:             Desc:
#      04.03.08 S Durkin (Sopra UK) Initial Version
#
# CONFIGURATION MANAGEMENT:
# $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/scripts/build_user_accounts.ksh $
# $Author: $
# $Date: 2008-10-01 14:26:02 +0100 (Wed, 01 Oct 2008) $
# $Revision: 1236 $
#

 read CONTINUE?"Build StEPS user accounts? >  "
if [ $CONTINUE = "y" 
read ans?"Proceed? [Y/N]? "
if [ $ans != 'Y' ] && [ $ans != 'y' ]
then
  exit;
else
(
sqlplus / as sysdba @../USER_CREATE.sql
) >>   $LOGFILE 2>&1
wait
fi