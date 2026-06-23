/* Formatted on 2012/05/22 15:29 (Formatter Plus v4.8.8) */
PROMPT ** Find Invalid Study Abroad Dates **
SELECT   scy.stud_ref_no, scy.stud_crse_year_id, scy.start_date_abroad,
         scy.end_date_abroad
    FROM stud_crse_year scy
   WHERE scy.start_date_abroad IS NOT NULL
     AND scy.session_code = 2011
     AND (   MONTHS_BETWEEN (scy.end_date_abroad, scy.start_date_abroad) > 12
          OR scy.start_date_abroad < '01-JAN-2011'
          OR scy.start_date_abroad > '31-DEC-2012'
          OR scy.end_date_abroad < '01-JAN-2011'
          OR scy.end_date_abroad > '31-DEC-2012'
         )
ORDER BY scy.stud_ref_no;