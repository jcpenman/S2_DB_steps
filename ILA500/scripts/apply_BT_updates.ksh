#! /bin/ksh

# Build script tp automatically apply BT patches as descibed 
# following the steps described for manual deployment in the
# BT build documentation. 
# Brings together all patch releases from BT to date. 
# (See Modification history for details of last patch added to the script)
# Relevant to the steps database only.
# LOGS are generally created by the individual scripts and 
# this behaviour is not modified. Where possible output is
# captured to a single LOG file determined by the env vars 
# below.
#
# Parameters:
# Ensure ORACLE_SID is set correctly before execution.
# 1 SGAS schema name
# 2 SGAS password
# 3 EDM schema name
# 4 EDM password
# 5 Log file (including full path.)
# 
# Modification History:
# Ref:  Date:   Author:             Desc:
# 001 25.03.08 S Durkin (Sopra UK) Parameterise.
#      04.03.08 S Durkin (Sopra UK) Initial Version
#
# CONFIGURATION MANAGEMENT:
# $HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/scripts/apply_BT_updates.ksh $ 
# $Author: $ 
# $Date: 2008-10-01 14:26:02 +0100 (Wed, 01 Oct 2008) $ 
# $Revision: 1236 $ 
#
RELEASE=/projects/sgas/release/release_versions
# 001:
LOGFILE="`basename $0`".log
if [ $# -eq 0 ]
then
    if [ -f $LOGFILE ]
    then
        mv $LOGFILE $LOGFILE.`date +"%y%m%d%H%M%S"`;
    fi
elif [ $# -eq 5 ]
then
    SGAS=$1/$2
    EDM=$3/$4
    ORACLE_SID=$5
else
    echo "USAGE: $0 <sgas_schema> <password> <edm_schema> <password> <logfile>"
    echo
    exit 1
fi
touch $LOGFILE

log()
{
  echo $* | tee -a $LOGFILE
}

log sgas connection=$SGAS
log edm connection =$EDM
log oracle sid     =$ORACLE_SID

#-----------------------------------------
log === PATCH NO. SGAS8_67 ===
#-----------------------------------------
cd $RELEASE/sgas8_67/dbprocs/steps/.
$RELEASE/sgas8_67/dbprocs/steps/compile_dbprocs $SGAS
# $RELEASE/sgas8_67/dbprocs/steps/edm_index_b.sql
# $RELEASE/sgas8_67/dbprocs/steps/edm_index_s.sql
# $RELEASE/sgas8_67/dbprocs/steps/edm_info_b.sql
# $RELEASE/sgas8_67/dbprocs/steps/edm_info_s.sql
# $RELEASE/sgas8_67/dbprocs/steps/scriptex_b.sql
# $RELEASE/sgas8_67/dbprocs/steps/scriptex_s.sql
(
sqlplus $EDM << !
$RELEASE/sgas8_67/edm_triggers/steps/eat_ins.sql
!
) >> $LOGFILE
wait
export SGASLOGON=$EDM
cd $RELEASE/sgas8_67/edm_triggers/steps/.
make -f $RELEASE/sgas8_67/edm_triggers/steps/triggers.mk triggers
# Recompile all packages
$RELEASE/sgas8_67/dbprocs/steps/db_compile system/password > db_compile.log
# DML
$RELEASE/sgas8_67/release/steps/rfc228edm_for_steps $ORACLE_SID $EDM
$RELEASE/sgas8_67/release/steps/rfc228sgas_for_steps $ORACLE_SID $SGAS
$RELEASE/sgas8_67/release/steps/rfc228raw_data_steps_grass $ORACLE_SID $EDM
$RELEASE/sgas8_67/release/steps/rfc228_syn_for_edm $ORACLE_SID $SGAS
# Recompile all packages
$RELEASE/sgas8_67/dbprocs/steps/db_compile system/password > db_compile.log

#-----------------------------------------
log === PATCH NO. SGAS8_69 ===
#-----------------------------------------
$RELEASE/sgas8_69/release/steps/rfc228edm_for_steps $ORACLE_SID $EDM
$RELEASE/sgas8_69/release/steps/rfc228sgas_for_steps $ORACLE_SID $SGAS
$RELEASE/sgas8_69/release/steps/rfc228raw_data_steps_grass $ORACLE_SID $EDM
export SGASLOGON=$EDM
cd $RELEASE/sgas8_69/edm_triggers/steps/.
make -f $RELEASE/sgas8_69/edm_triggers/steps/triggers.mk triggers
cd $RELEASE/sgas8_69/dbprocs/steps/.
$RELEASE/sgas8_69/dbprocs/steps/compile_dbprocs $SGAS
# $RELEASE/sgas8_69/dbprocs/steps/edm_index_b.sql
# $RELEASE/sgas8_69/dbprocs/steps/edm_index_s.sql
# $RELEASE/sgas8_69/dbprocs/steps/edm_info_b.sql
# $RELEASE/sgas8_69/dbprocs/steps/edm_info_s.sql
# $RELEASE/sgas8_69/dbprocs/steps/scriptex_b.sql
# $RELEASE/sgas8_69/dbprocs/steps/scriptex_s.sql
(
sqlplus $EDM << !
$RELEASE/sgas8_67/edm_triggers/steps/eat_ins.sql
!
) >> $LOGFILE
wait
$RELEASE/sgas8_69/release/steps/rfc228_syn_for_edm $ORACLE_SID $SGAS
$RELEASE/sgas8_69/dbprocs/steps/db_compile system/password >> $LOGFILE

#-----------------------------------------
log === PATCH NO. SGAS8_70 ===
#-----------------------------------------
cd $RELEASE/sgas8_70/release/steps/.
$RELEASE/sgas8_70/release/steps/rfc228_short_app_edm $ORACLE_SID $EDM
$RELEASE/sgas8_70/release/steps/rfc228EDMphase3  $ORACLE_SID $EDM
cd $RELEASE/sgas8_70/dbprocs/steps/.
$RELEASE/sgas8_70/dbprocs/steps/compile_dbprocs $SGAS
# $RELEASE/sgas8_70/dbprocs/steps/shortened_application_web_st_b.sql
# $RELEASE/sgas8_70/dbprocs/steps/shortened_application_web_st_s.sql
$RELEASE/sgas8_70/dbprocs/steps/db_compile system/password >> $LOGFILE
cp $RELEASE/sgas8_70/bin/steps/shwap_import_steps.sh /projects/sgas/bin/.