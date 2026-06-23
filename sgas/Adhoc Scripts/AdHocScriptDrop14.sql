CREATE OR REPLACE TRIGGER sgas.awi_dsa_pay
   AFTER UPDATE OF payment_status
   ON sgas.award_instalment
   FOR EACH ROW
DECLARE
   p_award_instalment_id   award_instalment.award_instalment_id%TYPE
                                                  := :OLD.award_instalment_id;
   p_payment_status        award_instalment.payment_status%TYPE
                                                       := :NEW.payment_status;
   p_batch_ref             award_instalment.batch_ref%TYPE  := :OLD.batch_ref;
   v_awi                   dsa_payment.award_instalment_id%TYPE;
BEGIN
   SELECT dsap.award_instalment_id
     INTO v_awi
     FROM dsa_payment dsap
    WHERE dsap.award_instalment_id = p_award_instalment_id;

   IF v_awi IS NOT NULL
   THEN
      IF p_payment_status = 'S'
      THEN
         UPDATE dsa_payment
            SET dsa_payment_status_id = 2,
                batch_ref = p_batch_ref
          WHERE award_instalment_id = p_award_instalment_id;
      ELSIF p_payment_status = 'R'
      THEN
         UPDATE dsa_payment
            SET dsa_payment_status_id = 3,
                batch_ref = p_batch_ref
          WHERE award_instalment_id = p_award_instalment_id;
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      v_awi := NULL;
END awi_dsa_pay;
show errors;