CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_deceasedStudent
AS
/******************************************************************************
   NAME:       pk_steps_ui_deceasedStudent
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0       09/08/2016  SURESH SHARADA            Created this package.
 ******************************************************************************/
   PROCEDURE getDeceasedStatus (
      stud_ref_no_in        IN              NUMBER,
      latest_session_in     IN              VARCHAR2,
      io_cursor        IN OUT          deceased_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      error_text       OUT NOCOPY      VARCHAR2
   )
   IS
      dcd_cursor deceased_cursor;
   BEGIN
         OPEN dcd_cursor FOR
         
         
         SELECT st.deceased_flag as deceased_flag_out,
            TO_CHAR (scy.withdraw_date, 'DD/MM/yyyy') as withdraw_date_out,
            scy.stud_crse_year_id as stud_crse_year_id
            FROM stud st, stud_crse_year scy
            WHERE st.stud_ref_no = stud_ref_no_in and scy.stud_ref_no = stud_ref_no_in and scy.latest_crse_ind='Y' and scy.session_code= latest_session_in; 
      
        io_cursor := dcd_cursor;
   
      error_boolean := 'false';
      error_text := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getDeceasedStatus;

   PROCEDURE updateDeceasedStudent (
      stud_ref_no_in        IN       NUMBER,
      date_of_death_in     IN       DATE,
      deceased_Source_in   IN       VARCHAR2,
      latest_session_in     IN      VARCHAR2,
      error_boolean     OUT      VARCHAR2,
      error_text        OUT      VARCHAR2
   )
   IS
   BEGIN
       UPDATE stud
         SET deceased_flag = 'Y',
             deceased_source = UPPER(deceased_source_in) 
       WHERE stud_ref_no = stud_ref_no_in;
        
       UPDATE stud_crse_year
         SET withdraw_date = date_of_death_in
       WHERE stud_ref_no = stud_ref_no_in and latest_crse_ind= 'Y' and session_code = latest_session_in;

      error_boolean := 'false';
      error_text := 'none';
      COMMIT;
      
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateDeceasedStudent;
 PROCEDURE finaliseBenefactorAllSession(
    
    stud_ref_no_in           IN      NUMBER,
      error_boolean        OUT      VARCHAR2,
      error_text           OUT      VARCHAR2
  )
  IS
  
  BEGIN
  
  
      UPDATE benefactor_income
        SET income_status = 'F',
       p60_req = 'N',
       sched_d_req = 'N',
       sched_A_req = 'N',
       pension_cb = 'N',
       oth_deducts_cb = 'N',
       wtc_CB = 'N',
       benEfit_CB = 'N'
    WHERE BEN_ID IN (SELECT BEN1_ID FROM STUD_SESSION WHERE STUD_REF_NO = stud_ref_no_in UNION SELECT BEN2_ID FROM STUD_SESSION WHERE STUD_REF_NO = stud_ref_no_in);
    
       UPDATE stud_crse_year
         SET PROVISIONAL_CASE = 'N'
       WHERE stud_ref_no = stud_ref_no_in;

      error_boolean := 'false';
      error_text := 'none';
      COMMIT;
      
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
    
  END finaliseBenefactorAllSession;
   
 PROCEDURE CheckSLCExists(
     stud_ref_no_in           IN      NUMBER,
     slc_exists_out           OUT     VARCHAR2,
     error_boolean            OUT      VARCHAR2,
     error_text             OUT      VARCHAR2
      
)IS
slccount NUMBER:=0;
slcflcount NUMBER:=0;
BEGIN
          
      select count(*) INTO slccount from stud_crse_year where stud_ref_no=stud_ref_no_in and slc1_sent='Y';
      select count(*) INTO slcflcount from stud_session where stud_ref_no=stud_ref_no_in and SLC1_FL_SENT='Y';
        
    IF(slccount=0 and slcflcount=0)
        THEN
            slc_exists_out := 'FALSE';
        ELSE
            slc_exists_out := 'TRUE';
    END IF;

      error_boolean := 'false';
      error_text := 'none';
      
EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         error_text := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
      
END CheckSLCExists;
   
END pk_steps_ui_deceasedStudent;
/
