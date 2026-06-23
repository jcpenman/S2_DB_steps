UPDATE SGAS.APPLICATION_STATUS_MESSAGE SET DESCRIPTION = 'We have assessed your application and you are not entitled to an award. We will contact you with the reasons for this decision.',
                                           LAST_UPDATED_ON = SYSDATE
										   WHERE APPLICATION_STATUS_CODE='R'; 

commit;