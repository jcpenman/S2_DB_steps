CREATE OR REPLACE PACKAGE BODY SGAS.EDOC_REPORT
AS

--REPORT WILL BE OPEN AND CLOSED
--PREVIOUS SESSIONS
--DO NOT INCLUDE WEB_COVERSHEET OR WEB_DSA_COVER
--Determine the theoretical workque using the code found in
--FS_determineWorkQueue flow service
--BATCH TYPE is always 34 or 35 for EDOCS
--Batch type 35 is ALWAYS DSA workqueue
--**** CRSE is a VIEW on StEPS DB : the materialized view of this on WEB db does NOT include the pams_course column.
--therefore, this code MUST be run on the StEPS db.
--EDOC_CDU_TRANSFERRED is current session
--EDOC_CDU_TRANSFERRED_HISTORY is previous sessions

FUNCTION ComputeTheoreticalWorkQueue(crseErrorInd IN VARCHAR2,batchTypeCode IN VARCHAR2,locationInd IN VARCHAR2,nonPublicFund IN VARCHAR2,eu IN VARCHAR2,pams IN varchar2, schemeType IN VARCHAR2)
return VARCHAR2
IS

retVal VARCHAR2(20);

BEGIN
IF crseErrorInd = 'true' THEN
retVal:='ERROR:Invalid Course';
ELSIF batchTypeCode = '35' THEN
retVal:='DSA';
ELSIF schemeType IN ('P','p') THEN
retVal:='PG';
ELSIF locationInd IN ('2','3','4','5','6','7') THEN
retVal:='RUK';
ELSIF eu IN ('Y','y') THEN
retVal:='EU';
ELSIF pams IN ('Y','y') THEN
retVal:='AHP';
ELSIF schemeType in ('B','b') THEN
retVal:='NMSB';
ELSIF nonPublicFund IN ('Y','y') THEN
retVal:='RUK';
ELSE
retVal:='UG';
END IF;

RETURN retVal;
END ComputeTheoreticalWorkQueue;


PROCEDURE CreateALLEDOCTaskReport(retVal IN OUT VARCHAR2)
IS

--Define the cursor that will contain the calculated records from EDOC_CDU_TRANSFERRED + EDOC_CDU_TRANSFERRED_HISTORY combined with calculated data from StEPS tables utilising the locally defined function
--Codefix Defect 21 : use CONFIG EDM for document type name
--Codefix Defect 22 : Solved by codefix for CR123 but highlighted potential problem with use of COURSE_YEAR table for EU_FLAG : Now using STUD_SESSION
--Note that manual register by test team may not set the EU_FLAG in STUD_SESSION automatically.
--Defect 24 :Check for null crse_year_id in scy and report course data error. 



CURSOR EDOC_CUR IS
select cduh.SRN,
SGAS.EDOC_REPORT.ComputeTheoreticalWorkQueue(
--First parameter is an error indicator. There is a null crse_year_id in scy
CASE
WHEN SCY.CRSE_YEAR_ID IS NULL
THEN 'true'
ELSE 'false'
END,
cduh.BATCH_TYPE_CODE,
nst.LOCATION_IND,
nst.NON_PUBLIC_FUND,
sts.EU_FLAG,
C.PAMS_COURSE,
C.SCHEME_TYPE) AS WORKQUEUE,cduh.SESSION_CODE,cduh.SCAN_DATE,cedm.DOCUMENT_TYPE_NAME,scy.INST_NAME
from EDOC_CDU_TRANSFERRED_HISTORY@EDOCS cduh, STUD_CRSE_YEAR scy, INST nst, STUD_SESSION sts, CRSE c, CONFIG_EDM cedm
where cduh.DOCUMENT_TYPE_CODE NOT IN ('WEB_COVERSHEET','WEB_DSA_COVER')
AND cduh.DOCUMENT_TYPE_CODE = cedm.DOCUMENT_TYPE_CODE --GUARANTEED
AND cduh.SRN = scy.STUD_REF_NO --GUARANTEED
AND cduh.SESSION_CODE = scy.SESSION_CODE --GUARANTEED
AND scy.LATEST_CRSE_IND = 'Y' --GUARANTEED
AND nst.INST_CODE(+) = scy.INST_CODE
AND STS.STUD_SESSION_ID = SCY.STUD_SESSION_ID
AND C.CRSE_ID(+) = SCY.CRSE_ID
UNION ALL
select cduh.SRN,
SGAS.EDOC_REPORT.ComputeTheoreticalWorkQueue(
CASE
WHEN SCY.CRSE_YEAR_ID IS NULL
THEN 'true'
ELSE 'false'
END,
cduh.BATCH_TYPE_CODE,
nst.LOCATION_IND,
nst.NON_PUBLIC_FUND,
sts.EU_FLAG,
C.PAMS_COURSE,
C.SCHEME_TYPE) AS WORKQUEUE,cduh.SESSION_CODE,cduh.SCAN_DATE,cedm.DOCUMENT_TYPE_NAME,scy.INST_NAME   
from EDOC_CDU_TRANSFERRED@EDOCS cduh, STUD_CRSE_YEAR scy, INST nst, STUD_SESSION sts, CRSE c, CONFIG_EDM cedm
where cduh.DOCUMENT_TYPE_CODE NOT IN ('WEB_COVERSHEET','WEB_DSA_COVER')
AND cduh.DOCUMENT_TYPE_CODE = cedm.DOCUMENT_TYPE_CODE
AND cduh.SRN = scy.STUD_REF_NO
AND cduh.SESSION_CODE = scy.SESSION_CODE
AND scy.LATEST_CRSE_IND = 'Y'
AND nst.INST_CODE(+) = scy.INST_CODE
AND STS.STUD_SESSION_ID = SCY.STUD_SESSION_ID
AND C.CRSE_ID(+) = SCY.CRSE_ID;


--Define atype that is a  structure of EDOC_CUR records that we can bulk collect the cursor into that we can then iterate over
--TYPE EDOC_ALL_TASK_REPORT_COLL IS TABLE OF EDOC_CUR%ROWTYPE;
--Define the instance variable of this type
--edoc_cur_collection  EDOC_ALL_TASK_REPORT_COLL;

BEGIN

    --Truncate cannot be rolled back so use a delete from
    DELETE FROM SGAS.EDOC_ALL_TASK_LIST;

    for EDOC_REC in EDOC_CUR 
    LOOP
        INSERT INTO SGAS.EDOC_ALL_TASK_LIST VALUES(EDOC_REC.SRN,EDOC_REC.SESSION_CODE,EDOC_REC.INST_NAME,EDOC_REC.WORKQUEUE,EDOC_REC.DOCUMENT_TYPE_NAME,EDOC_REC.SCAN_DATE);
    END LOOP;
    COMMIT;
    
    retVal:='PASS';
    

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    retVal:='FAIL : SGAS.EDOC_REPORT.CreateALLEDOCTaskReport ERROR : ' || SQLCODE || ' : ' || SQLERRM;
    

END CreateALLEDOCTaskReport;

   
END EDOC_REPORT;
/