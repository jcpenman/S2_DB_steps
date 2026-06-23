CREATE OR REPLACE PACKAGE BODY SGAS.PK_AWARD_CALCULATION
AS
/******************************************************************************
   NAME:       RULES_PROC 
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description 
   ---------  ----------  ---------------  ------------------------------------
   1.0        16/08/2012   Paul Hughes     Created Package for 2013
   1.1        09/09/2013   Paul Hughes      Updated for 2014 Pay Loans Project
   1.2        12/12/2013  Clark Bolan       Remove Pay Loans Code
                                            - FUNCTION get_loan request REMOVED
                                            - CASE calc_loan REMOVED
                                            - PAY_LOAN_RELEASE_YEAR REMOVED
                                            - Call to FUNCTION get_loan_request REMOVED
                                            - max_loan_request REMOVED  
  1.3        08/07/2014  Clark Bolan        - PACKAGE getRuleDoc updated to include location to the AHPFlag
  1.4        16/09/2014  Clark Bolan         - Changed relative days function to handle leap years.  
  1.5       12/10/2016  Clark Bolan         - CR 129 Care Experience                                           
  1.6       13/12/2018  Ranj Benning        - SFD3 - PG Educational Psychology
  1.7        29/10/2019  James Baird     Removed the @GRASS for course and institution tables.
******************************************************************************/




FUNCTION award_status(p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_result        CHAR;
    
    BEGIN
        SELECT
        CASE 
            WHEN scy.award IN('D')
            THEN SCY.AWARD
            WHEN NVL(sgas.rules_proc_recalc.getPrevSessionProvisionalFlag(scy.stud_ref_no, scy.session_code),'N') = 'Y' 
            THEN 'C'
        ELSE
            CASE
            WHEN  SCY.PARENT_CONTRIB_EXEMPT = 'N' AND 
                SS.BEN1_ID IS NULL AND 
                SS.BEN2_ID IS NULL
            THEN 'A'
            WHEN (SS.BEN1_ID IS NOT NULL OR SS.BEN2_ID IS NOT NULL OR SCY.PARENT_CONTRIB_EXEMPT = 'Y') AND SGAS.PK_AWARD_CALCULATION.GETHOUSEHOLDINCOME(scy.stud_crse_year_id) >= 34000
                THEN 'B'
            WHEN (SS.BEN1_ID IS NOT NULL OR SS.BEN2_ID IS NOT NULL OR SCY.PARENT_CONTRIB_EXEMPT = 'Y') AND SGAS.PK_AWARD_CALCULATION.GETHOUSEHOLDINCOME(scy.stud_crse_year_id) < 34000
                THEN 'E'
            END 
        END award_given
        INTO l_result
        FROM stud_crse_year scy, stud_session ss
        WHERE scy.stud_session_id = SS.STUD_SESSION_ID
        AND scy.stud_crse_year_id = p_stud_crse_year_id;
    
        
    RETURN l_result;
    

        
    
    END award_status;


FUNCTION getDependantDays (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_days              NUMBER;
    l_scy_start_date    DATE;
    l_sd_start_date     DATE;
    l_rel_start_date    DATE;
    l_rel_end_date      DATE;
    l_scy_withdraw_date DATE;
    l_scy_crse_chg_date DATE;
    l_sd_end_date       DATE;
    l_min_date          DATE;
    l_max_date          DATE;

    
    
BEGIN

    SELECT NVL(START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(WITHDRAW_DATE,TO_DATE('01/01/9999','DD/MM/YYYY')), NVL(CRSE_CHG,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_scy_start_date, l_scy_withdraw_date, l_scy_crse_chg_date
    FROM STUD_CRSE_YEAR
    WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
    
    l_rel_start_date := sgas.pk_award_calculation.getRelevantStartDate (p_stud_crse_year_id);
    
    l_rel_end_date := sgas.pk_award_calculation.getRelevantEndDate (p_stud_crse_year_id);
    
    SELECT NVL(a.START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(a.END_DATE,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_sd_start_date, l_sd_end_date
    FROM STUD_DEPENDANT a, STUD_SESSION b, STUD_CRSE_YEAR d
    WHERE a.STUD_SESSION_ID(+) = b.STUD_SESSION_ID
    AND b.STUD_SESSION_ID = d.STUD_SESSION_ID
    AND d.stud_crse_year_id = p_stud_crse_year_id
    AND a.relation_id IN(34,35,36,37,38,39,40,41,42,43,48,49,508,509,650);
    
    CASE 
        WHEN l_scy_start_date >= l_sd_start_date AND l_scy_start_date >= l_rel_start_date
        THEN l_min_date := l_scy_start_date;
        WHEN l_sd_start_date >= l_scy_start_date AND l_sd_start_date >= l_rel_start_date
        THEN l_min_date := l_sd_start_date;
        ELSE l_min_date := l_rel_start_date;
    END CASE;
    

        CASE 
        WHEN l_scy_withdraw_date <= l_rel_end_date AND l_scy_withdraw_date <= l_scy_crse_chg_date AND l_scy_withdraw_date <= l_sd_end_date
        THEN l_max_date := l_scy_withdraw_date;
        WHEN l_scy_crse_chg_date <= l_rel_end_date AND l_scy_crse_chg_date <= l_scy_withdraw_date AND l_scy_crse_chg_date <= l_sd_end_date
        THEN l_max_date := l_scy_crse_chg_date;
        WHEN l_sd_end_date <= l_rel_end_date AND l_sd_end_date <= l_scy_withdraw_date AND l_sd_end_date <= l_scy_crse_chg_date
        THEN l_max_date := l_sd_end_date;
        ELSE l_max_date := l_rel_end_date;
    END CASE;
    
    l_days := l_max_date+1 - l_min_date;

    RETURN l_days;

END getDependantDays;

FUNCTION getDependantDays_2022(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_days              NUMBER;
    l_sd_start_date     DATE;
    l_rel_start_date    DATE;
    l_rel_end_date      DATE;
    l_sd_end_date       DATE;
    l_min_date          DATE;
    l_max_date          DATE;

    
    
BEGIN

   
    l_rel_start_date := sgas.pk_award_calculation.getRelevantStartDate (p_stud_crse_year_id);
    
    l_rel_end_date := sgas.pk_award_calculation.getRelevantEndDate (p_stud_crse_year_id);
    
    SELECT 
        NVL(a.START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), 
        NVL(a.END_DATE,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_sd_start_date, l_sd_end_date
    FROM STUD_DEPENDANT a, STUD_SESSION b, STUD_CRSE_YEAR d
    WHERE a.STUD_SESSION_ID(+) = b.STUD_SESSION_ID
    AND b.STUD_SESSION_ID = d.STUD_SESSION_ID
    AND d.stud_crse_year_id = p_stud_crse_year_id
    AND a.relation_id IN(34,35,36,37,38,39,40,41,42,43,48,49,508,509,650);
    
    CASE 

        WHEN l_sd_start_date >= l_rel_start_date
        THEN l_min_date := l_sd_start_date;
        ELSE l_min_date := l_rel_start_date;
    END CASE;
    

    
    CASE 
        WHEN l_sd_end_date >= l_rel_end_date
        THEN l_max_date := l_rel_end_date;
        ELSE l_max_date := l_sd_end_date;
    END CASE;
    
    l_days := l_max_date+1 - l_min_date;

    RETURN l_days;

END getDependantDays_2022;


FUNCTION getDependantMaxDates (p_stud_crse_year_id IN NUMBER) RETURN DATE  ----NEW NEW NEW NEW NEW NEW
IS

    l_scy_start_date    DATE;
    l_sd_start_date     DATE;
    l_rel_start_date    DATE;
    l_rel_end_date      DATE;
    l_scy_withdraw_date DATE;
    l_scy_crse_chg_date DATE;
    l_sd_end_date       DATE;
    l_min_date          DATE;
    l_max_date          DATE;
    l_count_ed          NUMBER;

    
    
BEGIN

    SELECT NVL(START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(WITHDRAW_DATE,TO_DATE('01/01/9999','DD/MM/YYYY')), NVL(CRSE_CHG,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_scy_start_date, l_scy_withdraw_date, l_scy_crse_chg_date
    FROM STUD_CRSE_YEAR
    WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
    
    l_rel_start_date := sgas.pk_award_calculation.getRelevantStartDate (p_stud_crse_year_id);
    
    l_rel_end_date := sgas.pk_award_calculation.getRelevantEndDate (p_stud_crse_year_id);
    
    SELECT NVL(a.START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(a.END_DATE,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_sd_start_date, l_sd_end_date
    FROM STUD_DEPENDANT a, STUD_SESSION b, STUD_CRSE_YEAR d
    WHERE a.STUD_SESSION_ID(+) = b.STUD_SESSION_ID
    AND b.STUD_SESSION_ID = d.STUD_SESSION_ID
    AND d.stud_crse_year_id = p_stud_crse_year_id
    AND ROWNUM =1;
    --AND a.relation_id IN(34,35,36,37,38,39,40,41,42,43,48,49,508,509,650); --Defect 103
    
    SELECT COUNT (*)
    INTO l_count_ed
    FROM stud_dependant a, stud_session b, stud_crse_year d
    WHERE     a.stud_session_id = b.stud_session_id
       AND b.stud_session_id = d.stud_session_id
       AND d.stud_crse_year_id = p_stud_crse_year_id
       AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603, 705)
       AND a.end_date IS NULL;
    
    IF l_count_ed > 0
    THEN l_sd_end_date := TO_DATE('01/01/9999','DD/MM/YYYY');
    END IF;  
    
    CASE 
        WHEN l_scy_start_date >= l_sd_start_date AND l_scy_start_date >= l_rel_start_date
        THEN l_min_date := l_scy_start_date;
        WHEN l_sd_start_date >= l_scy_start_date AND l_sd_start_date >= l_rel_start_date
        THEN l_min_date := l_sd_start_date;
        ELSE l_min_date := l_rel_start_date;
    END CASE;
    

        CASE 
        WHEN l_scy_withdraw_date <= l_rel_end_date AND l_scy_withdraw_date <= l_scy_crse_chg_date AND l_scy_withdraw_date <= l_sd_end_date
        THEN l_max_date := l_scy_withdraw_date;
        WHEN l_scy_crse_chg_date <= l_rel_end_date AND l_scy_crse_chg_date <= l_scy_withdraw_date AND l_scy_crse_chg_date <= l_sd_end_date
        THEN l_max_date := l_scy_crse_chg_date;
        WHEN l_sd_end_date <= l_rel_end_date AND l_sd_end_date <= l_scy_withdraw_date AND l_sd_end_date <= l_scy_crse_chg_date
        THEN l_max_date := l_sd_end_date;
        ELSE l_max_date := l_rel_end_date;
    END CASE;
    
    l_max_date := l_max_date;

    RETURN l_max_date;

END getDependantMaxDates;


FUNCTION getDependantMinDates (p_stud_crse_year_id IN NUMBER) RETURN DATE  ----NEW NEW NEW NEW NEW NEW
IS

    l_scy_start_date    DATE;
    l_sd_start_date     DATE;
    l_rel_start_date    DATE;
    l_rel_end_date      DATE;
    l_scy_withdraw_date DATE;
    l_scy_crse_chg_date DATE;
    l_sd_end_date       DATE;
    l_min_date          DATE;
    l_max_date          DATE;
    l_count_sd          NUMBER;

    
    
BEGIN

    SELECT NVL(START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(WITHDRAW_DATE,TO_DATE('01/01/9999','DD/MM/YYYY')), NVL(CRSE_CHG,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_scy_start_date, l_scy_withdraw_date, l_scy_crse_chg_date
    FROM STUD_CRSE_YEAR
    WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
    
    l_rel_start_date := sgas.pk_award_calculation.getRelevantStartDate (p_stud_crse_year_id);
    
    l_rel_end_date := sgas.pk_award_calculation.getRelevantEndDate (p_stud_crse_year_id);
    
    SELECT NVL(a.START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(a.END_DATE,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_sd_start_date, l_sd_end_date
    FROM STUD_DEPENDANT a, STUD_SESSION b, STUD_CRSE_YEAR d
    WHERE a.STUD_SESSION_ID(+) = b.STUD_SESSION_ID
    AND b.STUD_SESSION_ID = d.STUD_SESSION_ID
    AND d.stud_crse_year_id = p_stud_crse_year_id
    AND ROWNUM =1;
    --AND a.relation_id IN(34,35,36,37,38,39,40,41,42,43,48,49,508,509,650); --Defect 103
    
    SELECT COUNT (*)
    INTO l_count_sd
    FROM stud_dependant a, stud_session b, stud_crse_year d
    WHERE     a.stud_session_id = b.stud_session_id
       AND b.stud_session_id = d.stud_session_id
       AND d.stud_crse_year_id = p_stud_crse_year_id
       AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603, 705)
       AND a.start_date IS NULL;
    
    IF l_count_sd > 0
    THEN l_sd_start_date := TO_DATE('01/01/1000','DD/MM/YYYY');
    END IF;
    
     CASE 
        WHEN l_scy_start_date >= l_sd_start_date AND l_scy_start_date >= l_rel_start_date
        THEN l_min_date := l_scy_start_date;
        WHEN l_sd_start_date >= l_scy_start_date AND l_sd_start_date >= l_rel_start_date
        THEN l_min_date := l_sd_start_date;
        ELSE l_min_date := l_rel_start_date;
    END CASE;
      
       
        
        CASE 
        WHEN l_scy_withdraw_date <= l_rel_end_date AND l_scy_withdraw_date <= l_scy_crse_chg_date AND l_scy_withdraw_date <= l_sd_end_date
        THEN l_max_date := l_scy_withdraw_date;
        WHEN l_scy_crse_chg_date <= l_rel_end_date AND l_scy_crse_chg_date <= l_scy_withdraw_date AND l_scy_crse_chg_date <= l_sd_end_date
        THEN l_max_date := l_scy_crse_chg_date;
        WHEN l_sd_end_date <= l_rel_end_date AND l_sd_end_date <= l_scy_withdraw_date AND l_sd_end_date <= l_scy_crse_chg_date
        THEN l_max_date := l_sd_end_date;
        ELSE l_max_date := l_rel_end_date;
    END CASE;
    

    RETURN l_min_date;

END getDependantMinDates;
FUNCTION getLPGDays (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_days              NUMBER;
    l_scy_start_date    DATE;
    l_sd_start_date     DATE;
    l_rel_start_date    DATE;
    l_rel_end_date      DATE;
    l_scy_withdraw_date DATE;
    l_scy_crse_chg_date DATE;
    l_sd_end_date       DATE;
    l_min_date          DATE;
    l_max_date          DATE;
    l_count_sd          NUMBER;
    l_count_ed          NUMBER;
    
BEGIN

    SELECT NVL(START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(WITHDRAW_DATE,TO_DATE('01/01/9999','DD/MM/YYYY')), NVL(CRSE_CHG,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_scy_start_date, l_scy_withdraw_date, l_scy_crse_chg_date
    FROM STUD_CRSE_YEAR
    WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
    
    l_rel_start_date := sgas.pk_award_calculation.getRelevantStartDate (p_stud_crse_year_id);
    
    l_rel_end_date := sgas.pk_award_calculation.getRelevantEndDate (p_stud_crse_year_id);
    
    SELECT NVL(MIN(a.START_DATE),TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(MAX(a.END_DATE),TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_sd_start_date, l_sd_end_date
    FROM STUD_DEPENDANT a, STUD_SESSION b, STUD_CRSE_YEAR d
    WHERE a.STUD_SESSION_ID(+) = b.STUD_SESSION_ID
    AND b.STUD_SESSION_ID = d.STUD_SESSION_ID
    AND d.stud_crse_year_id = p_stud_crse_year_id
    AND a.relation_id IN(46, 47, 510, 511, 600, 601, 602, 603, 705); 
    
    SELECT COUNT (*)
    INTO l_count_sd
    FROM stud_dependant a, stud_session b, stud_crse_year d
    WHERE     a.stud_session_id = b.stud_session_id
       AND b.stud_session_id = d.stud_session_id
       AND d.stud_crse_year_id = p_stud_crse_year_id
       AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603, 705)
       AND a.start_date IS NULL;
    
    IF l_count_sd > 0
    THEN l_sd_start_date := TO_DATE('01/01/1000','DD/MM/YYYY');
    END IF;
    
    SELECT COUNT (*)
    INTO l_count_ed
    FROM stud_dependant a, stud_session b, stud_crse_year d
    WHERE     a.stud_session_id = b.stud_session_id
       AND b.stud_session_id = d.stud_session_id
       AND d.stud_crse_year_id = p_stud_crse_year_id
       AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603, 705)
       AND a.end_date IS NULL;
    
    IF l_count_ed > 0
    THEN l_sd_end_date := TO_DATE('01/01/9999','DD/MM/YYYY');
    END IF;  
    
    
    CASE 
        WHEN l_scy_start_date >= l_sd_start_date AND l_scy_start_date >= l_rel_start_date
        THEN l_min_date := l_scy_start_date;
        WHEN l_sd_start_date >= l_scy_start_date AND l_sd_start_date >= l_rel_start_date
        THEN l_min_date := l_sd_start_date;
        ELSE l_min_date := l_rel_start_date;
    END CASE;
    

        CASE 
        WHEN l_scy_withdraw_date <= l_rel_end_date AND l_scy_withdraw_date <= l_scy_crse_chg_date AND l_scy_withdraw_date <= l_sd_end_date
        THEN l_max_date := l_scy_withdraw_date;
        WHEN l_scy_crse_chg_date <= l_rel_end_date AND l_scy_crse_chg_date <= l_scy_withdraw_date AND l_scy_crse_chg_date <= l_sd_end_date
        THEN l_max_date := l_scy_crse_chg_date;
        WHEN l_sd_end_date <= l_rel_end_date AND l_sd_end_date <= l_scy_withdraw_date AND l_sd_end_date <= l_scy_crse_chg_date
        THEN l_max_date := l_sd_end_date;
        ELSE l_max_date := l_rel_end_date;
    END CASE;
    

    
    l_days := l_max_date+1 - l_min_date;

    RETURN l_days;
  
END getLPGDays;


FUNCTION getLPGDays_2022 (p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    l_days              NUMBER;
    --l_scy_start_date    DATE;
    l_sd_start_date     DATE;
    l_rel_start_date    DATE;
    l_rel_end_date      DATE;
    --l_scy_withdraw_date DATE;
    --l_scy_crse_chg_date DATE;
    l_sd_end_date       DATE;
    l_min_date          DATE;
    l_max_date          DATE;
    l_count_sd          NUMBER;
    l_count_ed          NUMBER;
    
BEGIN

    /*
    SELECT NVL(START_DATE,TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(WITHDRAW_DATE,TO_DATE('01/01/9999','DD/MM/YYYY')), NVL(CRSE_CHG,TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_scy_start_date, l_scy_withdraw_date, l_scy_crse_chg_date
    FROM STUD_CRSE_YEAR
    WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
    */
    
    l_rel_start_date := sgas.pk_award_calculation.getRelevantStartDate (p_stud_crse_year_id);
    
    l_rel_end_date := sgas.pk_award_calculation.getRelevantEndDate (p_stud_crse_year_id);
    
    SELECT NVL(MIN(a.START_DATE),TO_DATE('01/01/1000','DD/MM/YYYY')), NVL(MAX(a.END_DATE),TO_DATE('01/01/9999','DD/MM/YYYY'))
    INTO l_sd_start_date, l_sd_end_date
    FROM STUD_DEPENDANT a, STUD_SESSION b, STUD_CRSE_YEAR d
    WHERE a.STUD_SESSION_ID(+) = b.STUD_SESSION_ID
    AND b.STUD_SESSION_ID = d.STUD_SESSION_ID
    AND d.stud_crse_year_id = p_stud_crse_year_id
    AND a.relation_id IN(46, 47, 510, 511, 600, 601, 602, 603, 705); 
    
    SELECT COUNT (*)
    INTO l_count_sd
    FROM stud_dependant a, stud_session b, stud_crse_year d
    WHERE     a.stud_session_id = b.stud_session_id
       AND b.stud_session_id = d.stud_session_id
       AND d.stud_crse_year_id = p_stud_crse_year_id
       AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603, 705)
       AND a.start_date IS NULL;
    
    IF l_count_sd > 0
    THEN l_sd_start_date := TO_DATE('01/01/1000','DD/MM/YYYY');
    END IF;
    
    SELECT COUNT (*)
    INTO l_count_ed
    FROM stud_dependant a, stud_session b, stud_crse_year d
    WHERE     a.stud_session_id = b.stud_session_id
       AND b.stud_session_id = d.stud_session_id
       AND d.stud_crse_year_id = p_stud_crse_year_id
       AND a.relation_id IN (46, 47, 510, 511, 600, 601, 602, 603, 705)
       AND a.end_date IS NULL;
    
    IF l_count_ed > 0
    THEN l_sd_end_date := TO_DATE('01/01/9999','DD/MM/YYYY');
    END IF;  
       
    
    CASE 
        WHEN l_sd_start_date >= l_rel_start_date
        THEN l_min_date := l_sd_start_date;
        ELSE l_min_date := l_rel_start_date;
    END CASE;
    

    
    CASE 
        WHEN l_sd_end_date >= l_rel_end_date
        THEN l_max_date := l_rel_end_date;
        ELSE l_max_date := l_sd_end_date;
    END CASE;

    
    l_days := l_max_date+1 - l_min_date;

    RETURN l_days;
  
END getLPGDays_2022;

        

FUNCTION getRelevantStartDate (p_stud_crse_year_id IN NUMBER) RETURN DATE
IS

    l_rel_start_date     DATE;
    l_crse_start_date    DATE;
    l_session            NUMBER;

    
BEGIN
    

     SELECT SESSION_CODE
     INTO l_session
     FROM STUD_CRSE_YEAR
     WHERE stud_crse_year_id = p_stud_crse_year_id;
     
                 l_crse_start_date  := sgas.rules_proc_recalc.getStartDateTerm( p_stud_crse_year_id, 1);
                    
                 CASE
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-08',l_session),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('31-12',l_session),'DD-MM-YYYY')
                        THEN l_rel_start_date := TO_DATE(CONCAT('01-08',l_session),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-01',l_session+1),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('31-03',l_session+1),'DD-MM-YYYY')
                        THEN l_rel_start_date := TO_DATE(CONCAT('01-01',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-04',l_session+1),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('30-06',l_session+1),'DD-MM-YYYY')
                        THEN l_rel_start_date := TO_DATE(CONCAT('01-04',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-07',l_session+1),'DD-MM-YYYY') AND l_crse_start_date <= TO_DATE(CONCAT('31-07',l_session+1),'DD-MM-YYYY')
                        THEN l_rel_start_date := TO_DATE(CONCAT('01-07',l_session+1),'DD-MM-YYYY');
                   ELSE NULL;
                 END CASE;

     RETURN l_rel_start_date;
     
END getRelevantStartDate;

FUNCTION getRelevantEndDate (p_stud_crse_year_id IN NUMBER) RETURN DATE
IS

    l_rel_end_date          DATE;
    l_crse_start_date       DATE;
    l_session               NUMBER;

    
BEGIN
    

     SELECT SESSION_CODE
     INTO l_session
     FROM STUD_CRSE_YEAR
     WHERE stud_crse_year_id = p_stud_crse_year_id;
     
                 l_crse_start_date  := sgas.rules_proc_recalc.getStartDateTerm( p_stud_crse_year_id, 1);
                    
                 CASE
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-08',l_session),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('31-12',l_session),'DD-MM-YYYY')
                        THEN l_rel_end_date := TO_DATE(CONCAT('31-07',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-01',l_session+1),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('31-03',l_session+1),'DD-MM-YYYY')
                        THEN l_rel_end_date := TO_DATE(CONCAT('31-12',l_session+1),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-04',l_session+1),'DD-MM-YYYY') AND l_crse_start_date < TO_DATE(CONCAT('30-06',l_session+1),'DD-MM-YYYY')
                        THEN l_rel_end_date := TO_DATE(CONCAT('31-03',l_session+2),'DD-MM-YYYY');
                    WHEN l_crse_start_date >= TO_DATE(CONCAT('01-07',l_session+1),'DD-MM-YYYY') AND l_crse_start_date <= TO_DATE(CONCAT('31-07',l_session+1),'DD-MM-YYYY')
                        THEN l_rel_end_date := TO_DATE(CONCAT('30-06',l_session+2),'DD-MM-YYYY');
                   ELSE NULL;
                 END CASE;

     RETURN l_rel_end_date;
     
END getRelevantEndDate;


FUNCTION getHouseHoldIncome(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

        l_household NUMBER;
        l_income    NUMBER;
        l_total     NUMBER;
        
BEGIN

        SELECT sgas.rules_proc_recalc.get_ben_income(p_stud_crse_year_id)
        INTO l_household
        FROM DUAL;
        
        SELECT NVL(SUM(a.AMOUNT),0)
        INTO l_income
        FROM STUD_INCOME a, STUD_SESSION b, STUD_CRSE_YEAR c
        WHERE a.STUD_SESSION_ID = b.STUD_SESSION_ID
        AND c.STUD_SESSION_ID = b.STUD_SESSION_ID
        AND c.STUD_CRSE_YEAR_ID = p_stud_crse_year_id;
        
       l_total := l_household + l_income;
       
       RETURN l_total;

END getHouseHoldIncome;



/* Formatted on 16/09/2014 08:26:25 (QP5 v5.215.12089.38647) */
FUNCTION RelativeDays (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   l_crse_start_date   DATE;
   l_days              NUMBER;
   l_session           NUMBER;
BEGIN
   SELECT session_code
     INTO l_session
     FROM STUD_CRSE_YEAR
    WHERE STUD_CRSE_YEAR_ID = p_stud_crse_year_id;


   l_crse_start_date :=
      sgas.rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 1);

   CASE
      WHEN     l_crse_start_date >=
                  TO_DATE (CONCAT ('01-07', l_session + 1), 'DD-MM-YYYY')
           AND l_crse_start_date <=
                  TO_DATE (CONCAT ('30-06', l_session + 2), 'DD-MM-YYYY')
      THEN
         l_days :=
              TO_DATE (CONCAT ('30-06', l_session + 2), 'DD-MM-YYYY')
            + 1
            - TO_DATE (CONCAT ('01-07', l_session + 1), 'DD-MM-YYYY');     --4
      WHEN     l_crse_start_date >=
                  TO_DATE (CONCAT ('01-04', l_session + 1), 'DD-MM-YYYY')
           AND l_crse_start_date <=
                  TO_DATE (CONCAT ('31-03', l_session + 2), 'DD-MM-YYYY')
      THEN
         l_days :=
              TO_DATE (CONCAT ('31-03', l_session + 2), 'DD-MM-YYYY')
            + 1
            - TO_DATE (CONCAT ('01-04', l_session + 1), 'DD-MM-YYYY');     --3
      WHEN     l_crse_start_date >=
                  TO_DATE (CONCAT ('01-01', l_session + 1), 'DD-MM-YYYY')
           AND l_crse_start_date <=
                  TO_DATE (CONCAT ('31-12', l_session + 1), 'DD-MM-YYYY')
      THEN
         l_days :=
              TO_DATE (CONCAT ('31-12', l_session + 1), 'DD-MM-YYYY')
            + 1
            - TO_DATE (CONCAT ('01-01', l_session + 1), 'DD-MM-YYYY');     --2
      WHEN     l_crse_start_date >=
                  TO_DATE (CONCAT ('01-08', l_session), 'DD-MM-YYYY')
           AND l_crse_start_date <=
                  TO_DATE (CONCAT ('31-07', l_session + 1), 'DD-MM-YYYY')
      THEN
         l_days :=
              TO_DATE (CONCAT ('31-07', l_session + 1), 'DD-MM-YYYY')
            + 1
            - TO_DATE (CONCAT ('01-08', l_session), 'DD-MM-YYYY');         --1
      ELSE
         NULL;
   END CASE;

   RETURN l_days;
END RelativeDays;

/* Formatted on 31/03/2014 09:36:58 (QP5 v5.215.12089.38647) */
FUNCTION IS_LEAP_YEAR (nYr IN NUMBER)
   RETURN CHAR
IS
   v_day      VARCHAR2 (2);
   v_result   VARCHAR (2);
BEGIN
   SELECT TO_CHAR (
             LAST_DAY (TO_DATE ('01-FEB-' || TO_CHAR (nYr), 'DD-MON-YYYY')),
             'DD')
     INTO v_day
     FROM DUAL;

   IF v_day = '29'
   THEN
      v_result := 'Y';
   ELSE
      v_result := 'N';
   END IF;

   RETURN v_result;
END IS_LEAP_YEAR;


FUNCTION getPartYearAbroad (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    v_result CHAR;
    v_number NUMBER;
    
BEGIN

        SELECT NVL(sgas.rules_proc_recalc.get_courselength(p_stud_crse_year_id),0) - NVL(SGAS.RULES_PROC_RECALC.GET_ABROAD_DAYS_IN_TERM(p_stud_crse_year_id),0)
        INTO v_number
        FROM DUAL;
       
        IF
            v_number < 70
        THEN v_result := 'Y';
        ELSE v_result := 'N';
        END IF;

      
   RETURN v_result;
   
   END getPartYearAbroad;

FUNCTION get_fee_factor (p_stud_crse_year_id IN NUMBER)
    RETURN CHAR
IS
    
    abroad                  CHAR;
    non_erasmus_exchange    CHAR;
    erasmus                 CHAR;
    location_ind            CHAR;
    part_year_abroad        CHAR;
    paid_sandwich           CHAR;
    unpaid_sandwich         CHAR;
    fee_factor              CHAR;

    BEGIN
    
    part_year_abroad := SGAS.PK_AWARD_CALCULATION.getPartYearAbroad(p_stud_crse_year_id);
   
    
    SELECT SCY.STUDY_ABROAD, SCY.NON_ERASMUS_EXCHANGE, SCY.ERASMUS, a.location_ind, SCY.PAID_SANDWICH, SCY.UNPAID_SANDWICH  
    INTO abroad, non_erasmus_exchange, erasmus, location_ind, paid_sandwich, unpaid_sandwich
    FROM inst a, sgas.stud_crse_year scy, sgas.stud c, crse d, crse_year e, crse_session f, sgas.stud_session ss
    WHERE c.stud_ref_no = scy.stud_ref_no
         AND scy.crse_year_id = e.crse_year_id
         AND e.crse_session_id = f.crse_session_id
         AND f.crse_id = d.crse_id
         AND d.inst_code = a.inst_code
         AND scy.stud_session_id = ss.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id;
         
        CASE
                WHEN abroad = 'Y' AND non_erasmus_exchange = 'N' AND erasmus = 'Y' and location_ind <> 1
                    THEN fee_factor := 'N';   --ZERO FEE 
                WHEN (abroad = 'Y' AND non_erasmus_exchange = 'N' AND erasmus = 'N' AND part_year_abroad = 'Y') OR (paid_sandwich = 'Y' OR unpaid_sandwich = 'Y')
                    THEN fee_factor := 'H' ;  --HALF FEES 
                ELSE fee_factor := 'F' ; --FULL FEES 
             END CASE;
             
    RETURN fee_factor;         

    END get_fee_factor;

FUNCTION set_ruk_fee_cap(p_stud_crse_year_id IN NUMBER) RETURN NUMBER
IS

    ruk_fee_cap                     NUMBER;
    fee_override_amount             NUMBER;
    dearing                         CHAR;
    var_tuition_fee_amnt            NUMBER;
    fee_factor                      CHAR;
    var_sandwich_tuition_fee_amnt   NUMBER;
    session_code                    NUMBER;
    

BEGIN

    fee_factor := get_fee_factor (p_stud_crse_year_id);
    
    SELECT nvl(SCY.VARIABLE_FEE_OVERRIDE_AMOUNT,0), NVL(cy.VAR_TUITION_FEE_AMNT,0), NVL(cy.VAR_SANDWICH_TUITION_FEE_AMNT,0), scy.dearing, SS.SESSION_CODE
       INTO fee_override_amount, var_tuition_fee_amnt, var_sandwich_tuition_fee_amnt, dearing, session_code 
       FROM stud_crse_year scy,
             stud_session ss,
             crse c,
             crse_session cs,
             crse_year cy,
             inst i
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND c.crse_id = cs.crse_id
         AND cy.crse_session_id = cs.crse_session_id
         AND scy.crse_year_id = cy.crse_year_id
         AND scy.inst_code = i.inst_code
         AND ss.stud_session_id = scy.stud_session_id;


--add session specific details for 15% RUK ERASMUS fees
    IF session_code <= 2013
     THEN
       IF (fee_override_amount > 0 AND dearing = 'G')
        THEN
            ruk_fee_cap := fee_override_amount;
        ELSIF fee_factor = 'N'
        THEN
            ruk_fee_cap := 0;
        ELSIF fee_factor = 'H'
        THEN
            ruk_fee_cap := var_sandwich_tuition_fee_amnt;
        ELSIF fee_factor = 'F'
        THEN
            ruk_fee_cap := var_tuition_fee_amnt;
        END IF;
     ELSE  --*****NEW FOR 2014*****
      IF (fee_override_amount > 0 AND dearing = 'G')
        THEN
            ruk_fee_cap := fee_override_amount;
        ELSIF fee_factor = 'N'
        THEN
            ruk_fee_cap := var_tuition_fee_amnt;  --this will then be scaled down to 15% within rules engine 
        ELSIF fee_factor = 'H'
        THEN
            ruk_fee_cap := var_sandwich_tuition_fee_amnt;
        ELSIF fee_factor = 'F'
        THEN
            ruk_fee_cap := var_tuition_fee_amnt;
        END IF;
     
     
     END IF;
    
                
    RETURN ruk_fee_cap;

END set_ruk_fee_cap;

FUNCTION get_eu_residency(p_birth_country_code IN VARCHAR2,
                       p_nation_country_code IN VARCHAR2,
                       p_residence_county_code IN VARCHAR2,
                       p_ord_res_scotland_web IN VARCHAR2,
                       p_inscot_year IN VARCHAR2,
                       p_ord_res_uk_web IN VARCHAR2
            )
  RETURN VARCHAR2
  
  IS

    v_birth_value VARCHAR2(10);
    v_nation_value VARCHAR2(10);
    v_residence_value VARCHAR2(10);
    v_eu_residency VARCHAR2(1);

 BEGIN 
 
    IF (p_birth_country_code IS NULL OR p_nation_country_code IS NULL OR p_residence_county_code IS NULL OR p_ord_res_scotland_web IS NULL OR p_inscot_year IS NULL OR p_ord_res_uk_web IS NULL)
    THEN v_eu_residency := 'N';
    ELSE
    
            --get nationality region from birth country code
            SELECT nationality_region
            INTO v_birth_value
            FROM SGAS.NATIONALITY 
            WHERE country_code = p_birth_country_code;
            
            
            --get nationality region from nation country code
            SELECT nationality_region
            INTO v_nation_value
            FROM SGAS.NATIONALITY 
            WHERE country_code = p_nation_country_code;
            
            --get nationality region from residence county code 
            SELECT nationality_region
            INTO v_residence_value
            FROM SGAS.NATIONALITY 
            WHERE country_code = p_residence_county_code;
                
                
                CASE 
                WHEN v_birth_value = 'EU' AND v_nation_value = 'EU' AND  v_residence_value = 'EU' AND p_ord_res_scotland_web = 'Y'
                            AND p_inscot_year = 'Y' AND p_ord_res_uk_web = 'Y'
                THEN v_eu_residency := 'Y';
                ELSE v_eu_residency := 'N';

                END CASE;
                
    END IF;
                
    RETURN v_eu_residency;
        
    END get_eu_residency;
/* Formatted on 2012/11/14 14:56 (Formatter Plus v4.8.8) */
FUNCTION over_25_with_benfactors (p_stud_crse_year_id IN NUMBER)
   RETURN CHAR
IS
   relevant_date      DATE;
   over_25_with_ben   CHAR;
   c_1                NUMBER;
   l_dob                DATE;
   l_session_code       NUMBER;
   l_stud_ref_no        NUMBER;  

BEGIN
   SELECT sgas.pk_award_calculation.getrelevantstartdate (p_stud_crse_year_id)
     INTO relevant_date
     FROM DUAL;

   SELECT s.dob, SCY.SESSION_CODE, s.stud_ref_no
     INTO l_dob, l_session_code, l_stud_ref_no
     FROM stud s, stud_crse_year scy
    WHERE s.stud_ref_no = scy.stud_ref_no
      AND scy.stud_crse_year_id = p_stud_crse_year_id;

   IF (MONTHS_BETWEEN (relevant_date, l_dob) / 12) > 25
   THEN
      SELECT COUNT (*)
        INTO c_1
        FROM stud_session
       WHERE stud_ref_no = l_stud_ref_no
         AND session_code = l_session_code
         AND (   ben1_rel_id IN (30, 31, 32, 99)
              OR ben2_rel_id IN (30, 31, 32, 99)
             );

      IF (c_1 > 0)
      THEN
         over_25_with_ben := 'Y';
      ELSE
         over_25_with_ben := 'N';
      END IF;
   ELSE
      over_25_with_ben := 'N';
   END IF;

   RETURN over_25_with_ben;
END over_25_with_benfactors;      
      

/* Formatted on 20/06/2014 15:01:52 (QP5 v5.215.12089.38647) */
PROCEDURE dependants_doc (p_stud_crse_year_id   IN     NUMBER,
                          p_dependants_type     IN OUT dependants_cursor)
IS
BEGIN
   OPEN p_dependants_type FOR
      SELECT NVL (sd.income, 0) AS dependantincome,
             sgas.pk_award_calculation.getDependantDays (
                scy.stud_crse_year_id)
                AS DEP_DAYS,
        sgas.pk_award_calculation.getDependantDays_2022(scy.stud_crse_year_id) 
        AS DEP_DAYS_2022        
        FROM stud_crse_year scy, stud_dependant sd
       WHERE     scy.stud_crse_year_id = p_stud_crse_year_id
             AND sd.stud_session_id(+) = scy.stud_session_id
             AND sd.relation_id IN
                    (34,
                     35,
                     36,
                     37,
                     38,
                     39,
                     40,
                     41,
                     42,
                     43,
                     48,
                     49,
                     508,
                     509,
                     650);
END dependants_doc;


 --wrapper for webMethods code for CR526 interim report
 PROCEDURE eu_residency (p_birth_country_code IN VARCHAR2,
                       p_nation_country_code IN VARCHAR2,
                       p_residence_county_code IN VARCHAR2,
                       p_ord_res_scotland_web IN VARCHAR2,
                       p_inscot_year IN VARCHAR2,
                       p_ord_res_uk_web IN VARCHAR2,
                       l_eu_residency OUT VARCHAR2
                       )
IS



 BEGIN 
    
    
    l_eu_residency := SGAS.PK_AWARD_CALCULATION.get_eu_residency(p_birth_country_code,p_nation_country_code,p_residence_county_code,p_ord_res_scotland_web,p_inscot_year,p_ord_res_uk_web);
        
        
    END eu_residency;

PROCEDURE lpg_doc (p_stud_crse_year_id   IN     NUMBER,
                   p_lpg_type            IN OUT lpg_cursor)
IS
BEGIN
   OPEN p_lpg_type FOR
      SELECT NVL (
                sgas.pk_award_calculation.getHouseHoldIncome (
                   scy.stud_crse_year_id),
                0)
                AS studincome,
             sgas.pk_award_calculation.getlpgdays (scy.stud_crse_year_id)
                AS lpg_days,
             sgas.pk_award_calculation.getLPGDays_2022(scy.stud_crse_year_id)
                AS lpg_days_2022
        FROM stud_crse_year scy, stud_dependant sd, stud_session ss
       WHERE     scy.stud_crse_year_id = p_stud_crse_year_id
             AND sd.stud_session_id(+) = ss.stud_session_id
             AND ss.stud_session_id = scy.stud_session_id
             AND sd.relation_id IN
                    (46, 47, 510, 511, 600, 601, 602, 603, 705);
END lpg_doc;



PROCEDURE calculateawarddoc (
        p_stud_crse_year_id           IN       NUMBER,
        p_calculateaward_type   IN OUT   calculateaward_cursor,
        p_awards_cursor         IN OUT   all_award_cursor_type
)
IS

BEGIN
   OPEN p_awards_cursor FOR
      SELECT a.award_id, c.stud_award_type, 
      CASE
        WHEN C.LOAN_NON_LOAN_FEE = 'Loan'
            THEN 'Y'
        ELSE 'N'
        END isLoan
  FROM award a, stud_crse_year cy, stud_award_type c
 WHERE cy.stud_crse_year_id = p_stud_crse_year_id
   AND a.stud_crse_year_id = cy.stud_crse_year_id
   AND c.stud_award_type = a.stud_award_type
   order by award_id desc;


   OPEN p_calculateaward_type FOR
      SELECT scy.crse_id, scy.crse_year_no,
             sgas.pk_award_calculation.award_status(p_stud_crse_year_id) AS award, 
             CASE
                WHEN SCY.FIRST_CALC_DATE IS NOT NULL AND SCY.WITHDRAW_DATE IS NULL AND SCY.CRSE_CHG IS NULL
                   THEN 'D'    
                WHEN SCY.FIRST_CALC_DATE IS NOT NULL AND SCY.WITHDRAW_DATE IS NOT NULL AND SCY.CRSE_CHG IS NULL
                   THEN 'W'
                WHEN SCY.FIRST_CALC_DATE IS NOT NULL AND SCY.WITHDRAW_DATE IS NULL AND SCY.CRSE_CHG IS NOT NULL
                   THEN 'C'
                ELSE 'I'
             END assess_reason_code,  
             CASE
             WHEN      
             SGAS.PK_STEPS_PG_ED_PSYCH.checkIfPgEdPsychCourse(SCY.INST_CODE, SCY.CRSE_CODE) = 'Y'
                THEN
                    0
                ELSE ST.OVERPAYMENT
                END,
             CASE
                WHEN SGAS.PK_AWARD_CALCULATION.AWARD_STATUS(scy.stud_crse_year_id) = 'E' AND scy.SCHEME_TYPE = 'U' AND scy.paid_sandwich = 'N' AND scy.CALC_BURSARY = 'Y'
                   THEN 'Y'
                ELSE 'N'
                END CALC_BURSARY,
             SCY.CALC_FEE,
             CALC_LOAN,  
             SCY.ASSESS_LOAN, 
             SCY.CALC_DEP_GRANT,       
             SCY.CALC_LPG,  
             SCY.CALC_CESB,
             SCY.CALC_SAG,
             SCY.CALC_PG_ED_PSYCH_GRANT,
             SCY.CALC_PG_ED_PSYCH_FEES,
             SCY.CALC_PG_ED_PSYCH_QEPS,
             SGAS.PK_STEPS_PG_ED_PSYCH.checkIfPgEdPsychCourse(SCY.INST_CODE, SCY.CRSE_CODE) AS isPgEdPsychCourse,
             SCY.LATEST_CRSE_IND, 
             tft.tuition_fee_type_code, 
             SCY.NON_ATT_ACTIONED, 
             SCY.NON_ATT_ACTIONED_DATE, 
              CASE
                    WHEN scy.withdraw_date IS NOT NULL
                        THEN 'W'
                    WHEN scy.non_att_actioned = 'Y' AND scy.non_att_actioned_date IS NOT NULL
                    THEN 'A'
                    ELSE 'C' 
                END app_status,
             SCY.INST_CODE,
             sgas.pk_award_calculation.getDependantMaxDates (p_stud_crse_year_id) as depEnd,
             sgas.pk_award_calculation.getDependantMinDates (p_stud_crse_year_id) as depStart,
             sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,1)  AS courseStartDate,
             SCY.START_DATE,
             SCY.CALC_PG_ED_PSYCH_GRANT_PHD,
             SCY.CALC_PG_ED_PSYCH_FEES_PHD
        FROM stud_crse_year scy,
             stud_session ss,
             crse_session cs,
             crse_year cy,
             tuition_fee_type@grass tft,
             crse crs,
             stud st,
             inst inst,
             stud_term_addr sta,
             campus cam,
             stud_dependant sd
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id
         AND cs.crse_session_id = cy.crse_session_id
         AND sta.stud_ref_no = st.stud_ref_no
         AND scy.stud_session_id = ss.stud_session_id
         AND crs.crse_id = cs.crse_id
         AND inst.inst_code = crs.inst_code
         AND cy.crse_year_id = scy.crse_year_id
         AND st.stud_ref_no = scy.stud_ref_no
         AND inst.inst_code = SCY.INST_CODE
         AND crs.fees_campus = cam.campus_id
         AND SD.STUD_SESSION_ID(+) = SCY.STUD_SESSION_ID
         AND tft.tuition_fee_type_code(+) = cs.tuition_fee_type_code;

END calculateawarddoc;

/* Formatted on 2013/01/08 17:11 (Formatter Plus v4.8.8) */
PROCEDURE getrules_doc (
   p_stud_crse_year_id   IN       NUMBER,
   p_rules_type          IN OUT   rules_type_cursor
)
IS
BEGIN
   OPEN p_rules_type FOR
      SELECT a.location_ind,                                  ---STUDENT_TYPE
                            c.commence_session,               ---STUDENT_TYPE
             DECODE (scy.pgce, NULL, 'N', scy.pgce) AS pgce,   --STUDENT_TYPE
                                                            d.scheme_type,
                                                               --STUDENT_TYPE
             sgas.pk_award_calculation.relativedays
                                       (scy.stud_crse_year_id)
                                                             AS days_in_year,
                                                            --LPG_DOC, DG_DOC
             CASE
                WHEN ss.ben1_rel_id = 28
                   THEN 'S'
                WHEN ss.ben1_rel_id IS NULL
                   THEN 'N'
                ELSE 'P'
             END benefactor_relation,                       ---STUDENT_STATUS
             scy.parent_contrib_exempt AS ben_exempt,       ---STUDENT_STATUS
             NVL (scy.pay_ysb, 'N') AS ysb_override,        ---STUDENT_STATUS
             NVL (scy.pay_isb, 'N') AS isb_override,        ---STUDENT_STATUS
             CASE
                WHEN sgas.pk_award_calculation.award_status
                                      (scy.stud_crse_year_id) =
                                                         'E'
                AND scy.scheme_type = 'U'
                AND scy.paid_sandwich = 'N'
                AND scy.calc_bursary = 'Y'
                   THEN 'Y'
                ELSE 'N'
             END calculatebursary,                                  --BURSARY
             sgas.pk_award_calculation.gethouseholdincome
                                   (scy.stud_crse_year_id)
                                                         AS household_income,
                                                            --BURSARY + LOANS
             sgas.rules_proc_recalc.daysinattendance
                                   (scy.stud_crse_year_id)
                                                         AS daysinattendance,
                                                                    --BURSARY
             sgas.rules_proc_recalc.get_courselength
                                     (scy.stud_crse_year_id)
                                                           AS days_in_course,
                                                                    --BURSARY
             NVL (sgas.ss.bursary_deduction, 0), scy.inst_code,      ----FEES
             NVL (ss.fee_loan_request_amount, -1),
----THIS WILL MEAN 0 WAS NOT PUT IN BY CASEWORKER TO FORCE ZERO.  THIS WILL TAKE ruKFeeCap route. --FEES
             NVL (scy.self_funding, 'N') AS self_funding,              --FEES
             CASE
                WHEN scy.calc_fee = 'Y'
                AND d.pams_course <> 'Y'
                AND a.location_ind <> 1
                AND ss.fee_loan_request_amount IS NULL
                AND ss.max_fee_loan_requested IS NULL
                AND scy.scheme_type = 'U'
                AND scy.pgce = 'Y'                 --RUK G NOT TO GET FEE LOAN
                   THEN 'N'
                WHEN scy.calc_fee = 'Y'
                AND d.pams_course <> 'Y'
                AND a.location_ind <> 1
                AND ss.fee_loan_request_amount IS NULL
                AND ss.max_fee_loan_requested IS NULL
                AND scy.pgce = 'N'
                AND c.commence_session >= 2006   -- RUK  G NOT TO GET FEE LOAN
                   THEN 'N'
                ELSE scy.calc_fee
             END calc_fee,                                            ---FEES
             d.qual_type,                                             ---FEES
                         a.non_public_fund,                           ---FEES
             NVL (ss.max_fee_loan_requested, 'N'),                    ---FEES
             rules_proc_recalc.getfeespaidamount
                                     (p_stud_crse_year_id)
                                                         AS fees_paid_amount,
                                                                      ---FEES
             NVL (scy.psas_pt, 'N') AS parttimepg,                    ---FEES
             CASE
                WHEN (scy.calc_fee = 'Y' OR scy.calc_pg_ed_psych_fees = 'Y' OR scy.calc_pg_ed_psych_qeps = 'Y' OR scy.calc_pg_ed_psych_fees_phd = 'Y' )
                AND sgas.rules_proc_recalc.getattendfeecutoffdate
                                                        (scy.stud_crse_year_id) =
                                                                           'Y'
                AND sgas.rules_proc_recalc.prevfees (scy.stud_crse_year_id) =
                                                                           'N'
                   THEN 'Y'
                ELSE 'N'
             END attendfeecutoff,                                     ---FEES
             sgas.pk_award_calculation.get_fee_factor
                                           (p_stud_crse_year_id)
                                                               AS fee_factor,
             CASE
                WHEN a.location_ind <> 1
                   THEN sgas.pk_award_calculation.set_ruk_fee_cap
                                             (p_stud_crse_year_id)
                ELSE NVL
                       (sgas.pk_award_calculation.set_ruk_fee_cap
                                                          (p_stud_crse_year_id),
                        0
                       )
             END ruk_fee_cap,                                         ---FEES
             NVL (scy.variable_fee_override_amount, 0),               ---FEES
             NVL (scy.psas_non_fee_loan, 'N'),                        ---FEES
            CASE
                WHEN (    d.pams_course = 'Y'
                      AND scy.variable_fee_override_amount > 0 AND SS.SESSION_CODE >= 2012 -- SCOT F FROM RUK WHO APPLY TO SAAS FOR TUITION FEES
                     )
                   THEN 'Y'
                WHEN (d.pams_course = 'Y' AND SS.SESSION_CODE >= 2014 AND a.location_ind <> 1)  -- RUK 5 AND 6 MEDICAL STUDENTS
                   THEN 'Y'
                ELSE 'N'
             END ahp,                                           ---FEES
             scy.calc_loan,                                           --LOANS
                           NVL (ss.max_loan_requested, 'N'),          --LOANS
             ss.loan_request,                                          --LOANS
             SCY.CALC_CESB,
             SCY.CALC_PG_ED_PSYCH_GRANT,
             SCY.CALC_PG_ED_PSYCH_FEES,
             SCY.CALC_PG_ED_PSYCH_QEPS,
             SCY.GA_STUDENT,
             SS.EU_RESIDENCE_TYPE,
             NVL(SCY.WITHDRAW_DATE,TO_DATE(WITHDRAW_DATE,'DD/MM/YYYY'))  as withdrawalDate,
             SGAS.RULES_PROC_RECALC.DAYSINATTENDANCENOWITHDRAWAL(p_stud_crse_year_id) as daysInAttendanceNoWithdrawal,
             NVL(SCY.CRSE_CHG,TO_DATE(SCY.CRSE_CHG,'DD/MM/YYYY')) as courseChangeDate,
             --NVL(SCY.START_DATE,TO_DATE(SCY.START_DATE,'DD/MM/YYYY')) as studyStartDate,
             C.ESTRANGED_EVIDENCE,
             SS.ACCOMMODATION_FORMAL,
             SS.ACCOMMODATION_INFORMAL,  
             SCY.CALC_PG_ED_PSYCH_GRANT_PHD,
             SCY.CALC_PG_ED_PSYCH_FEES_PHD            
        FROM inst a,
             sgas.stud_crse_year scy,
             sgas.stud c,
             crse d,
             crse_year e,
             crse_session f,
             sgas.stud_session ss
       WHERE c.stud_ref_no = scy.stud_ref_no
         AND scy.crse_year_id = e.crse_year_id
         AND e.crse_session_id = f.crse_session_id
         AND f.crse_id = d.crse_id
         AND d.inst_code = a.inst_code
         AND scy.stud_session_id = ss.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id;
END getrules_doc;


PROCEDURE updateawardstatusNMSBAwardCalc (
      
      stud_crse_year_id_in        IN       VARCHAR2,
      nmsb_fees_in                IN       VARCHAR2,      
      nmsbbursary_in              IN       VARCHAR2,
      nmsb_dep_allow_in           IN       VARCHAR2,
      nmsb_sp_allow_in            IN       VARCHAR2,
      nmsb_childcare_allow_in     IN       VARCHAR2,
      user_id_in                  IN       VARCHAR2,
      error_boolean               IN OUT      VARCHAR2,
      ERROR_TEXT                  IN OUT      VARCHAR2
   )
   IS
   
   row_count NUMBER;
   
   BEGIN

    IF(nmsb_fees_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_fees_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'FEES', nmsb_fees_in,user_id_in); 
        END IF;
    END IF;

    
    IF(nmsbbursary_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type LIKE '%NURSING AND MIDWIFERY BURSARY';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsbbursary_in, award_type = 'PARAMEDIC, NURSING AND MIDWIFERY BURSARY',  last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type LIKE '%NURSING AND MIDWIFERY BURSARY';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PARAMEDIC, NURSING AND MIDWIFERY BURSARY', nmsbbursary_in,user_id_in); 
        END IF;
    END IF;
    
    IF(nmsb_dep_allow_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS ALLOWANCE';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_dep_allow_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS ALLOWANCE';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'DEPENDANTS ALLOWANCE', nmsb_dep_allow_in,user_id_in); 
        END IF;
    END IF;
    
    IF(nmsb_sp_allow_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='SINGLE PARENTS ALLOWANCE';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_sp_allow_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='SINGLE PARENTS ALLOWANCE';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'SINGLE PARENTS ALLOWANCE', nmsb_sp_allow_in,user_id_in); 
        END IF;
    END IF;
    
    IF(nmsb_childcare_allow_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CHILDCARE ALLOWANCE FOR PARENTS';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = nmsb_childcare_allow_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CHILDCARE ALLOWANCE FOR PARENTS';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'CHILDCARE ALLOWANCE FOR PARENTS', nmsb_childcare_allow_in,user_id_in); 
        END IF;
    END IF;
        
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateawardstatusNMSBAwardCalc;


PROCEDURE updateawardstatusAwardCalc (      
      stud_crse_year_id_in        	IN      VARCHAR2,
      fees_in                     	IN      VARCHAR2,
      loan_in                     	IN      VARCHAR2,
      lp_grant_in                 	IN      VARCHAR2,
      bursary_in                  	IN      VARCHAR2,
      dep_grant_in                	IN      VARCHAR2,
      care_exp_bursary_in         	IN      VARCHAR2,
      pg_ed_psych_fees_in         	IN      VARCHAR2,
      pg_ed_psych_qeps_in         	IN      VARCHAR2,
      pg_ed_psych_grant_in        	IN      VARCHAR2,   
      pg_ed_psych_fees_phd_in    	IN     	VARCHAR2,
      pg_ed_psych_grant_phd_in   	IN     	VARCHAR2,		  
      user_id_in                  	IN      VARCHAR2,
      error_boolean               	IN OUT 	VARCHAR2,
      ERROR_TEXT                  	IN OUT  VARCHAR2
   )
   IS
   
   row_count NUMBER;
   
   BEGIN
    
    IF(fees_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = fees_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='FEES';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'FEES', fees_in,user_id_in); 
        END IF;
    END IF;
    
    IF(loan_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LOAN';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = loan_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LOAN';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'LOAN', loan_in,user_id_in); 
        END IF;
    END IF;
    
    IF(bursary_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='BURSARY';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = bursary_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='BURSARY';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'BURSARY', bursary_in,user_id_in); 
        END IF;
    END IF;
    
    IF(dep_grant_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = dep_grant_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='DEPENDANTS GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'DEPENDANTS GRANT', dep_grant_in,user_id_in); 
        END IF;
    END IF;
        
    IF(lp_grant_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LONE PARENT GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = lp_grant_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='LONE PARENT GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'LONE PARENT GRANT', lp_grant_in,user_id_in); 
        END IF;
    END IF;
    
    IF(care_exp_bursary_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CARE EXPERIENCED BURSARY';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = care_exp_bursary_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='CARE EXPERIENCED BURSARY';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'CARE EXPERIENCED BURSARY', care_exp_bursary_in,user_id_in); 
        END IF;
    END IF;
        
    IF(pg_ed_psych_fees_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='MSC FEES GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_fees_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='MSC FEES GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'MSC FEES GRANT', pg_ed_psych_fees_in,user_id_in); 
        END IF;
    END IF;    
    
    IF(pg_ed_psych_qeps_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='QEP(S) FEES GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_qeps_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='QEP(S) FEES GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'QEP(S) FEES GRANT', pg_ed_psych_qeps_in,user_id_in); 
        END IF;
    END IF;    
        
    IF(pg_ed_psych_grant_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_grant_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT', pg_ed_psych_grant_in,user_id_in); 
        END IF;
    END IF;       

    IF(pg_ed_psych_fees_phd_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PHD FEES GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_fees_phd_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PHD FEES GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PHD FEES GRANT', pg_ed_psych_fees_phd_in,user_id_in); 
        END IF;
    END IF;    	
    
    IF(pg_ed_psych_grant_phd_in!='0')
    THEN
        SELECT COUNT(stud_crse_year_id) INTO row_count FROM stud_award_status WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PHD EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT';
    
        IF(row_count=1)
        THEN
            UPDATE stud_award_status SET award_status_message_id = pg_ed_psych_grant_phd_in, last_updated_by=user_id_in, last_updated_on=SYSDATE WHERE stud_crse_year_id=stud_crse_year_id_in AND award_type='PHD EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT';
        ELSE
            INSERT INTO stud_award_status(stud_crse_year_id, award_type, award_status_message_id,last_updated_by) VALUES(stud_crse_year_id_in, 'PHD EDUCATIONAL PSYCHOLOGY LIVING COSTS GRANT', pg_ed_psych_grant_phd_in,user_id_in); 
        END IF;
    END IF;  	
	
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateawardstatusAwardCalc;
         
END PK_AWARD_CALCULATION;
/
