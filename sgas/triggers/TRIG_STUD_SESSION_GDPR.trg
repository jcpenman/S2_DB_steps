CREATE OR REPLACE TRIGGER SGAS.STS_GDPR
AFTER DELETE OR INSERT OR UPDATE
OF BEN1_ID
  ,BEN2_ID
ON SGAS.STUD_SESSION
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
         
           IF NVL(:new.ben1_id,-1) != NVL(:old.ben1_id,-1) --has been updated
           THEN
            IF NVL(:new.ben1_id,-1) = -1 --has been deleted
            THEN
                --Delete the record if a GDPR notification has NOT been sent
                DELETE FROM SGAS.BEN_GDPR WHERE BEN_ID = :old.ben1_id AND STUD_SESSION_ID = :old.stud_session_id AND GDPR_SENT = 'N'; --could be multiple lines with same ben_id and srn -- need stud_session_id
            ELSE
                --If complete record is new SRN and STUD_SESSION cannot be :old.
                INSERT INTO SGAS.BEN_GDPR (BEN_ID, STUD_SESSION_ID, STUD_REF_NO, GDPR_SENT, FLAGGED_FOR_LETTER, LETTER_SESSION) 
                VALUES (:new.ben1_id, NVL(:old.stud_session_id,:new.stud_session_id), NVL(:old.stud_ref_no,:new.stud_ref_no), 'N', SYSDATE, NVL(:new.SESSION_CODE,:old.SESSION_CODE));
            END IF;
           END IF;
           
           
           IF NVL(:new.ben2_id,-1) != NVL(:old.ben2_id,-1)
           THEN
            IF NVL(:new.ben2_id,-1) = -1
            THEN
                DELETE FROM SGAS.BEN_GDPR WHERE BEN_ID = :old.ben2_id AND STUD_SESSION_ID = :old.stud_session_id AND GDPR_SENT = 'N';
            ELSE
                INSERT INTO SGAS.BEN_GDPR (BEN_ID, STUD_SESSION_ID, STUD_REF_NO, GDPR_SENT, FLAGGED_FOR_LETTER, LETTER_SESSION) 
                VALUES (:new.ben2_id, NVL(:old.stud_session_id,:new.stud_session_id), NVL(:old.stud_ref_no,:new.stud_ref_no), 'N', SYSDATE, NVL(:new.SESSION_CODE,:old.SESSION_CODE));
            END IF;
           END IF;
END;
/