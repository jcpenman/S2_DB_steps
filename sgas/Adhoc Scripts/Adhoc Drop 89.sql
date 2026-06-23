update dsa_payment
set reminders_sent = 0;

commit;

ALTER TABLE dsa_payment
 MODIFY reminders_sent   number(1)     default 0;

