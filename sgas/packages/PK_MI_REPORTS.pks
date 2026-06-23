CREATE OR REPLACE PACKAGE SGAS.PK_MI_REPORTS AS 
/******************************************************************************
   NAME:       PK_PAYMENTS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0         16/03/2011   Paul Hughes     1. Created this package.
      1.1        16/04/2011 Paul Hughes    2. Amended due to requirements
******************************************************************************/

 --REPORT 1
 TYPE report1typeApplic_cursor              IS REF CURSOR;
 TYPE report1typeScheme_cursor              IS REF CURSOR;
 
 
  --RERORT 1
  FUNCTION getAppSchemePerMonth(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER;
  FUNCTION getTotalApplicationsPerMonth(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER;
  FUNCTION getAverageProcessingTime(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER;
  FUNCTION getApplicationStatusPerMonth(p_status IN VARCHAR, p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER;
 
 PROCEDURE report1data (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_report1Applic_type IN OUT report1typeApplic_cursor, 
                                                                               p_report1Scheme_type IN OUT report1typeScheme_cursor,
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2);
                                                                                
                                                                                                                                                      
   --REPORT 2                                                                            
  TYPE report2typeScheme_cursor        IS REF CURSOR;
 TYPE report2typeCorres_cursor        IS REF CURSOR;                                                                               
                                                                                
  --REPORT 2
  FUNCTION getTotalCorrespondencePerMonth(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_category IN VARCHAR) RETURN NUMBER;
  FUNCTION getaverageprocessingtimecorres(p_scheme_type   IN   VARCHAR, p_date1 IN VARCHAR, p_date2 IN   VARCHAR, p_category IN VARCHAR) RETURN NUMBER;
  PROCEDURE report2data (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_category IN VARCHAR, p_report2Corres_type IN OUT report2typeCorres_cursor, 
                                                                                p_report2Scheme_type IN OUT report2typeScheme_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2);
                                                                                
                                                                                
                                                                                
                                                                                
 --REPORT 2b
    TYPE report2btypeScheme_cursor        IS REF CURSOR;
    TYPE report2btypeCorres_cursor        IS REF CURSOR;
    
  FUNCTION getTotalCorresPerMonthRep2b(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER;
  FUNCTION getaverageproctimecorresRep2b(p_scheme_type   IN   VARCHAR, p_date1 IN VARCHAR, p_date2 IN   VARCHAR) RETURN NUMBER;
  PROCEDURE report2bdata (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  p_report2bCorres_type IN OUT report2btypeCorres_cursor, 
                                                                                p_report2bScheme_type IN OUT report2btypeScheme_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2);
                                                                                
                                                                                
                                                                                
                                                                                
 --REPORT 3a
    TYPE report3atypeScheme_cursor        IS REF CURSOR;
    TYPE report3atypeApplic_cursor        IS REF CURSOR;
    
 FUNCTION getReport3Processed(p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR, p_type IN VARCHAR) RETURN NUMBER;
 FUNCTION getReport3AvgTime(p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR, p_type IN VARCHAR) RETURN NUMBER;
  
  PROCEDURE report3adata (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  p_report3aApplic_type IN OUT report3atypeApplic_cursor, 
                                                                                p_report3aScheme_type IN OUT report3atypeScheme_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2);
                                                                                
                                                                                
                                                                                
  --REPORT 3b
  
    TYPE report3ctypeScheme_cursor        IS REF CURSOR;
    TYPE report3ctypeApplic_cursor        IS REF CURSOR;
    
  
  PROCEDURE report3cdata (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  p_report3cApplic_type IN OUT report3ctypeApplic_cursor, 
                                                                                p_report3cScheme_type IN OUT report3ctypeScheme_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2);

 
                                                                                
 --REPORT 5
    TYPE report5typeDaysTaken_cursor    IS REF CURSOR;
 
FUNCTION ProcessedReport5(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_teams IN VARCHAR, 
                    p_min_days IN VARCHAR, p_max_days IN VARCHAR, p_type IN VARCHAR, p_category IN VARCHAR) RETURN NUMBER;
 
FUNCTION getAverageTaskRep5(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_teams IN VARCHAR, p_type IN VARCHAR, p_category IN VARCHAR) RETURN NUMBER;
FUNCTION getPercentOfTotCompledRep5(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_teams IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR, 
                                        p_type IN VARCHAR, p_category IN VARCHAR) RETURN NUMBER;                                                                                                                                                    RETURN NUMBER;
       
    PROCEDURE report5data (p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_scheme_type IN VARCHAR, p_category IN VARCHAR, p_teams IN VARCHAR,
                                                                                p_report5DaysTaken_type IN OUT report5typeDaysTaken_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2);
 

END PK_MI_REPORTS;
/
