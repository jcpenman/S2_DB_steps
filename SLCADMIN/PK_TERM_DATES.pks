CREATE OR REPLACE PACKAGE SLCADMIN.PK_TERM_DATES AS
/***************************************************************************************************
   NAME:       PK_TERM_DATES
   PURPOSE:    Package for functions and procedures related to maintenance of the Institution, 
              course and term dates data.  

   Version    Date         Author           Description
   -------    ----------   ------------     --------------------
   1.0        14/09/2018  James Baird      Created this package
   
***************************************************************************************************/

    
    PROCEDURE PROCESS_TERM_DATES(error_boolean   OUT VARCHAR2,
                                 ERROR_TEXT      OUT VARCHAR2);

       PROCEDURE REJECT_UNUSED_CHANGES;
         
       PROCEDURE AUTOMATE_SAFE_CHANGES;
       
       PROCEDURE COPY_LATEST_TO_CURRENT;
       
END PK_TERM_DATES;
/