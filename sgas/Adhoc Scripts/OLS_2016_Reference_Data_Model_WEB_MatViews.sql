--------------------------------------- CREATE MATERIALISED VIEWS ON WEB PORTAL ------------------------------


------------------CONFIG_DATA---------------------
DROP MATERIALIZED VIEW CONFIG_DATA;

CREATE MATERIALIZED VIEW CONFIG_DATA 
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST
WITH PRIMARY KEY
 
AS 
SELECT item_name,
       dval,
       cval,
       nval
  FROM config_data@steps.world;
 
------------------TITLE----------------------------
DROP MATERIALIZED VIEW TITLE;

CREATE MATERIALIZED VIEW TITLE
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST
WITH PRIMARY KEY
 
AS 
SELECT title_id,
       descript,
       legacy_code,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM title@steps.world;
-------------------MARITAL_STATUS---------------------------
DROP MATERIALIZED VIEW MARITAL_STATUS;

CREATE MATERIALIZED VIEW MARITAL_STATUS 
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST
WITH PRIMARY KEY
 
AS 

SELECT marital_status_id,
       descript,
       legacy_code,
	   is_single,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM marital_status@steps.world;

 ------------------CONTACT_RELATIONSHIP----------------------------
DROP MATERIALIZED VIEW CONTACT_RELATIONSHIP;

CREATE MATERIALIZED VIEW CONTACT_RELATIONSHIP
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT contact_relationship_id,
       descript,
       reltype,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM contact_relationship@steps.world;

 ------------------BENEFACTOR_RELATION----------------------------
DROP MATERIALIZED VIEW BENEFACTOR_RELATION;

CREATE MATERIALIZED VIEW BENEFACTOR_RELATION
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT benefactor_relation_id,
       descript,
       legacy_id,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM benefactor_relation@steps.world;

 ------------------STUD_INCOME_TYPE---------------------------
DROP MATERIALIZED VIEW STUD_INCOME_TYPE;

CREATE MATERIALIZED VIEW STUD_INCOME_TYPE
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT income_type_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM stud_income_type@steps.world;

 ------------------SUPP_GRANT_RELATION----------------------------
DROP MATERIALIZED VIEW SUPP_GRANT_RELATION ;

CREATE MATERIALIZED VIEW SUPP_GRANT_RELATION 
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT supp_grant_relation_id,
       descript,
       legacy_id,
	   is_adult,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM supp_grant_relation@steps.world;

 ------------------COUNTRY----------------------------
DROP MATERIALIZED VIEW COUNTRY;

CREATE MATERIALIZED VIEW COUNTRY
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT country_code,
       long_name,
       nationality_name,
	   uk_country,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM country@steps.world;

 ------------------EU_PORTABILITY----------------------------
DROP MATERIALIZED VIEW EU_PORTABILITY;

CREATE MATERIALIZED VIEW EU_PORTABILITY
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT inst_code
   FROM eu_portability@steps.world;

 ------------------NATIONALITY----------------------------
DROP MATERIALIZED VIEW NATIONALITY;

CREATE MATERIALIZED VIEW NATIONALITY
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT nationality_id,
       country_code,
       nationality_name,
	   nationality_region,
	   last_updated_by,
	   last_updated_on,
	   is_active
  FROM nationality@steps.world;

 ------------------STUDENT_FAMILY_RELATIONSHIP----------------------------
DROP MATERIALIZED VIEW STUDENT_FAMILY_RELATIONSHIP;

CREATE MATERIALIZED VIEW STUDENT_FAMILY_RELATIONSHIP
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT student_family_relationship_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM student_family_relationship@steps.world;


 ------------------WHAT_DOING----------------------------
DROP MATERIALIZED VIEW WHAT_DOING;

CREATE MATERIALIZED VIEW WHAT_DOING
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT what_doing_id,
       description,
       organisation_req,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM what_doing@steps.world;

 ------------------REASON_NO_BEN_INCOME----------------------------
DROP MATERIALIZED VIEW REASON_NO_BEN_INCOME;

CREATE MATERIALIZED VIEW REASON_NO_BEN_INCOME
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT reason_no_ben_income_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM reason_no_ben_income@steps.world;

 ------------------REASON_FOR_ONE_BEN----------------------------
DROP MATERIALIZED VIEW REASON_FOR_ONE_BEN;

CREATE MATERIALIZED VIEW REASON_FOR_ONE_BEN
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT reason_for_one_ben_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM reason_for_one_ben@steps.world;

 ------------------ENQUIRY_OPTION----------------------------
DROP MATERIALIZED VIEW ENQUIRY_OPTION;

CREATE MATERIALIZED VIEW ENQUIRY_OPTION
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT enquiry_option_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM enquiry_option@steps.world;

 ------------------ACCOUNT_LOCK_REASON----------------------------
DROP MATERIALIZED VIEW ACCOUNT_LOCK_REASON;

CREATE MATERIALIZED VIEW ACCOUNT_LOCK_REASON
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT account_lock_reason_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM account_lock_reason@steps.world;

  ------------------ACCOUNT_UNLOCK_REASON----------------------------
DROP MATERIALIZED VIEW ACCOUNT_UNLOCK_REASON;

CREATE MATERIALIZED VIEW ACCOUNT_UNLOCK_REASON
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT account_unlock_reason_id,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM account_unlock_reason@steps.world;

 ------------------AWARD_STATUS_MESSAGE----------------------------
DROP MATERIALIZED VIEW AWARD_STATUS_MESSAGE;

CREATE MATERIALIZED VIEW AWARD_STATUS_MESSAGE
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT award_status_message_id,
	   award_status,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM award_status_message@steps.world;

  ------------------STUDENT_MESSAGE_SUBJECT----------------------------
DROP MATERIALIZED VIEW STUDENT_MESSAGE_SUBJECT;

CREATE MATERIALIZED VIEW STUDENT_MESSAGE_SUBJECT
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT student_message_subject_id,
	   display_order,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM student_message_subject@steps.world;
 
 ------------------APPLICATION_STATUS_MESSAGE----------------------------
DROP MATERIALIZED VIEW APPLICATION_STATUS_MESSAGE;
CREATE MATERIALIZED VIEW APPLICATION_STATUS_MESSAGE
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH PRIMARY KEY
 
AS 

SELECT application_status_code,
	   application_status,
       description,
	   last_updated_by,
	   last_updated_on,
       is_active
  FROM application_status_message@steps.world;


------------------------------------------------------------------ STEPS REFERENCE DATA REFRESH GROUP ---------------------------------
 BEGIN
  DBMS_REFRESH.DESTROY(name => 'STEPS_REFERENCE_GROUP');
Commit;
END;
/ 
DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'TITLE';
  SnapArray(2) := 'ACCOUNT_LOCK_REASON';
  SnapArray(3) := 'ACCOUNT_UNLOCK_REASON';
  SnapArray(4) := 'APPLICATION_STATUS_MESSAGE';
  SnapArray(5) := 'AWARD_STATUS_MESSAGE';
  SnapArray(6) := 'BENEFACTOR_RELATION';
  SnapArray(7) := 'CONTACT_RELATIONSHIP';
  SnapArray(8) := 'COUNTRY';
  SnapArray(9) := 'ENQUIRY_OPTION';
  SnapArray(10) := 'EU_PORTABILITY';
  SnapArray(11) := 'MARITAL_STATUS';
  SnapArray(12) := 'NATIONALITY';
  SnapArray(13) := 'REASON_FOR_ONE_BEN';
  SnapArray(14) := 'REASON_NO_BEN_INCOME';
  SnapArray(15) := 'STUDENT_FAMILY_RELATIONSHIP';
  SnapArray(16) := 'STUD_INCOME_TYPE';
  SnapArray(17) := 'SUPP_GRANT_RELATION';
  SnapArray(18) := 'WHAT_DOING';
  SnapArray(19) := 'CONFIG_DATA';
  SnapArray(20) := 'STUDENT_MESSAGE_SUBJECT';
  SnapArray(21) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'STEPS_REFERENCE_GROUP'
    ,tab  => SnapArray
	,next_date => to_date('10/31/2015 06:00:00','mm/dd/yyyy hh24:mi:ss')
    ,interval  => 'TRUNC(SYSDATE+1)+6/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,push_deferred_rpc => TRUE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => NULL
    ,heap_size => NULL
  );
Commit;
END;
/

------------------------------------------------------------------ GRASS REFERENCE DATA TABLES ---------------------------------------------
-----------DROP UNUSED GRASS MV'S-------------------
DROP MATERIALIZED VIEW CATEGORY;
DROP MATERIALIZED VIEW CRSE_TERM;
DROP MATERIALIZED VIEW VALIDATION;
DROP MATERIALIZED VIEW UCAS;


------------------------- CRSE_MV ----------------------------------
DROP MATERIALIZED VIEW CRSE;

CREATE MATERIALIZED VIEW CRSE
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH ROWID
 
AS 
SELECT crse_id,
       inst_code,
       crse_code,
       crse_name,
       scheme_type,
       qual_type,
	   pams_course
  FROM crse@grass.world
 WHERE crse_code != 'PART' AND crse_name NOT LIKE 'Z%';
 


------------------------- CRSE_SESSION_MV ----------------------------------
DROP MATERIALIZED VIEW CRSE_SESSION ;

CREATE MATERIALIZED VIEW CRSE_SESSION
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH ROWID
 
AS 
SELECT crse_session_id,
       crse_id,
       session_code,
       max_duration,
       psas_loan,
       psas_cat
  FROM crse_session@grass.world;
  
--------------------------CRSE_YEAR_MV ---------------------------------------------
DROP MATERIALIZED VIEW CRSE_YEAR ;

CREATE MATERIALIZED VIEW CRSE_YEAR
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH ROWID
 
AS 
SELECT crse_year_id,
       crse_id

  FROM crse_year@grass.world;



--------------------------INST_MV --------------------------------------------------------
DROP MATERIALIZED VIEW INST;

CREATE MATERIALIZED VIEW INST
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH ROWID
 
AS 
SELECT inst_code,
       inst_type_id,
       inst_name,
       college_type,
       location_ind,
       non_public_fund
  FROM inst@grass.world
 WHERE     inst_name NOT LIKE '%Z%REFUS%'
       AND inst_name NOT LIKE '1998/99 ENGLAND % WALES'
       AND inst_name NOT LIKE '%OPEN UNIVERSITY%';


------------------------------INST_TERM_MV--------------------------------
DROP MATERIALIZED VIEW INST_TERM;

CREATE MATERIALIZED VIEW INST_TERM
STORAGE    (
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FAST

WITH ROWID
AS 
SELECT inst_code,
       session_code,
       term_no,
       start_date,
       end_date,
       days
  FROM inst_term@grass.world;
 

 ----------------------------------------------------------------- GRASS REF GROUP REFRESH GROUP ----------------------------------------
/* DROP MATERIALIZED VIEW COUNTRY;
 */

BEGIN
  DBMS_REFRESH.DESTROY(name => 'GRASS_REFERENCE_GROUP');
Commit;
END;
/  

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'CRSE';
  SnapArray(2) := 'CRSE_SESSION';
  SnapArray(3) := 'CRSE_YEAR';
  SnapArray(4) := 'INST';
  SnapArray(5) := 'INST_TERM';
  SnapArray(6) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'GRASS_REFERENCE_GROUP'
   ,tab  => SnapArray
   ,next_date => to_date('10/31/2015 06:00:00','mm/dd/yyyy hh24:mi:ss')
   ,interval  => 'TRUNC(SYSDATE+1)+6/24'
   ,implicit_destroy => FALSE
   ,lax => TRUE
   ,job => 0
   ,push_deferred_rpc => TRUE
   ,refresh_after_errors => FALSE
   ,purge_option => 1
   ,parallelism => NULL
   ,heap_size => NULL
  );
Commit;
END;
/

