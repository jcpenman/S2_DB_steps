CREATE OR REPLACE TRIGGER CRSE_BEFORE_U
   BEFORE UPDATE 
   ON CRSE    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;

                           
END crse_before_u;

CREATE OR REPLACE TRIGGER CRSE_SESSION_BEFORE_U
   BEFORE UPDATE 
   ON CRSE_SESSION    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;
                                                      
END crse_session_before_u;

CREATE OR REPLACE TRIGGER CRSE_YEAR_BEFORE_U
   BEFORE UPDATE 
   ON CRSE_YEAR    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;
                                                      
END crse_year_before_u;

CREATE OR REPLACE TRIGGER CRSE_TERM_BEFORE_U
   BEFORE UPDATE 
   ON CRSE_TERM    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;
                                                      
END crse_term_before_u;

CREATE OR REPLACE TRIGGER INST_TERM_BEFORE_U
   BEFORE UPDATE 
   ON INST_TERM    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;
                                
END inst_term_before_u;

CREATE OR REPLACE TRIGGER INST_BEFORE_U
   BEFORE UPDATE 
   ON INST    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;                                   
                                                      
END inst_before_u;

CREATE OR REPLACE TRIGGER CAMPUS_BEFORE_U
   BEFORE UPDATE 
   ON CAMPUS    FOR EACH ROW
DECLARE
 
BEGIN
   :NEW.last_updated_on := sysdate;
                                
END campus_before_u;
