CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_ADHOC_BURSARY AS
/******************************************************************************
   NAME:       PK_STEPS_ADHOC_BURSARY_2015_2016 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28/08/2015  Clark Bolan     Adhoc bursary 2015/2016
******************************************************************************/
 
 
 --  CURSOR DEFINITIONS
       TYPE ab_students_cursor  IS REF CURSOR;

 PROCEDURE get_adhoc_bursary_students(p_students OUT ab_students_cursor);


  
END PK_STEPS_ADHOC_BURSARY;
/