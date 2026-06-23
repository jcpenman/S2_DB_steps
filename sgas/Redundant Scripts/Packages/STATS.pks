CREATE OR REPLACE PACKAGE SGAS.STATS AS 

TYPE stats_cursor IS REF CURSOR;

/******************************************************************************
   NAME:       STATS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/08/2011  John Penman           1. Created this package.
******************************************************************************/

  
  PROCEDURE getDailyStats(p_enter_number_of_days_back IN NUMBER, p_enter_days_back_minus_one IN NUMBER, p_stats_curs OUT stats_cursor);
  PROCEDURE getTaskData(p_stats_curs OUT stats_cursor); -- 2nd block of SQL code
  PROCEDURE getTeamActivity(p_stats_curs OUT stats_cursor); -- 3rd block of SQL code
  PROCEDURE getUserData(p_enter_days_back IN NUMBER, p_stats_curs OUT stats_cursor); -- 4th block of SQL code

END STATS;
/
