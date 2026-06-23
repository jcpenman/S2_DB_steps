--Steps Defect 359-------------------------------
UPDATE config_data SET cval = '/projects/app/webmethods/share/AwardReports'
WHERE item_name = 'AWARD_REPORT_DESTINATION';

commit;