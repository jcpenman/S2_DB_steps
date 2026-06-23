UPDATE country c
   SET C.IS_ACTIVE = 'Y'
 WHERE C.LONG_NAME = 'BURMA';


INSERT INTO SGAS.NATIONALITY (COUNTRY_CODE,
                              NATIONALITY_NAME,
                              NATIONALITY_REGION,
                              IS_ACTIVE)
     VALUES (622,
             'BURMESE',
             'ROW',
             'Y');

COMMIT;