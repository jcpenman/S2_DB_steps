-- Reference data
-- Table: ILA500_RULE 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      04.06.08    A.Bowman (SAAS)         Initial Version.
-- 1.1      23.06.08    A.Bowman (SAAS)         Amended data to UPPER case for consistency.
-- 1.2      03.06.09    A.Bowman (SAAS)         Amended rule 3 - Income changed to 22,000
--
-- Configuration Management:
-- $HeadURL: 
-- $Author: 
-- $Date: 
-- $Revision: 

INSERT INTO ILA500_RULE (RULE_ID,RULE_TYPE,RULE_VALUE,RULE_STATUS) 
VALUES 
(1,'AGE','THE LEARNER MUST BE OVER 16 YEARS OLD ON THE FIRST DAY OF THEIR COURSE','ACTIVE');

INSERT INTO ILA500_RULE (RULE_ID,RULE_TYPE,RULE_VALUE,RULE_STATUS) 
VALUES 
(2,'RESIDENCY','THE LEARNER MUST BE RESIDENT IN SCOTLAND','ACTIVE');

INSERT INTO ILA500_RULE (RULE_ID,RULE_TYPE,RULE_VALUE,RULE_STATUS) 
VALUES 
(3,'INCOME','THE LEARNERS INCOME MUST BE 22,000 OR LESS PER ANNUM','ACTIVE');

COMMIT;

 
