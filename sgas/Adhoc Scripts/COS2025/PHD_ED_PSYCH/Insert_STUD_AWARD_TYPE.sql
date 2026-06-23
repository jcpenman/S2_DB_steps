INSERT INTO SGAS.STUD_AWARD_TYPE (STUD_AWARD_TYPE,
                                  LOAN_NON_LOAN_FEE,
                                  SCHEME,
                                  AWARD_TYPE_DESCRIPT,
                                  SHOW_ON_AN_PAYMENTS,
                                  COST_CENTRE,
                                  PROGRAMME,
                                  ACCOUNT_NAME,
                                  ENTITY,
                                  SAAS_MAKE_PAYMENT,
                                  TYPE,
                                  LAST_UPDATED_BY,
                                  LAST_UPDATED_ON)
     VALUES ('PGEDFP',
             'fee',
             'PG',
             'PHD FEES GRANT',
             'Y',
             '173422',
             'EAB',
             '60100950',
             '600',
             'N',
             'PEPF',
             'SGAS',
             SYSDATE);




INSERT INTO SGAS.STUD_AWARD_TYPE (STUD_AWARD_TYPE,
                                  LOAN_NON_LOAN_FEE,
                                  SCHEME,
                                  AWARD_TYPE_DESCRIPT,
                                  SHOW_ON_AN_PAYMENTS,
                                  COST_CENTRE,
                                  PROGRAMME,
                                  ACCOUNT_NAME,
                                  ENTITY,
                                  SAAS_MAKE_PAYMENT,
                                  TYPE,
                                  LAST_UPDATED_BY,
                                  LAST_UPDATED_ON)
     VALUES ('PGEDGP',
             'non-Loan',
             'PG',
             'PHD EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT',
             'Y',
             '173422',
             'EAB',
             '60100950',
             '600',
             'N',
             'PEPG',
             'SGAS',
             SYSDATE);



COMMIT;