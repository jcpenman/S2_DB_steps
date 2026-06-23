-- Name:Adhoc 1
-- Description: This script has been created to update the course_id data type on the raw data
--              table. Since there is already data within this table the following steps were necessary
--              ALTER TABLE: add new column (temp) with desired datatype
--              UPDATE: (copy data to the new column 
--              ALTER TABLE: drop the original column 
--              ALTER TABLE: add new column with the name of the original and the desired datatype 
--              UPDATE: copy data to the new column from the temp column using piecemeal batch size 
--              ALTER TABLE: drop temp column   
--
-- MODIFICATION HISTORY:
-- Ref      Date          Author                  Desc.
-- 001      22.10.2008    A.Bowman (SAAS)         Initial Version.
--
-- Configuration Management:
-- $HeadURL: $ 
-- $Author: $
-- $Date: $
-- $Revision: $ 


alter table raw_data
add (temp number(10));

update raw_data
set temp = 8
where learner_id = 'lm1';

update raw_data
set temp = 7
where learner_id = '1610ROB07';

update raw_data
set temp = 1
where learner_id = '01KARA04';

update raw_data
set temp = 8
where learner_id = 'WOOWH00';

update raw_data
set temp = 3
where learner_id = 'AK010585D';

update raw_data
set temp = 3
where learner_id = 'LM2';

update raw_data
set temp = 3
where learner_id = 'DW010203AB';

update raw_data
set temp = 3
where learner_id = 'EDMEDMEDME';

update raw_data
set temp = 7
where learner_id = '1610ROB08';

update raw_data
set temp = 2
where learner_id = 'LM4';

update raw_data
set temp = 7
where learner_id = '1610ROB09';

update raw_data
set temp = 4
where learner_id = 'ILA500ILA5';

update raw_data
set temp = 3
where learner_id = 'PRINCECHAR';

update raw_data
set temp = 8
where learner_id = 'HD010407F';

update raw_data
set temp = 9
where learner_id = 'LM6';

update raw_data
set temp = 7
where learner_id = 'LORRAINE02';

update raw_data
set temp = 7
where learner_id = 'KARA06';

update raw_data
set temp = 7
where learner_id = 'KARA08';

update raw_data
set temp = 8
where learner_id = 'DELBOY12';

update raw_data
set temp = 7
where learner_id = '1610ROB10';

update raw_data
set temp = 1
where learner_id = 'GRASSLEARN';

update raw_data
set temp = 7
where learner_id = 'HAHA0102HA';

update raw_data
set temp = 1
where learner_id = 'STEPSLEARN';

update raw_data
set temp = 8
where learner_id = 'NW010203A';

update raw_data
set temp = 7
where learner_id = 'NW010203B';

update raw_data
set temp = 1
where learner_id = 'KARA10';

update raw_data
set temp = 7
where learner_id = 'KARA11';

update raw_data
set temp = 7
where learner_id = 'CC070707CC';

update raw_data
set temp = 3
where learner_id = 'KARA12';

alter table raw_data
drop column course_id;

alter table raw_data
add (course_id number(10));

update raw_data
set course_id = 8
where learner_id = 'lm1';

update raw_data
set course_id = 7
where learner_id = '1610ROB07';

update raw_data
set course_id = 1
where learner_id = '01KARA04';

update raw_data
set course_id = 8
where learner_id = 'WOOWH00';

update raw_data
set course_id = 3
where learner_id = 'AK010585D';

update raw_data
set course_id = 3
where learner_id = 'LM2';

update raw_data
set course_id = 3
where learner_id = 'DW010203AB';

update raw_data
set course_id = 3
where learner_id = 'EDMEDMEDME';

update raw_data
set course_id = 7
where learner_id = '1610ROB08';

update raw_data
set course_id = 2
where learner_id = 'LM4';

update raw_data
set course_id = 7
where learner_id = '1610ROB09';

update raw_data
set course_id = 4
where learner_id = 'ILA500ILA5';

update raw_data
set course_id = 3
where learner_id = 'PRINCECHAR';

update raw_data
set course_id = 8
where learner_id = 'HD010407F';

update raw_data
set course_id = 9
where learner_id = 'LM6';

update raw_data
set course_id = 7
where learner_id = 'LORRAINE02';

update raw_data
set course_id = 7
where learner_id = 'KARA06';

update raw_data
set course_id = 7
where learner_id = 'KARA08';

update raw_data
set course_id = 8
where learner_id = 'DELBOY12';

update raw_data
set course_id = 7
where learner_id = '1610ROB10';

update raw_data
set course_id = 1
where learner_id = 'GRASSLEARN';

update raw_data
set course_id = 7
where learner_id = 'HAHA0102HA';

update raw_data
set course_id = 1
where learner_id = 'STEPSLEARN';

update raw_data
set course_id = 8
where learner_id = 'NW010203A';

update raw_data
set course_id = 7
where learner_id = 'NW010203B';

update raw_data
set course_id = 1
where learner_id = 'KARA10';

update raw_data
set course_id = 7
where learner_id = 'KARA11';

update raw_data
set course_id = 7
where learner_id = 'CC070707CC';

update raw_data
set course_id = 3
where learner_id = 'KARA12';

alter table raw_data
drop column temp;