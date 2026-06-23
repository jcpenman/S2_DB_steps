-- add new records for new adhoc types in ADHOC_TYPE table

ALTER TABLE ADHOC_TYPE
ADD IS_ACTIVE VARCHAR(1) DEFAULT 'N';


--  Initial expenses - NMSB ==> 

insert into ADHOC_TYPE
( LEGACY_CODE, DESCRIPT, LAST_UPDATED_BY, LAST_UPDATED_ON, IS_ACTIVE )
VALUES ('I', 'Initial Expenses - NMSB', 'SGAS', SYSDATE, 'Y');


-- Other - UG ==> 

insert into ADHOC_TYPE
(LEGACY_CODE, DESCRIPT, LAST_UPDATED_BY, LAST_UPDATED_ON, IS_ACTIVE)
VALUES ('U', 'Other - UG', 'SGAS', SYSDATE, 'Y');

-- Other - NMSB ==> 

insert into ADHOC_TYPE
(LEGACY_CODE, DESCRIPT, LAST_UPDATED_BY, LAST_UPDATED_ON, IS_ACTIVE)
VALUES ('N', 'Other - NMSB', 'SGAS', SYSDATE, 'Y');

commit;

UPDATE ADHOC_TYPE
set IS_ACTIVE = 'Y'
WHERE DESCRIPT = 'AHP Placement Expenses';

UPDATE ADHOC_TYPE
set IS_ACTIVE = 'Y'
WHERE DESCRIPT = 'Travel Expenses Abroad';
