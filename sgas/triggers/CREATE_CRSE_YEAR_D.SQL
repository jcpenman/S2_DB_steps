CREATE OR REPLACE TRIGGER CRSE_YEAR_D
   BEFORE DELETE
   ON CRSE_YEAR
   FOR EACH ROW
DECLARE
   CURSOR C_STUD
   IS
      SELECT COUNT (0)
        FROM STUD_CRSE_YEAR SCY
       WHERE SCY.CRSE_YEAR_ID = :OLD.CRSE_YEAR_ID;

   V_COUNT   NUMBER;
BEGIN
   OPEN C_STUD;

   FETCH C_STUD INTO V_COUNT;

   CLOSE C_STUD;

   IF V_COUNT > 0
   THEN
      raise_application_error (
         -20001,
            'Course year '
         || :OLD.crse_year_no
         || ' cannot be deleted while it has students on it');
   END IF;
END;
/