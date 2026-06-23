CREATE OR REPLACE PACKAGE BODY SGAS.pk_web_edocs
IS
   PROCEDURE pull_web_edocs
   IS
/*
 * Procedure picks up all web changes since the last run date (half an hour ago)
 * and either updates the GRASS (NMSB) or STEPS database. Procedure is called by
 * dbms job on the steps database
 *
 */
 
 
 /*
 Mike Tolmie : 30/06/2016
 CR123 : EDOCS Uploader now adds the coversheet data to edm images if there are additional comments
 and then places a record into EDOC_CDU_TRANSFERRED. This functionality is no longer needed in this
 package.The object_id is not needed in leiu of this change but is provided as it is now contains
 the EDOC transaction_id that can be used in conjunction with the SRN and scan date to uniqiely identify
 an EDOC transaction in EDOC_CDU_TRANSFERRED in order to update the PROCES_INSTANCE_ID
 */
 
 
 begin
select max(scan_date) into v_max_date 
from edoc_cdu@edocs
where object_id is not null;
     
insert into edm.edm_temp
(select object_id, session_code, document_type_code, document_name, document_type_count, attachment_type_code, null
from edoc_cdu@edocs
where object_id is not null
and scan_date <= v_max_date);

insert into edm.edm_complete
(select distinct object_id, null,batch_type_code, srn, null, null, scan_date, 'N', 'N', null, null
from edoc_cdu@edocs
where object_id is not null
and scan_date <= v_max_date);

commit;

--insert into edoc_cdu_transferred@edocs (srn,object_id,transaction_id,batch_type_code,session_code,scan_date,document_type_code,document_name,document_type_count,attachment_type_code)
--select * from edoc_cdu@edocs where object_id is not null and scan_date <= v_max_date;
--commit;

delete from edoc_cdu@edocs
where object_id is not null and scan_date <= v_max_date;

commit;   
     
      
   EXCEPTION
      WHEN OTHERS
      THEN
         

         ROLLBACK;

         
   END pull_web_edocs;
   
END pk_web_edocs;
/
