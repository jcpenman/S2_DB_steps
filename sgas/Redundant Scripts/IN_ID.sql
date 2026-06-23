/******************************************************************************
NAME: IN_ID       
PURPOSE: Trigger to update the INSTITUTION_CONTACT_DETAILS table on StEPS when
         a new INST is added in GRASS

MODIFICATION HISTORY:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        13.04.2010  A.Bowman         Initial Version

CONFIGURATION MANAGEMENT:
-------------------------
$HeadURL:  $ 
$Author:  $ 
$Date:  $ 
$Revision:  $ 
 
*******************************************************************************/

CREATE OR REPLACE TRIGGER sgas.in_id
   AFTER INSERT
   ON inst
   FOR EACH ROW
DECLARE
   p_inst_code   inst.inst_code%TYPE   := :NEW.inst_code;
   p_action      aud.action%TYPE       := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';

      IF p_action = 'I'
      THEN
         INSERT INTO institution_contact_details@stepdeve.world
                     (inst_code, inst_name
                     )
              VALUES (:NEW.inst_code, :NEW.inst_name
                     );
      END IF;
   END IF;
END in_id;
/