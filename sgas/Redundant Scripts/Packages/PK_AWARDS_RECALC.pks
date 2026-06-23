/******************************************************************************
NAME:       
PURPOSE:

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0                                     Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL: svn://192.168.186.3:3690/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/packages/PK_AWARDS_RECALC.pks $ 
$Author: $ 
$Date: 2008-10-01 14:22:41 +0100 (Wed, 01 Oct 2008) $ 
$Revision: 1230 $ 
 
*******************************************************************************/
CREATE OR REPLACE PACKAGE sgas.pk_awards_recalc
AS
   TYPE awards_recalc_cur IS REF CURSOR;

   c_max_number   CONSTANT NUMBER := 1000;

   PROCEDURE awards_recalc (io_cursor IN OUT awards_recalc_cur);
END pk_awards_recalc;
/