--UPDATE IS_ACTIVE TO 'N' EXCEPT FOR 'Multiple disabilities', 'Visual impairment', 'Hearing impairment'

UPDATE DISABILITY_TYPE
SET IS_ACTIVE = 'N'
WHERE DESCRIPT NOT IN ('Multiple disabilities', 'Visual impairment', 'Hearing impairment');

COMMIT;