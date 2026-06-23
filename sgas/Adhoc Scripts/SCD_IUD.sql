CREATE OR REPLACE TRIGGER SCD_IUD
   AFTER INSERT OR DELETE OR UPDATE OF stud_ref_no,
                                       contact_ind,
                                       cont_name,
                                       cont_postcode,
                                       cont_addr1,
                                       cont_addr2,
                                       cont_addr3,
                                       cont_tel_no,
                                       cont_rel_code,
                                       last_updated_by
   ON SGAS.STUD_CONT_DETAILS    FOR EACH ROW
DECLARE
   p_aud_date       DATE                                  := SYSDATE;
   p_column_name    stud_cont_details_aud.column_name%TYPE    := NULL;
   p_table_pkey1    stud_cont_details_aud.table_pkey1%TYPE    := :OLD.stud_ref_no;
   p_table_pkey2    stud_cont_details_aud.table_pkey2%TYPE    := NULL;
   p_old            stud_cont_details_aud.OLD%TYPE            := NULL;
   p_new            stud_cont_details_aud.NEW%TYPE            := NULL;
   p_action         stud_cont_details_aud.action%TYPE         := NULL;
   p_username       stud_cont_details_aud.username%TYPE       := :NEW.last_updated_by;
   p_stud_ref_no    stud_cont_details_aud.stud_ref_no%TYPE    := :OLD.stud_ref_no;
   --p_table_name     VARCHAR2 (32)                         := 'STUD_CONT_DETEAILS';
   
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_ref_no;
      p_table_pkey2 := :NEW.contact_ind;
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF UPDATING
   THEN
      p_action := 'U';
      p_table_pkey1 := :NEW.stud_ref_no;
      p_table_pkey2 := :NEW.contact_ind;
      p_stud_ref_no := :NEW.stud_ref_no;
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.stud_ref_no;
      p_table_pkey2 := :OLD.contact_ind;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username    := :OLD.last_updated_by;
   END IF;


   p_column_name := 'CONTACT_IND';
   p_old := :OLD.contact_ind;
   p_new := :NEW.contact_ind;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );
   p_column_name := 'CONT_NAME';
   p_old := :OLD.cont_name;
   p_new := :NEW.cont_name;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );
   p_column_name := 'CONT_POSTCODE';
   p_old := :OLD.cont_postcode;
   p_new := :NEW.cont_postcode;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );
   p_column_name := 'CONT_ADDR1';
   p_old := :OLD.cont_addr1;
   p_new := :NEW.cont_addr1;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );                           
   p_column_name := 'CONT_ADDR2';
   p_old := :OLD.cont_addr2;
   p_new := :NEW.cont_addr2;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );
   p_column_name := 'CONT_ADDR3';
   p_old := :OLD.cont_addr3;
   p_new := :NEW.cont_addr3;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );   
   p_column_name := 'CONT_TEL_NO';
   p_old := :OLD.cont_tel_no;
   p_new := :NEW.cont_tel_no;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );                                                                              
   p_column_name := 'CONT_REL_CODE';
   p_old := :OLD.cont_rel_code;
   p_new := :NEW.cont_rel_code;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              ); 
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_stud_cont_details_aud (p_aud_date,
                               p_column_name,
                               p_table_pkey1,
                               p_table_pkey2,
                               p_old,
                               p_new,
                               p_action,
                               p_username,
                               p_stud_ref_no
                              );                                                     

                              
END SCD_IUD;