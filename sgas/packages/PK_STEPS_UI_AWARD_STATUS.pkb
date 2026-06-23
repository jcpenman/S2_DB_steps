CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_UI_AWARD_STATUS AS
/******************************************************************************
   NAME:       PK_STEPS_UI_AWARD_STATUS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/10/2015  Sruesh Sharada   1. Created this package body.
******************************************************************************/

PROCEDURE insertawardstatus (
      stud_crse_year_id_in         IN       NUMBER,
      award_type_in                IN       VARCHAR2,
      award_status_message_id_in   IN       NUMBER,
      cancelled_ind_in              IN       VARCHAR2,
      user_id_in                    IN      VARCHAR2,
      error_boolean             OUT      VARCHAR2,
      ERROR_TEXT                OUT      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO stud_award_status
                  (STUD_CRSE_YEAR_ID, AWARD_TYPE, 
                  AWARD_STATUS_MESSAGE_ID, CANCELLED_IND, LAST_UPDATED_BY)
           VALUES (stud_crse_year_id_in, award_type_in,
                   award_status_message_id_in, cancelled_ind_in, user_id_in);

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertawardstatus;

   PROCEDURE getawardstatus (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor           IN OUT          award_status_cursor,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
      award_cursor   award_status_cursor;
   BEGIN
      OPEN award_cursor FOR
         SELECT sas.stud_award_status_id AS stud_award_status_id_out, 
                sas.stud_crse_year_id AS stud_crse_year_id_out,
                sas.award_type AS award_type_out,
                sas.award_status_message_id AS award_status_message_id_out, 
                sas.cancelled_ind AS cancelled_ind_out,
                asm.award_status AS status_out,
                asm.description AS description_out
                
          FROM stud_award_status sas, award_status_message asm
          WHERE sas.stud_crse_year_id = stud_crse_year_id_in
          AND sas.award_status_message_id = asm.award_status_message_id;

      io_cursor := award_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getawardstatus;


PROCEDURE updateawardstatus (      
      stud_crse_year_id_in        	IN       VARCHAR2,
      fees_in                     	IN       VARCHAR2,
      loan_in                     	IN       VARCHAR2,
      lp_grant_in                 	IN       VARCHAR2,
      bursary_in                  	IN       VARCHAR2,
      dep_grant_in                	IN       VARCHAR2,
      care_exp_bursary_in         	IN       varchar2,
      pg_ed_psych_fees_in          	IN       VARCHAR2,
      pg_ed_psych_qeps_in          	IN       VARCHAR2,
      pg_ed_psych_grant_in          IN       VARCHAR2,    
      pg_ed_psych_fees_phd_in       IN       VARCHAR2,
      pg_ed_psych_grant_phd_in		IN       VARCHAR2,	  
      user_id_in                  	IN       VARCHAR2,
      error_boolean               	OUT      VARCHAR2,
      ERROR_TEXT                  	OUT      VARCHAR2
   )
   IS
   
   row_count NUMBER;
   
   BEGIN
    
    IF(fees_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = fees_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'FEES', fees_in,user_id_in); 
        END IF;
    END IF;
    
    IF(loan_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LOAN';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = loan_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LOAN';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'LOAN', loan_in,user_id_in); 
        END IF;
    END IF;
    
    IF(bursary_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='BURSARY';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = bursary_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='BURSARY';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'BURSARY', bursary_in,user_id_in); 
        END IF;
    END IF;
    
    IF(dep_grant_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = dep_grant_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'DEPENDANTS GRANT', dep_grant_in,user_id_in); 
        END IF;
    END IF;
        
    IF(lp_grant_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LONE PARENT GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = lp_grant_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LONE PARENT GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'LONE PARENT GRANT', lp_grant_in,user_id_in); 
        END IF;
    END IF;
    
    IF(care_exp_bursary_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CARE EXPERIENCED BURSARY';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = care_exp_bursary_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CARE EXPERIENCED BURSARY';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'CARE EXPERIENCED BURSARY', care_exp_bursary_in,user_id_in); 
        END IF;
    END IF;
    
    IF(pg_ed_psych_fees_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDF';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_fees_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDF';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PGEDF', pg_ed_psych_fees_in,user_id_in); 
        END IF;
    END IF;
    
    IF(pg_ed_psych_qeps_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDQ';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_qeps_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDQ';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PGEDQ', pg_ed_psych_qeps_in,user_id_in); 
        END IF;
    END IF;    
    
    IF(pg_ed_psych_grant_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDG';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_grant_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDG';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PGEDG', pg_ed_psych_grant_in,user_id_in); 
        END IF;
    END IF;    
    
    IF(pg_ed_psych_fees_phd_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDFP';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_fees_phd_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDFP';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PGEDFP', pg_ed_psych_fees_phd_in,user_id_in); 
        END IF;
    END IF;	
	
    IF(pg_ed_psych_grant_phd_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDGP';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_grant_phd_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PGEDGP';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PGEDGP', pg_ed_psych_grant_phd_in,user_id_in); 
        END IF;
    END IF;    	
	
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateawardstatus;

PROCEDURE updateawardstatusNMSB (
      
      stud_crse_year_id_in        IN       VARCHAR2,
      nmsb_fees_in                IN       VARCHAR2,      
      nmsbbursary_in              IN       VARCHAR2,
      nmsb_dep_allow_in           IN       VARCHAR2,
      nmsb_sp_allow_in            IN       VARCHAR2,
      nmsb_childcare_allow_in     IN       VARCHAR2,
      user_id_in                  IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2
   )
   IS
   
   row_count NUMBER;
   
   BEGIN

    IF(nmsb_fees_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_fees_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'FEES', nmsb_fees_in,user_id_in); 
        END IF;
    END IF;
   
    IF(nmsbbursary_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type LIKE '%NURSING AND MIDWIFERY BURSARY';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsbbursary_in, award_type = 'PARAMEDIC, NURSING AND MIDWIFERY BURSARY',  last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type LIKE '%NURSING AND MIDWIFERY BURSARY';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PARAMEDIC, NURSING AND MIDWIFERY BURSARY', nmsbbursary_in,user_id_in); 
        END IF;
    END IF;
    
    IF(nmsb_dep_allow_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS ALLOWANCE';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_dep_allow_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS ALLOWANCE';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'DEPENDANTS ALLOWANCE', nmsb_dep_allow_in,user_id_in); 
        END IF;
    END IF;
    
    IF(nmsb_sp_allow_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='SINGLE PARENTS ALLOWANCE';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_sp_allow_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='SINGLE PARENTS ALLOWANCE';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'SINGLE PARENTS ALLOWANCE', nmsb_sp_allow_in,user_id_in); 
        END IF;
    END IF;
    
    IF(nmsb_childcare_allow_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CHILDCARE ALLOWANCE FOR PARENTS';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_childcare_allow_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CHILDCARE ALLOWANCE FOR PARENTS';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'CHILDCARE ALLOWANCE FOR PARENTS', nmsb_childcare_allow_in,user_id_in); 
        END IF;
    END IF;
        
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateawardstatusNMSB;



PROCEDURE updateawardstatuswithID (
      
      stud_crse_year_id_in        IN       NUMBER,
      award_type_in               IN       VARCHAR2,
      award_status_message_id_in  IN       NUMBER,
      user_id_in                  IN       VARCHAR2,
      error_boolean               OUT      VARCHAR2,
      ERROR_TEXT                  OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE stud_award_status
         SET award_status_message_id = award_status_message_id_in,
             last_updated_by=user_id_in,
             last_updated_on=SYSDATE
     
     WHERE stud_crse_year_id = stud_crse_year_id_in AND award_type = award_type_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateawardstatuswithID;

PROCEDURE getawardstatusmessages (
      io_cursor           IN OUT          award_status_cursor,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   )
   IS
      award_cursor   award_status_cursor;
   BEGIN
      OPEN award_cursor FOR
         SELECT award_status_message_id, award_status, description  
         FROM award_status_message;
          
      io_cursor := award_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getawardstatusmessages;


END PK_STEPS_UI_AWARD_STATUS;
/
