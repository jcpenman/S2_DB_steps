
UPDATE STUD_CRSE_YEAR scy
   SET scy.inst_name = 'OPEN UNIVERSITY'
 WHERE scy.inst_name = 'OPEN UNI';

COMMIT;