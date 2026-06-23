UPDATE award
   SET award_type_descript =
          REPLACE (REPLACE (award_type_descript, nchr (8217), ''),
                   nchr (39),
                   ''
                  )
 WHERE award_type_descript LIKE '%' || nchr (8217) || '%'
    OR award_type_descript LIKE '%' || nchr (39) || '%'
/

/*SELECT *
  FROM award
 WHERE award_type_descript LIKE '%' || nchr (8217) || '%'
    OR award_type_descript LIKE '%' || nchr (39) || '%'*/

