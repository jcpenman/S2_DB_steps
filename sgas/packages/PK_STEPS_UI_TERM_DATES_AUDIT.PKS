CREATE OR REPLACE PACKAGE SGAS.PK_STEPS_UI_TERM_DATES_AUDIT
AS
   /******************************************************************************
      NAME      PK_STEPS_UI_TERM_DATES_AUDIT
      PURPOSE:  USED BY THE TERM DATES AUDIT UI SCREEN

      REVISIONS:

      Ver        Date        Author            Description
      --------- ----------  --------------- ------------------------------------
      0.1       12/07/2019  Ranj            Created this package
   ******************************************************************************/
   TYPE TERM_DATES_AUD_CURSOR IS REF CURSOR;

   FUNCTION getDefaultDateFrom
      RETURN VARCHAR2;


   FUNCTION getDefaultDateTo
      RETURN VARCHAR2;


   PROCEDURE getInstAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getInstTermAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCampusAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getFinanceAudDetails (
      instCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCrseAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCrseSessionAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCrseYearAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE getCrseTermAudDetails (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
      username_in     IN            VARCHAR2,
	  action_in		  IN			VARCHAR2,	  
      dateFrom_in     IN            VARCHAR2,
      dateTo_in       IN            VARCHAR2,
      io_cursor       IN OUT        TERM_DATES_AUD_CURSOR,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);
	  
	  
   PROCEDURE validateInstCode (
      instCode_in     IN            VARCHAR2,
	  instName_out     	 OUT        VARCHAR2,
      matchFound_out	 OUT        VARCHAR2,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE validateCrseCode (
      instCode_in     IN            VARCHAR2,
      crseCode_in     IN            VARCHAR2,
	  crseName_out     	 OUT        VARCHAR2,	  
      matchFound_out   	 OUT        VARCHAR2,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);


   PROCEDURE validateUsername (
	  username_in     IN            VARCHAR2,
	  employeeName_out   OUT        VARCHAR2,
      matchFound_out   	 OUT        VARCHAR2,
      error_boolean      OUT NOCOPY VARCHAR2,
      ERROR_TEXT         OUT NOCOPY VARCHAR2);
	  
END PK_STEPS_UI_TERM_DATES_AUDIT;
/