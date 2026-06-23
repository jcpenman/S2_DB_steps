CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_TERM_DATES_UTIL
AS
   /******************************************************************************
      NAME:       PK_STEPS_UI_TERM_DATES_UTIL
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        07/02/2019  James / Ranj     Moved James' course code generation function 'next_course_code' into this package.
      1.1        07/02/2019  Ranj             Created a wrapper procedure generateCourseCode to return a generated course code.
      1.2        18/02/2019  Ranj             Added getMaxTermDatesSession      
   ******************************************************************************/
   
       FUNCTION next_course_code (inst_code_in IN VARCHAR2)
       RETURN VARCHAR2;
       
       PROCEDURE generateCourseCode (instCode_in     IN          VARCHAR2,
                                     crseCode_out    OUT         VARCHAR2,
                                     error_boolean   OUT NOCOPY  VARCHAR2,
                                     error_text      OUT NOCOPY  VARCHAR2);       

       PROCEDURE getMaxTermDatesSession (maxTermDatesSession_out    OUT         VARCHAR2,
                                         error_boolean              OUT NOCOPY  VARCHAR2,
                                         error_text                 OUT NOCOPY  VARCHAR2);       
                                     
END PK_STEPS_UI_TERM_DATES_UTIL;
/