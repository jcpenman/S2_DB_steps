/* Formatted on 29/05/2015 16:18:28 (QP5 v5.215.12089.38647) */
DROP TRIGGER SGAS.SCY_UPDATE_LOAN_ZERO_BALANCE;

CREATE OR REPLACE TRIGGER SGAS.SCY_UPDATE_LOAN_ZERO_BALANCE
   BEFORE UPDATE OF APPLICATION_STATUS
   ON STUD_CRSE_YEAR
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
   WHEN (NEW.application_status = 'W')

DECLARE
   --collect data set
   CURSOR c_awards
   IS
      SELECT a.award_id
        FROM AWARD a, stud_award_type c
       WHERE     A.STUD_AWARD_TYPE = C.STUD_AWARD_TYPE
             AND C.TYPE = 'LOAN'
             AND a.stud_ref_no = :OLD.stud_ref_no
             AND a.session_code = :OLD.session_code;


   v_awards   c_awards%ROWTYPE;
BEGIN
   --loop over data

   OPEN c_awards;

   LOOP
      FETCH c_awards INTO v_awards;

      EXIT WHEN c_awards%NOTFOUND;

      IF c_awards%FOUND
      THEN
         --update data base
         :NEW.sal_sent := 'Y';
         :NEW.sal_dest := 1;

         UPDATE award
            SET amount = 0, net_amount = 0, unclaimed_loan = 0
          WHERE award_id = v_awards.award_id;
      END IF;
   END LOOP;

   CLOSE c_awards;
END SCY_UPDATE_LOAN_ZERO_BALANCE;

