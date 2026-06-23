/******************************************************************************
NAME:       
PURPOSE:

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0                                     Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/packages/PK_AWARDS_RECALC.pkb $ 
$Author: $ 
$Date: 2008-10-01 14:22:41 +0100 (Wed, 01 Oct 2008) $ 
$Revision: 1230 $ 
 
*******************************************************************************/
CREATE OR REPLACE PACKAGE BODY sgas.pk_awards_recalc
AS
   PROCEDURE awards_recalc (io_cursor IN OUT awards_recalc_cur)
   IS
      awards_recalc_cursor   awards_recalc_cur;
   BEGIN
      OPEN awards_recalc_cursor FOR
         SELECT a.awards_recalc_id, a.stud_ref_no, a.session_code,
                a.processed_flag, a.created_date, a.user_id
           FROM sgas.awards_recalc a
          WHERE a.processed_flag = 'N' AND ROWNUM < c_max_number + 1;

      io_cursor := awards_recalc_cursor;
   END awards_recalc;
END pk_awards_recalc;
/