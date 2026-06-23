CREATE OR REPLACE PACKAGE BODY SGAS.PK_STEPS_VALIDATE_STUD_APP AS

/******************************************************************************
   NAME:      PK_STEPS_VALIDATE_STUD_APP
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/02/2022      U446646       1. Created this package for COS2022.
******************************************************************************/

  PROCEDURE validatePlacementMsg (
      crse_code_in                IN   VARCHAR2,
      inst_code_in                IN   VARCHAR2,
      isPlacementMsgShown         OUT  VARCHAR2,
      error_boolean               OUT  VARCHAR2,
      ERROR_TEXT                  OUT  VARCHAR2)
    
   AS
   
      qual_type_var varchar2(10);
      crse_name_var varchar2(50);
      
   BEGIN
   
      isPlacementMsgShown := 'Y';
      error_boolean := 'false';
      ERROR_TEXT := '';

      SELECT qual_type, crse_name INTO qual_type_var, crse_name_var
      FROM crse
      WHERE crse_code = crse_code_in
      AND inst_code = inst_code_in;
      
      
      if ((qual_type_var IN ('HNC','HND','CERT','DIP_HE','HNC/HND','PGCE','MB_CLIN','MB_PRECLIN')) OR (crse_name_var like '%MBCHB%')) THEN
          isPlacementMsgShown := 'N';
      end if;
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT :=
               'ERROR : plsql procedure validatePlacementMsg : '
            || SYSDATE
            || ' : '
            || SQLCODE
            || ' : '
            || SQLERRM;
   END validatePlacementMsg;

END PK_STEPS_VALIDATE_STUD_APP;
/