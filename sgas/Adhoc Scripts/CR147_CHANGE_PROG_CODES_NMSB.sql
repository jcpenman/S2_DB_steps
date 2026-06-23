/*
CR147 Change Programme Code for NMSB award types
This should update 9 rows in the STUD_AWARD_TYPE table
Clark Bolan: 22/11/2016
*/

UPDATE stud_award_type
set programme = 'HAC', last_updated_by = 'SGAS', last_updated_on = sysdate
where account_name in(60201355, 60201360, 60217240);

COMMIT;