CREATE OR REPLACE PACKAGE BODY SGAS.nmsb_rules_proc_recalc
AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC_RECALC
   PURPOSE:    This package is used in order to supply the Rules service with values in which to calculate the NMSB Student Award

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01.07.2010   Paul Hughes     Created this package body

******************************************************************************/

---THIS IS A SIMPLE FLAG TO SEE IF NMSB_SPEC_ARR RECORDS EXIST.          

FUNCTION SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN CHAR
IS

l_count     NUMBER;
l_number    NUMBER;
l_result    CHAR;

BEGIN

    SELECT count(*)
    INTO l_number
    FROM AWARD a
    WHERE award_id = p_award_id
    AND stud_award_type = 'SNCAP';
    
    IF l_number > 0 --THIS IS SNCAP TYPE WE NEED TO DO FURTHER ANALYSIS
        THEN

                                    ---IF ANY MODIFICATIONS ARE MADE TO THIS SQL PLEASE ALSO UPDATE FUNCTION SNCAPNMSBDAYSINTERM
                                SELECT COUNT(*) 
                                INTO l_count
                                FROM(
                                SELECT a.stud_ref_no
                                FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
                                WHERE a.stud_ref_no = b.stud_ref_no
                                AND a.session_code = b.session_code
                                AND a.nmsb_spec_arr_type IN('M','C')
                                AND a.recommence_date IS NOT NULL
                                AND b.stud_crse_year_id = p_stud_crse_year_id
                                UNION
                                SELECT a.stud_ref_no
                                FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
                                WHERE a.stud_ref_no = b.stud_ref_no
                                AND a.session_code = b.session_code
                                AND a.nmsb_spec_arr_type IN('M','C')
                                AND b.stud_crse_year_id = p_stud_crse_year_id
                                AND a.recommence_date IS NULL
                                UNION
                                SELECT a.stud_ref_no
                                FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
                                WHERE a.stud_ref_no = b.stud_ref_no
                                AND a.session_code = b.session_code
                                AND a.nmsb_spec_arr_type = 'E'
                                AND b.stud_crse_year_id = p_stud_crse_year_id
                                AND a.recommence_date IS NULL
                                UNION
                                SELECT a.stud_ref_no
                                FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
                                WHERE a.stud_ref_no = b.stud_ref_no
                                AND a.session_code = b.session_code
                                and a.nmsb_spec_arr_type = 'E'
                                and b.stud_crse_year_id = p_stud_crse_year_id
                                AND a.recommence_date + 3 > a.end_date
                                AND a.recommence_date IS NOT NULL);

                                IF l_count > 0
                                THEN l_result := 'Y';
                                ELSE l_result := 'N';
                                END IF;
                                
    ELSE l_result := 'N';
    END IF;
    
    RETURN l_result;
    
    END SNCAP_SPEC_RECORD_EXIST;
    
FUNCTION NON_SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN CHAR
IS

    l_count     NUMBER;
    l_number    NUMBER;
    l_result    CHAR;
    
BEGIN

    SELECT count(*)
    INTO l_number
    FROM AWARD a
    WHERE award_id = p_award_id
    AND stud_award_type NOT IN('SNCAP','SNIE');
    
    IF l_number > 0
        THEN

                            --IF ANY MODIFICATIONS ARE MADE TO SQL BELOW PLEASE ALSO AMEND SQL AT FUNCTION NMSB_DAYS_IN_TERM
                            SELECT COUNT(*)
                            INTO l_count
                            FROM (
                            SELECT a.stud_ref_no
                            FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
                            WHERE a.stud_ref_no = b.stud_ref_no
                            AND a.session_code = b.session_code
                            AND a.nmsb_spec_arr_type IN('M','C','E')
                            AND b.stud_crse_year_id = p_stud_crse_year_id
                            AND a.recommence_date+3 > a.end_date
                            AND a.recommence_date IS NOT NULL
                            UNION
                            SELECT a.stud_ref_no
                            FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
                            WHERE a.stud_ref_no = b.stud_ref_no
                            AND a.session_code = b.session_code
                            AND a.nmsb_spec_arr_type IN('M','C','E')
                            AND b.stud_crse_year_id = p_stud_crse_year_id
                            AND a.recommence_date IS NULL);
                            
                                IF l_count > 0
                            THEN l_result := 'Y';
                            ELSE l_result := 'N';
                            END IF;
                            
    ELSE l_result := 'N';
   
    END IF;
    
    RETURN l_result;
    
END NON_SNCAP_SPEC_RECORD_EXIST;
    
        

FUNCTION numberOfTermsIncludingStartEnd(p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN NUMBER
IS

  --  l_sncap CHAR;
  --  l_nonsncap  CHAR;
    l_days   NUMBER;
    l_result NUMBER;
    l_no_terms NUMBER;
    l_final NUMBER      :=0;
  --  l_startDateExist CHAR;

BEGIN

            
            l_no_terms := sgas.rules_proc_recalc.number_of_terms(p_stud_crse_year_id);
           -- l_sncap := SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id, p_award_id);
           -- l_nonsncap  := NON_SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id, p_award_id);
            
            
            IF sgas.rules_proc_recalc.checkStartDate(p_stud_crse_year_id) = 'N' AND SGAS.RULES_PROC_RECALC.CHECKWITHDRAWORCRSECHNG(p_stud_crse_year_id) = 'N'
                                THEN l_final := l_no_terms;   ---THERE IS NO NEED TO LOOP OVER TERMS IF THESE ARE BLANK ITS A SIMPLE RETURN OF THE NUMBER OF TERMS
                                
                        ELSE
           
                                --we don't want to have to do with if there is no course change, withdraw_date or start_date so we check this first.
                                for idx in 1..l_no_terms loop

                                l_days :=  RULES_PROC_RECALC.getDaysInAttendanceInTerm(p_stud_crse_year_id,idx);

                                IF l_days > 0
                                    THEN l_result := 1;
                                    ELSE l_result := 0;
                                END IF;
                                
                                l_final := l_final + l_result;
                                
                                end loop;
           
                        END IF;
            
            
            
            
            /*
            
            
            IF l_sncap = 'N' and l_nonsncap = 'Y'
                THEN
                
                                for idx in 1..l_no_terms loop

                                l_days :=  NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(p_stud_crse_year_id,idx);
                                
                                
                                IF l_days > 0
                                    THEN l_result := 1;
                                    ELSE l_result := 0;
                                END IF;
                                
                                l_final := l_final + l_result;
                                
                                end loop;
                                
           ELSIF l_sncap = 'Y' AND l_nonsncap = 'N'
                THEN
                                for idx in 1..l_no_terms loop

                                l_days :=  NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(p_stud_crse_year_id,idx);
                                
                                
                                IF l_days > 0
                                    THEN l_result := 1;
                                    ELSE l_result := 0;
                                END IF;
                                
                                l_final := l_final + l_result;
                                
                                end loop;
                                
           ELSE 
                        IF sgas.rules_proc_recalc.checkStartDate(p_stud_crse_year_id) = 'N' AND SGAS.RULES_PROC_RECALC.CHECKWITHDRAWORCRSECHNG(p_stud_crse_year_id) = 'N'
                                THEN l_final := l_no_terms;   ---THERE IS NO NEED TO LOOP OVER TERMS IF THESE ARE BLANK ITS A SIMPLE RETURN OF THE NUMBER OF TERMS
                                
                        ELSE
           
                                --we don't want to have to do with if there is no course change, withdraw_date or start_date so we check this first.
                                for idx in 1..l_no_terms loop

                                l_days :=  RULES_PROC_RECALC.getDaysInAttendanceInTerm(p_stud_crse_year_id,idx);

                                IF l_days > 0
                                    THEN l_result := 1;
                                    ELSE l_result := 0;
                                END IF;
                                
                                l_final := l_final + l_result;
                                
                                end loop;
           
                        END IF;
           
           END IF;       
           
           */       

        RETURN l_final; 
      
      
END numberOfTermsIncludingStartEnd; 
           

FUNCTION NMSBSPECARRRecordExist (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_record_exist      CHAR;
    l_count             NUMBER;
    
BEGIN

    SELECT COUNT(*)
    INTO l_count
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    AND b.latest_crse_ind = 'Y'
    AND b.stud_crse_year_id = p_stud_crse_year_id;
    
        IF l_count > 0
        THEN l_record_exist := 'Y';
        ELSE l_record_exist :='N';
        END IF;
        
  RETURN l_record_exist;

END NMSBSPECARRRecordExist;


---THIS WORKS OUT THE VALUE USED IN THE AWARD_CALCULATION FOR SNCAP AWARDS.  IT WILL RETURN, 0, 1 or a floating point number
FUNCTION SNCAPNMSBDAYSINTERM (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN FLOAT
IS

    spec_arr_record_exist   CHAR;
    l_daysInTerm            NUMBER;
    l_daysinattendance      NUMBER;
    l_maxTermStart          DATE;
    l_minTermEnd            DATE;
    l_holidays              NUMBER;
    l_result                FLOAT;
    

   ----GETS THE RELEVANT INFORMATION FROM THE NMSB_SPEC_ARR TABLE
    CURSOR c_nmsb_dates IS


    --IF ANY MODICATIONS ARE MADE TO THIS SQL PLEASE AMEND FUNCTION SNCAP_SPEC_RECORD_EXIST FUNCTION
    SELECT a.start_date as start_date, a.recommence_date-1 as end_date
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    AND a.nmsb_spec_arr_type IN('M','C')
    AND a.recommence_date IS NOT NULL
    AND b.stud_crse_year_id = p_stud_crse_year_id
    UNION
    SELECT a.start_date as start_date, sgas.rules_proc_recalc.getstudyenddate(b.stud_crse_year_id) as end_date
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    AND a.nmsb_spec_arr_type IN('M','C')
    AND b.stud_crse_year_id = p_stud_crse_year_id
    AND a.recommence_date IS NULL
    UNION
    SELECT a.start_date as start_date, sgas.rules_proc_recalc.getstudyenddate(b.stud_crse_year_id) as end_date
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    AND a.nmsb_spec_arr_type = 'E'
    AND b.stud_crse_year_id = p_stud_crse_year_id
    AND a.recommence_date IS NULL
    UNION
    SELECT a.end_date as start_date, recommence_date as end_date
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    and a.nmsb_spec_arr_type = 'E'
    and b.stud_crse_year_id = p_stud_crse_year_id
    AND a.recommence_date + 3 > a.end_date
    AND a.recommence_date IS NOT NULL;
    
    
    v_nmsb_dates    c_nmsb_dates%ROWTYPE;
    

BEGIN

        spec_arr_record_exist := NMSB_RULES_PROC_RECALC.NMSBSPECARRRecordExist(p_stud_crse_year_id);  
        l_daysInTerm := SGAS.RULES_PROC_RECALC.getDaysInAttendanceInTerm(p_stud_crse_year_id, p_term_no);
        l_daysinattendance := SGAS.RULES_PROC_RECALC.DAYSINATTENDANCE(p_stud_crse_year_id);
        
        
            
      --RETURNS START OF TERM ( THIS MAYBE NULL VALUE)  
      SELECT NVL(NMSB_RULES_PROC_RECALC.getMAXStartDateTerm(p_stud_crse_year_id, p_term_no),TO_DATE('01/01/9999','DD/MM/YYYY'))
      INTO l_maxTermStart
      FROM DUAL;
      
      --RETURNS END OF TERM (THIS MAYBE NULL VALUE)
      SELECT NVL(NMSB_RULES_PROC_RECALC.GETMINENDDATETERM(p_stud_crse_year_id, p_term_no),TO_DATE('01/01/9999','DD/MM/YYYY'))
      INTO l_minTermEnd
      FROM DUAL;
       
      
            CASE 
            WHEN spec_arr_record_exist = 'Y' AND (TRUNC(l_maxTermStart) = TO_DATE('01/01/9999','DD/MM/YYYY') OR TRUNC(l_minTermEnd) = TO_DATE('01/01/9999','DD/MM/YYYY'))
            THEN l_result := 0;  
            WHEN spec_arr_record_exist = 'N'      
            THEN l_result := 1;
            ELSE ---REMAINING MAIN LOGIC IS IN THIS SECTION  spec_arr_record_exist = 'Y'
            
            l_holidays := 0;
            
             OPEN c_nmsb_dates;
                                                   
                            LOOP 

                                FETCH c_nmsb_dates
                                INTO v_nmsb_dates;
                                
                                EXIT WHEN c_nmsb_dates%NOTFOUND;
                                
                                             
                                                CASE 
                                                WHEN TRUNC(v_nmsb_dates.start_date) BETWEEN TRUNC (l_maxTermStart) AND TRUNC(l_minTermEnd)
                                                THEN 
                                                        IF v_nmsb_dates.start_date >= l_maxTermStart AND v_nmsb_dates.end_date <= l_minTermEnd
                                                        
                                                        THEN l_holidays := l_holidays + (v_nmsb_dates.end_date+1 - v_nmsb_dates.start_date);
                                                        
                                                        ELSIF (v_nmsb_dates.start_date) >= (l_maxTermStart) AND (v_nmsb_dates.end_date) > (l_minTermEnd)
                                                        
                                                        THEN l_holidays := l_holidays + (l_minTermEnd+1 - v_nmsb_dates.start_date);
                                                        END IF;
                                                        
                                                        
                                                WHEN TRUNC(v_nmsb_dates.end_date) BETWEEN TRUNC (l_maxTermStart) AND TRUNC(l_minTermEnd)
                                                THEN 
                                                        IF v_nmsb_dates.start_date < l_maxTermStart AND v_nmsb_dates.end_date <= l_minTermEnd
                                                        
                                                        THEN l_holidays := l_holidays + (v_nmsb_dates.end_date+1 - l_maxTermStart);
                                                        END IF;
                                                        
                                                WHEN TRUNC(v_nmsb_dates.end_date) > l_minTermEnd AND TRUNC(v_nmsb_dates.start_date) < l_maxTermStart
                                                
                                                        THEN l_holidays := 9999;
                                                ELSE l_holidays := l_holidays + 0;
                                             END CASE;
                                    
                             END LOOP;
                             
                             CLOSE c_nmsb_dates;
                             
                        IF l_holidays = 0
                                THEN l_result := 1;
                            ELSIF l_holidays >= 9999
                                THEN l_result :=0;
                            ELSE l_result := (l_daysInTerm - l_holidays)/l_daysinattendance;
                            END IF;
            
            
         
            END CASE;

     
     RETURN l_result;


END SNCAPNMSBDAYSINTERM;


---THIS WORKS OUT THE VALUE USED IN THE AWARD_CALCULATION FOR NON SNCAP AWARDS.  IT WILL RETURN, 0, 1 or a floating point number
FUNCTION NMSBDAYSINTERM (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN FLOAT
IS

    spec_arr_record_exist   CHAR;
    l_daysInTerm            NUMBER;
    l_daysinattendance      NUMBER;
    l_maxTermStart          DATE;
    l_minTermEnd            DATE;
    l_holidays              NUMBER;
    l_result                FLOAT;
    X                       NUMBER;
    

   ----GETS THE RELEVANT INFORMATION FROM THE NMSB_SPEC_ARR TABLE
    CURSOR c_nmsb_dates IS

    ---IF ANY MODIFICATIONS ARE MADE TO SQL BELOW PLEASE UPDATE FUNCTION NON_SNCAP_SPEC_RECORD_EXIST 
----THESE DATES ARE NOT PAID
    SELECT END_DATE+1 as start_date, recommence_date-1 as end_date
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    AND a.nmsb_spec_arr_type IN('M','C','E')
    AND b.stud_crse_year_id = p_stud_crse_year_id
    AND a.recommence_date+3 > a.end_date
    AND a.recommence_date IS NOT NULL
    UNION
    SELECT a.end_date+1 as start_date, sgas.rules_proc_recalc.getstudyenddate(b.stud_crse_year_id) as end_date
    FROM NMSB_SPEC_ARR a, STUD_CRSE_YEAR b
    WHERE a.stud_ref_no = b.stud_ref_no
    AND a.session_code = b.session_code
    AND a.nmsb_spec_arr_type IN('M','C','E')
    AND b.stud_crse_year_id = p_stud_crse_year_id
    AND a.recommence_date IS NULL;
    
    
    v_nmsb_dates    c_nmsb_dates%ROWTYPE;
    

BEGIN

        spec_arr_record_exist := NMSB_RULES_PROC_RECALC.NMSBSPECARRRecordExist(p_stud_crse_year_id);  
        l_daysInTerm := SGAS.RULES_PROC_RECALC.getDaysInAttendanceInTerm(p_stud_crse_year_id, p_term_no);
        l_daysinattendance := SGAS.RULES_PROC_RECALC.DAYSINATTENDANCE(p_stud_crse_year_id);
        
        
            
      --RETURNS START OF TERM ( THIS MAYBE NULL VALUE)  
      SELECT NVL(NMSB_RULES_PROC_RECALC.getMAXStartDateTerm(p_stud_crse_year_id, p_term_no),TO_DATE('01/01/9999','DD/MM/YYYY'))
      INTO l_maxTermStart
      FROM DUAL;
      
      --RETURNS END OF TERM (THIS MAYBE NULL VALUE)
      SELECT NVL(NMSB_RULES_PROC_RECALC.GETMINENDDATETERM(p_stud_crse_year_id, p_term_no),TO_DATE('01/01/9999','DD/MM/YYYY'))
      INTO l_minTermEnd
      FROM DUAL;
       
      
            CASE 
            WHEN TRUNC(l_maxTermStart) = TO_DATE('01/01/9999','DD/MM/YYYY') OR TRUNC(l_minTermEnd) = TO_DATE('01/01/9999','DD/MM/YYYY')
            THEN l_result := 0;  
            WHEN spec_arr_record_exist = 'N'      
            THEN l_result := 1;
            ELSE ---REMAINING MAIN LOGIC IS IN THIS SECTION  spec_arr_record_exist = 'Y'
            
            l_holidays := 0;
            
             OPEN c_nmsb_dates;
                                                   
                            LOOP 

                                FETCH c_nmsb_dates
                                INTO v_nmsb_dates;
                                
                                EXIT WHEN c_nmsb_dates%NOTFOUND;
                                
                                                                                    
                                
                                            CASE 
                                                WHEN TRUNC(v_nmsb_dates.start_date) BETWEEN TRUNC (l_maxTermStart) AND TRUNC(l_minTermEnd)
                                                THEN 
                                                        IF v_nmsb_dates.start_date >= l_maxTermStart AND v_nmsb_dates.end_date <= l_minTermEnd
                                                        
                                                        THEN l_holidays := l_holidays + (v_nmsb_dates.end_date+1 - v_nmsb_dates.start_date);
                                                        
                                                        ELSIF (v_nmsb_dates.start_date) >= (l_maxTermStart) AND (v_nmsb_dates.end_date) > (l_minTermEnd)
                                                        
                                                        THEN l_holidays := l_holidays + (l_minTermEnd+1 - v_nmsb_dates.start_date);
                                                        END IF;
                                                        
                                                        
                                                WHEN TRUNC(v_nmsb_dates.end_date) BETWEEN TRUNC (l_maxTermStart) AND TRUNC(l_minTermEnd)
                                                THEN 
                                                        IF v_nmsb_dates.start_date < l_maxTermStart AND v_nmsb_dates.end_date <= l_minTermEnd
                                                        
                                                        THEN l_holidays := l_holidays + (v_nmsb_dates.end_date+1 - l_maxTermStart);
                                                        END IF;
                                                        
                                                        
                                                WHEN TRUNC(v_nmsb_dates.end_date) > l_minTermEnd AND TRUNC(v_nmsb_dates.start_date) < l_maxTermStart
                                                
                                                        THEN l_holidays := 9999;
                                                ELSE l_holidays := l_holidays + 0;
                                             END CASE;
                                    
                             END LOOP;
                             
                             CLOSE c_nmsb_dates;
                             
                            IF l_holidays = 0
                                THEN l_result := 1;
                            ELSIF l_holidays >= 9999
                                THEN l_result :=0;
                            ELSE l_result := (l_daysInTerm - l_holidays)/l_daysinattendance;
                            END IF;
            
         
            END CASE;

    -- RETURN l_holidays;
    RETURN l_result;
    


END NMSBDAYSINTERM;    

---STUDENT IS ENTITLED TO A DOUBLE PAYMENT ONLY IF THE START DATE IS EITHER NULL OR EXITS IN TERM 1 ONLY ELSE A SINGLE PAYMENT WILL BE MADE
FUNCTION doublePayment (p_stud_crse_year_id IN NUMBER) RETURN CHAR
IS

    l_double CHAR(1);
    l_temp  DATE;
    l_start CHAR(1);
    start_date  DATE;
    
    BEGIN
    
        l_start := SGAS.RULES_PROC_RECALC.checkStartDate(p_stud_crse_year_id);
    
        IF l_start = 'N'
        THEN l_double := 'Y';
        ELSE 
        
                 l_temp := SGAS.NMSB_RULES_PROC_RECALC.getTermEndDate(p_stud_crse_year_id,1);
        
                 SELECT start_date
                 INTO start_date
                 FROM stud_crse_year
                 WHERE stud_crse_year_id = p_stud_crse_year_id;
       
        
                    IF TRUNC(start_date) > TRUNC(l_temp)
                    THEN l_double := 'N';
                    ELSE l_double := 'Y';
                    END IF;
                    
        END IF;
        
  RETURN l_double;
  
END doublePayment;

---THIS FUNCTION SIMPLY RETURNS THE LAST DAY OF THE TERM (IT DOES NOT TAKE COURSE CHANGE OR WITHDRAW DATES INTO ACCOUNT
FUNCTION getTermEndDate (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE
IS

    l_end_date DATE;
    l_default_term CHAR(1);
    l_max_term CHAR(2);
    
BEGIN

        l_default_term := sgas.rules_proc_recalc.check_default_terms (p_stud_crse_year_id);
        l_max_term     := sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);
        
      IF p_term_no <= l_max_term
      
        THEN  
      
        IF l_default_term = 'Y'
        
        THEN
            
                SELECT it.end_date
                INTO l_end_date
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT ct.end_date
                INTO l_end_date
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
                
           END IF;
                
       ELSE l_end_date := null;
       
       END IF;
       
       RETURN l_end_date;

END getTermEndDate;
        
---IF THERE IS A RECORD ON THE NMSB_SPEC_ARR TABLE WHICH HAPPENS TO OVERLAP ANY OF THE TERM DATES THIS WILL SET A FLAG TO 'Y'
FUNCTION overlaptermdates (p_stud_crse_year_id IN NUMBER, p_award_id IN NUMBER) RETURN CHAR
IS


    l_sncap     CHAR;
    l_nonsncap  CHAR;
    l_overlap CHAR(1);
    l_no_terms NUMBER;
    l_temp NUMBER;
    l_check NUMBER;
    l_records NUMBER;

BEGIN

    -- get number of terms to loop over
    
    l_sncap := SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id, p_award_id);
    l_nonsncap  := NON_SNCAP_SPEC_RECORD_EXIST(p_stud_crse_year_id, p_award_id);
    
    IF l_sncap = 'N' and l_nonsncap = 'N'
        THEN l_overlap := 'N';
        
    ELSIF   l_sncap = 'Y' AND l_nonsncap = 'N'
            THEN    
            
                            l_no_terms := sgas.rules_proc_recalc.number_of_terms(p_stud_crse_year_id);
                            
                            l_overlap := 'N';
                            
                                        for idx in 1..l_no_terms loop
                                        
                                        l_temp := sgas.NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(p_stud_crse_year_id, idx);
                                        
                                                IF l_temp <> 1
                                                    THEN l_overlap := 'Y';
                                                END IF;
                                                
                                      
                                        end loop;
                                        
     ELSE ---l_nonSNCAP = 'Y'
     
                            l_no_terms := sgas.rules_proc_recalc.number_of_terms(p_stud_crse_year_id);
                            
                            l_overlap := 'N';
     
                                         for idx in 1..l_no_terms loop
                                        
                                        l_temp := sgas.NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(p_stud_crse_year_id, idx);
                                        
                                                IF l_temp <> 1
                                                    THEN l_overlap := 'Y';
                                                END IF;
                                                
                                      
                                        end loop;
     
     END IF;
                                        
                                        
        
    
    
                            
                            IF l_overlap = NULL
                            THEN l_overlap := 'N';
                            END IF;
                         
    
    RETURN l_overlap;
    
    
END overlaptermdates;
              
---SIMPLE FUNCTION WHICH RETURNS THE MINIMUM VALUE BETWEEN COURSE_CHANGE_DATE AND WITHDRAW DATE.  IF NONE OF THESE DATES EXIST A NULL VALUE IS OUTPUT.
FUNCTION getMINWithdrawCrseChange (p_stud_crse_year_id IN NUMBER) RETURN DATE
IS
        l_end       DATE;
        l_withdraw  DATE;
        l_crse_chg  DATE;
        
        BEGIN
        
        
                SELECT NVL(scy.crse_chg,TO_DATE('01/01/3000','DD/MM/YYYY')), NVL(scy.withdraw_date,TO_DATE('01/01/3000','DD/MM/YYYY'))
                INTO l_crse_chg, l_withdraw 
                FROM stud_crse_year scy
                WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
                
                -- WE NEED TO FIND THE MIN DATE BETWEEN SCY.WITHDRAW_DATE, SCY.CRSE_CHG AND COURSE END DATE FOR TERM       
             
               CASE
               WHEN TRUNC(l_crse_chg) = TO_DATE('01/01/3000','DD/MM/YYYY') AND l_withdraw = TO_DATE('01/01/3000','DD/MM/YYYY')
                    THEN l_end := NULL;
                WHEN l_withdraw <= l_crse_chg
                    THEN l_end := l_withdraw;
                WHEN l_crse_chg < l_withdraw
                    THEN l_end := l_crse_chg;
                ELSE l_end := NULL;
                END CASE;
                
       RETURN l_end;
       
END getMINWithdrawCrseChange;
            

---THIS FUNCTION WILL RETURN THE START_DATE FROM STUD_CRSE_YEAR RECORD ONLY IF IT EXISTS IN THE TERM INSERTED INTO FUNCTION.  IF THE START_DATE
--IS AFTER THE TERM_END DATE IT WILL RETURN NULL.  NOTE:  THIS FUNCTION IS USED IN CONJUNTION WITH getMAXEndDateTerm.  This function does not take withdraw/crsechange into account
FUNCTION getMAXStartDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE
IS

    l_startDateExist    CHAR;  --- RETURNS 'Y' if stud_crse_Year.start_date exists
    l_scyStartDate      DATE;
    l_term_start_date   DATE;
    l_term_end_date     DATE;
    l_default_term      CHAR;
    l_result            DATE;
    
    BEGIN
    
    l_startDateExist:= sgas.rules_proc_recalc.checkStartDate(p_stud_crse_year_id);  ---RETURNS 'Y' IF START_DATE EXISTS
    l_default_term := sgas.rules_proc_recalc.check_default_terms(p_stud_crse_year_id);
    
        
    IF l_startDateExist = 'Y'
    
            THEN 
            
                SELECT scy.start_date
                INTO l_scyStartDate
                FROM STUD_CRSE_YEAR scy
                WHERE scy.stud_crse_year_id = p_stud_crse_year_id;
                
     END IF;
     
     IF l_default_term = 'Y'
        
            THEN
            
                SELECT it.start_date, it.end_date
                INTO l_term_start_date, l_term_end_date 
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT ct.start_date, ct.end_date
                INTO l_term_start_date, l_term_end_date 
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;

            END IF;
    
                
            CASE 
                WHEN l_scyStartDate > l_term_end_date
                        THEN l_result := NULL;
                WHEN (l_scyStartDate <= l_term_end_date) AND (l_scyStartDate <= l_term_start_date)
                        THEN l_result := l_term_start_date;
                WHEN (l_scyStartDate > l_term_start_date) AND (l_scyStartDate <= l_term_end_date)
                        THEN l_result := l_scyStartDate;
                WHEN l_scyStartDate IS NULL
                        THEN l_result := l_term_start_date;
                ELSE l_result := NULL;
            END CASE;
        
   RETURN l_result;
   
END getMAXStartDateTerm;

---THIS FUNCTION WILL RETURN MINIMUM BETWEEN WITHDRAW_DATE, CRSE_CHANGE_DATE OR TERM_END_DATE.  THIS FUNCTION MAY RETURN NULL IF THE STUDENT HAS WITHDRAWN OR CHANGED COURSE BEFORE
---THE TERM OR STARTED AFTER THE TERM ENDED.
FUNCTION getMINEndDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER) RETURN DATE
IS

    l_withdrawcrseExist     CHAR;  --- RETURNS 'Y' if stud_crse_Year.withdraw_date OR crse_change date exists
    l_minEndDate            DATE;   --HOLDS MINIMUM BETWEEN CRSE_CHANGE AND WITHDRAW DATE
    l_term_start_date       DATE;
    l_term_end_date         DATE;
    l_default_term          CHAR;
    l_result                DATE;
    
    BEGIN
    
    l_withdrawcrseExist := sgas.rules_proc_recalc.checkWithdrawOrCrseChng(p_stud_crse_year_id);  ---RETURNS 'Y' IF XISTS
    l_default_term := sgas.rules_proc_recalc.check_default_terms(p_stud_crse_year_id);
    
        
        IF l_withdrawcrseExist = 'Y'
    
            THEN 
                
                l_minEndDate :=  sgas.NMSB_RULES_PROC_RECALC.getMINWithdrawCrseChange(p_stud_crse_year_id);         
           
                
        END IF;
     
     IF l_default_term = 'Y'
        
            THEN
            
                SELECT it.start_date, it.end_date
                INTO l_term_start_date, l_term_end_date 
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT ct.start_date, ct.end_date
                INTO l_term_start_date, l_term_end_date 
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;

            END IF;
    
                
            CASE 
                WHEN l_minEndDate < l_term_start_date
                    THEN l_result := NULL;
                WHEN l_minEndDate > l_term_start_date AND l_minEndDate <= l_term_end_date
                    THEN l_result := l_minEndDate;
                WHEN l_minEndDate > l_term_end_date
                    THEN l_result := l_term_end_date;
                WHEN l_minEndDate IS NULL
                    THEN l_result := l_term_end_date;
                    
            END CASE;
        
   RETURN l_result;
   
END getMINEndDateTerm;
        
          
FUNCTION oldestChild (p_stud_crse_year_id IN NUMBER)RETURN NUMBER
   IS
 
   result   NUMBER;

   BEGIN


            SELECT MIN(c.std_id)
            INTO result
            FROM stud_crse_year a, stud_dependant c
            WHERE a.stud_session_id = c.stud_session_id(+)
            AND a.stud_crse_year_id = p_stud_crse_year_id
            AND c.relation_id <> 48
            AND trunc(c.dob) = (SELECT MIN(c.dob)
                                FROM stud_crse_year a, stud_dependant c
                                WHERE a.stud_session_id = c.stud_session_id(+)
                                  AND c.relation_id <> 48
                                  AND a.stud_crse_year_id = p_stud_crse_year_id);

            
      RETURN result;
      
   END oldestChild;


--This function requires student Reference Number, SesssionCode and the l_start_year which is the year the student started there course.  Tje service determines if
--the course is set-up or if default term dates should be used.  The Function will return 'Y' if default terms and 'N' if course set-up.
   FUNCTION check_default_startcourse (
      p_stud_crse_year_id   NUMBER,
      l_start_year          NUMBER
   )
      RETURN CHAR
   IS
      l_default_start   CHAR (1) := 'X';

      CURSOR c1
      IS
         SELECT a.default_terms
           FROM crse_year@grass a,
                stud_crse_year b,
                crse_session@grass c,
                crse d
          WHERE a.inst_code = b.inst_code
            AND b.crse_year_no = a.crse_year_no
            AND c.crse_session_id = a.crse_session_id
            AND d.crse_id = c.crse_id
            AND d.crse_code = b.crse_code
            AND c.session_code = l_start_year
            --The year the student started their course (input to service)
            AND b.stud_crse_year_id = p_stud_crse_year_id;
   BEGIN
      OPEN c1;

      FETCH c1
       INTO l_default_start;

      CLOSE c1;

      RETURN l_default_start;
   EXCEPTION
      WHEN NO_DATA_FOUND
--MAY OCCUR IF COURSE IS NOT SET UP - X will be returned which is handled in other Function to use default date of 1 AUGUST
      THEN
         l_default_start := 'X';
   END check_default_startcourse;


---THIS FUNCTION RETURNS THE STUDENTS AGE WHEN THEY STARTED THIER COURSE.  The service uses the start_date from course in first year and dob to work this value out.
   FUNCTION get_ageonstartcourse (p_stud_crse_year_id NUMBER)
      RETURN NUMBER
   IS
      l_default_term       CHAR (1) := '';
      l_ageonstartcourse   NUMBER;
      l_startfirstday      DATE;
   BEGIN
      l_startfirstday := get_startdateoffirstyear (p_stud_crse_year_id);

      --Returns start date of course in the first year.
      SELECT MONTHS_BETWEEN(l_startfirstday, a.dob)  / 12 age  --we need to calculate DAYS_BETWEEN not MONTHS_BETWEEN
   
     -- SELECT (l_startfirstday - a.dob) / 365
        INTO l_ageonstartcourse
        FROM stud a, stud_crse_year b
       WHERE a.stud_ref_no = b.stud_ref_no
         AND b.stud_crse_year_id = p_stud_crse_year_id;

      RETURN l_ageonstartcourse;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                     'Student with stud_crse_year_id '
                                  || p_stud_crse_year_id
                                  || ' does not exist in the StEPS database!'
                                 );
   END get_ageonstartcourse;

/*

--This function is used in order to determine the start year for a particular student.  This differs from commence session.
   FUNCTION get_startyearfirstyear (p_stud_crse_year_id NUMBER)
      RETURN NUMBER
   IS
    --  l_crse_year_no   NUMBER := 0;
    --  l_yearlessone    NUMBER := 0;
    --  l_startyear      NUMBER := 0;
    --  p_session_code   NUMBER := 0;
        l_commence_session NUMBER;
   BEGIN
   
            SELECT commence_session
            INTO l_commence_session
            FROM stud s, stud_crse_year scy
            WHERE s.stud_ref_no = scy.stud_ref_no
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
   
   
   /*
      SELECT crse_year_no, session_code
        INTO l_crse_year_no, p_session_code
        FROM stud_crse_year
       WHERE stud_crse_year_id = p_stud_crse_year_id;

      l_startyear := p_session_code - (l_crse_year_no - 1);
--Year 4 Student Example:    StartYear = 2009 (current Session) - (4 (courseYear) - 1)
   --
   
                             StartYear = 2009 - 3 = 2006
                             
                             
      RETURN l_startyear;
      
      
      
    RETURN l_commence_session;

   END get_startyearfirstyear;
   
 */

   --THIS FUNCTION RETURNS THE START DATE IN WHICH THE STUDENT STARTED THEIR COURSE.
   FUNCTION get_startdateoffirstyear (p_stud_crse_year_id NUMBER)
      RETURN DATE
   IS
      l_startfirstday   DATE;
      l_default_start   CHAR (1) := 'Y';
      l_start_year      NUMBER   := 0;
   BEGIN
      ---CHECK WHICH YEAR THERE COURSE STARTED
     -- l_start_year := get_startyearfirstyear (p_stud_crse_year_id);
      
            SELECT commence_session
            INTO l_start_year
            FROM stud s, stud_crse_year scy
            WHERE s.stud_ref_no = scy.stud_ref_no
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
      
      
      --CHECK TO SEE IF DEFAULT TERM DATES ARE USED WHEN THE STUDENT STARTED THERE COURSE
      l_default_start :=
                check_default_startcourse (p_stud_crse_year_id, l_start_year);

      CASE
         WHEN l_default_start = 'Y'
         THEN
            --DEFAULT TERMS ARE USED SO CHECK INST_TERM TABLE FOR THE YEAR IN WHICH THEY STARTED THERE COURSE
            SELECT a.start_date
              INTO l_startfirstday
              FROM inst_term@grass a, stud_crse_year b
             WHERE a.inst_code = b.inst_code
               AND a.session_code = l_start_year
               AND b.stud_crse_year_id = p_stud_crse_year_id
               AND a.term_no = 1;
         WHEN l_default_start = 'N'
         THEN
            --DEFAULT TERMS ARE NOT USED THEREFORE WE NEED TO LOOK UP THE CRSE_YEAR_ID FROM THERE FIRST YEAR
            SELECT a.start_date
              INTO l_startfirstday
              FROM crse_term@grass a,
                   crse_year@grass b,
                   stud_crse_year c,
                   crse_session@grass d,
                   crse@grass e
             WHERE a.crse_year_id = b.crse_year_id
               AND b.crse_session_id = d.crse_session_id
               AND d.crse_id = e.crse_id
               AND b.inst_code = c.inst_code   --- INSTITUTION CODE FROM STEPS
               AND b.crse_year_no =
                                c.crse_year_no
                                              -- COURSE YEAR NUMBER FROM STEPS
               AND c.crse_code = e.crse_code             --CRSECODE FROM STEPS
               AND c.stud_crse_year_id =
                      p_stud_crse_year_id
                      -- USING THE CURRENT STUDENT REFERENCE NUMBER FROM STEPS
               AND d.session_code =
                      l_start_year
              --  INPUTED FROM OTHER SERVICE AND IS YEAR STUDENT STARTED STUDY
               AND a.term_no = 1;
         ELSE
            l_startfirstday :=
                      TO_DATE (CONCAT ('01/08/', l_start_year), 'DD/MM/YYYY');
      END CASE;

      RETURN l_startfirstday;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                     'Student with stud_crse_year_id '
                                  || p_stud_crse_year_id
                                  || ' does not exist in the StEPS database!'
                                 );
   END get_startdateoffirstyear;

--    This looks up previous years snb_rate, if this does not exist we return a 'Y' (new student)
--    Otherwise if previous year record exists we return previous record.  N = N, Y = Y, Null = Y
   FUNCTION get_prev_single_rate (p_stud_crse_year_id NUMBER)
      RETURN CHAR
   IS
      l_single_rate    CHAR (1) := 'Y';
      p_session_code   NUMBER   := 0;
      p_stud_ref_no    NUMBER   := 0;
   BEGIN
      SELECT session_code, stud_ref_no
        INTO p_session_code, p_stud_ref_no
        FROM stud_crse_year
       WHERE stud_crse_year_id = p_stud_crse_year_id;

      SELECT iv1.snb_rate
        INTO l_single_rate
        FROM (SELECT NVL (a.snb_single_rate, 'Y') snb_rate
                FROM stud_crse_year@grass a
               WHERE a.stud_ref_no = p_stud_ref_no
                 AND a.session_code = (p_session_code - 1)
              UNION
              SELECT 'Y'                                -- no data, return 'Y'
                FROM DUAL) iv1
       WHERE ROWNUM < 2;

      RETURN l_single_rate;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                     'Student with stud_crse_year_id '
                                  || p_stud_crse_year_id
                                  || ' does not exist in the StEPS database!'
                                 );
   END get_prev_single_rate;

--This Function return  the numbet of student dependants  _ USED
   FUNCTION get_dependants (p_stud_crse_year_id IN NUMBER)
      RETURN NUMBER
   IS
      l_dependant   NUMBER := 0;
   BEGIN
      SELECT COUNT (std_id)
        INTO l_dependant
        FROM stud_dependant sd, stud_crse_year scy
       WHERE sd.stud_session_id = scy.stud_session_id
         AND scy.stud_crse_year_id = p_stud_crse_year_id;

      RETURN l_dependant;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                     'Student with stud_crse_year_id '
                                  || p_stud_crse_year_id
                                  || ' does not exist in the StEPS database!'
                                 );
   END get_dependants;

   
FUNCTION getEndDateTerm (p_stud_crse_year_id IN NUMBER, p_term_no NUMBER)
    RETURN DATE
IS 
    l_end_date DATE;
    l_default_term CHAR(1);
    l_max_term CHAR(2);
    
BEGIN

        l_default_term := sgas.rules_proc_recalc.check_default_terms (p_stud_crse_year_id);
        l_max_term     := sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);
        
      IF p_term_no <= l_max_term
      
        THEN  
      
        IF l_default_term = 'Y'
        
        THEN
            
                SELECT it.end_date
                INTO l_end_date
                FROM inst_term it, stud_crse_year scy
                WHERE scy.inst_code = it.inst_code
                AND scy.session_code = it.session_code
                AND it.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
              
            ELSE 
            
                SELECT NVL(ct.end_date,TO_DATE('01/01/9999','DD/MM/YYYY'))
                INTO l_end_date 
                from crse_term ct, stud_crse_year scy
                WHERE scy.crse_year_id = ct.crse_year_id
                AND ct.term_no = p_term_no
                AND scy.stud_crse_year_id = p_stud_crse_year_id;
                
           END IF;
                
       ELSE l_end_date := null;
       
       END IF;
       
       RETURN l_end_date;
       
END getEndDateTerm;
   
   

   PROCEDURE assessbursary_doc (
      p_stud_crse_year_id   IN              NUMBER,
      p_bursary_type        IN OUT          bursary_cursor,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
     -- l_start_date   DATE;
   --------------PROBLEM _ WHERE IS THIS SUPPOSED TO BE COMING FROM?
   BEGIN
      OPEN p_bursary_type FOR
         SELECT  sgas.rules_proc_recalc.daysinattendance (p_stud_crse_year_id) as daysInAttendance                                                         
           FROM stud_crse_year a, nmsb_spec_arr b, stud d
          WHERE a.stud_crse_year_id = p_stud_crse_year_id
            AND a.stud_ref_no = b.stud_ref_no(+)
            AND a.session_code = b.session_code(+)
            AND a.stud_ref_no = d.stud_ref_no;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END assessbursary_doc;

   PROCEDURE calculatedependants (
      p_stud_crse_year_id   IN              NUMBER,
      p_dependants_type     IN OUT          dependants_cursor,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      OPEN p_dependants_type FOR
         SELECT CASE
                   WHEN a.relation_id = 48
                      THEN 'Y'
                   ELSE 'N'
                END anyspousedep, NVL (a.income, 0) spousedepincome,
                CASE
                   WHEN get_dependants (p_stud_crse_year_id) = 0
                      THEN 'N'
                   ELSE b.calc_dep_grant
                END calculatedg
           FROM stud_dependant a, stud_crse_year b
          WHERE b.stud_crse_year_id = p_stud_crse_year_id
            AND a.relation_id(+) = 48
            AND b.stud_session_id = a.stud_session_id(+);
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END calculatedependants;

   PROCEDURE calculatesupps (
      p_stud_crse_year_id   IN              NUMBER,
      p_supps_type          IN OUT          supps_cursor,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      OPEN p_supps_type FOR
         SELECT b.lpcg_paid_amount caprequested,
                b.max_lpcg_paid capmax
           FROM stud_crse_year a, stud_session b
          WHERE a.stud_crse_year_id = p_stud_crse_year_id
            AND b.stud_session_id = a.stud_session_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END calculatesupps;

   PROCEDURE disregarddependants (
      p_stud_crse_year_id    IN              NUMBER,
      p_disregarddeps_type   IN OUT          disregarddeps_cursor,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      OPEN p_disregarddeps_type FOR
         SELECT   CASE
                     WHEN ((SELECT   MONTHS_BETWEEN
                                            (TO_DATE (CONCAT ('01-AUG-',
                                                              a.session_code
                                                             ),
                                                      'DD/MM/YYYY'
                                                     ),
                                             c.dob
                                            )
                                   / 12
                              FROM DUAL) < 1
                          )
                        THEN 1
                     ELSE TRUNC
                            ((SELECT   MONTHS_BETWEEN
                                            (TO_DATE (CONCAT ('01-AUG-',
                                                              a.session_code
                                                             ),
                                                      'DD/MM/YYYY'
                                                     ),
                                             c.dob
                                            )
                                     / 12
                                FROM DUAL)
                            )
                  END depage,
                  CASE
                     WHEN get_dependants (p_stud_crse_year_id) =
                                                                0
                        THEN 'N'
                     ELSE a.calc_dep_grant
                  END calculatedg,
                  NVL (c.income, 0) depincome, c.relation_id,
                  CASE 
                    WHEN std_id = oldestChild(p_stud_crse_year_id)
                        THEN 'Y'
                        ELSE 'N'
                    END OldestChild,
                   c.start_date AS studDepStartdate,
                   c.end_date AS studDeptEndDate
                    
             FROM stud_crse_year a, stud_dependant c
            WHERE a.stud_session_id = c.stud_session_id(+)
              AND a.stud_crse_year_id = p_stud_crse_year_id
         ORDER BY depage DESC;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END disregarddependants;

   PROCEDURE studtypenmsb (
      p_stud_crse_year_id   IN              NUMBER,
      p_studtypenmsb_type   IN OUT          studtypenmsb_cursor,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      OPEN p_studtypenmsb_type FOR
         /*SELECT ROUND
                   (get_ageonstartcourse (p_stud_crse_year_id),
                    1
                   ) AS ageonstartcourse,*/
           SELECT TRUNC (get_ageonstartcourse (p_stud_crse_year_id),0) AS ageonstartcourse,
            get_prev_single_rate (p_stud_crse_year_id) AS singlerate
           FROM stud a, stud_crse_year b
          WHERE b.stud_crse_year_id = p_stud_crse_year_id
            AND a.stud_ref_no = b.stud_ref_no;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END studtypenmsb;

/* Formatted on 2010/10/07 13:00 (Formatter Plus v4.8.8) */
PROCEDURE calcawardinput (
   p_stud_crse_year_id     IN              NUMBER,
   p_calcawardinput_type   IN OUT          calcawardinput_cursor,
   p_awards_cursor         IN OUT          all_award_cursor_type,
   ERROR_TEXT              OUT NOCOPY      VARCHAR2
)

IS

 
BEGIN



   OPEN p_calcawardinput_type FOR
      SELECT a.stud_crse_year_id, a.inst_code, a.crse_id, a.crse_year_no,
             a.stud_ref_no, a.session_code,
             CASE
                WHEN a.FIRST_CALC_DATE IS NOT NULL AND a.WITHDRAW_DATE IS NULL AND a.CRSE_CHG IS NULL
                   THEN 'D'    
                WHEN a.FIRST_CALC_DATE IS NOT NULL AND a.WITHDRAW_DATE IS NOT NULL AND a.CRSE_CHG IS NULL
                   THEN 'W'
                WHEN a.FIRST_CALC_DATE IS NOT NULL AND a.WITHDRAW_DATE IS NULL AND a.CRSE_CHG IS NOT NULL
                   THEN 'C'
                ELSE 'I'   
             END assess_reason_code,
            sgas.rules_proc_recalc.getstartdateterm
                                     (p_stud_crse_year_id,
                                      1
                                     ) AS coursestartdate,
             SGAS.NMSB_RULES_PROC_RECALC.getEndDateTerm(p_stud_crse_year_id, SGAS.RULES_PROC_RECALC.number_of_terms (p_stud_crse_year_id)) AS courseEndDate,                    
           --  a.withdraw_date, 
             CASE
                WHEN a.WITHDRAW_DATE IS NULL AND a.CRSE_CHG IS NULL
                    THEN a.WITHDRAW_DATE
                WHEN a.WITHDRAW_DATE IS NULL AND a.CRSE_CHG IS NOT NULL
                    THEN a.CRSE_CHG
                WHEN a.WITHDRAW_DATE IS NOT NULL AND a.CRSE_CHG IS NULL
                    THEN a.WITHDRAW_DATE
                WHEN a.WITHDRAW_DATE <= a.CRSE_CHG
                    THEN a.WITHDRAW_DATE
                ELSE a.CRSE_CHG
             END crseOrWithdrawalDate,
             a.start_date,
             A.INST_CODE, NVL(A.CALC_NMSB,'N'), NVL (a.nmsb_init_expenses, 'N') AS initialexpenses, A.CALC_DEP_GRANT,
             A.CALC_SPA , A.CALC_LPCG as calcCAP, --a.scheme_type, 
             E.SNB_OVERPAYMENT
        FROM stud_crse_year a,
             crse_year c,
             crse_session d,
             stud e
       WHERE a.stud_crse_year_id = p_stud_crse_year_id
         AND c.crse_year_id = a.crse_year_id
         AND a.stud_ref_no = e.stud_ref_no
         AND c.crse_session_id = d.crse_session_id;
         
         
         
         OPEN p_awards_cursor FOR
      SELECT a.award_id AS award_id, a.stud_award_type AS stud_award_type
        FROM award a
       WHERE a.stud_crse_year_id = p_stud_crse_year_id;

   
END calcawardinput;

   
   PROCEDURE awardInstalmentsNMSB ( p_stud_crse_year_id IN NUMBER, p_awardInstalmentNMSB_type    IN OUT awardInstalmentsNMSB_cursor,
                           p_start_dates IN OUT startdates_cursor_type)

IS

BEGIN

    OPEN p_awardInstalmentNMSB_type FOR
    
    SELECT a.award_id, a.stud_crse_year_id, a.stud_award_type, a.amount, s.payment_method, a.assessment_date,
    scy.start_date,          
    scy.session_code, 
    CASE
       WHEN (s.payment_method = 'C')
       THEN 'H'                                                 
       WHEN (s.payment_method = 'B' AND s.nominee = 'N'         )
       THEN 'B'                                              
       ELSE 'N'
       END payment_addr, sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,1) AS term1startDate,
      sgas.NMSB_rules_proc_recalc.numberOfTermsIncludingStartEnd(scy.stud_crse_year_id, a.award_id) AS TermsAddOne,
      NVL(SGAS.NMSB_RULES_PROC_RECALC.overlaptermdates(scy.stud_crse_year_id, a.award_id),'N') as NSAOverlapTerms,
                     CASE
                    WHEN sat.stud_award_type = 'SNCAP' AND nsa.nmsb_spec_arr_type IN('M','C')
                    THEN 'Y'
                    ELSE 'N'
                    END SNCAPTypeMC,
               CASE
                    WHEN sgas.NMSB_RULES_PROC_RECALC.doublePayment(scy.stud_crse_year_id) = 'Y'
                    THEN 2
                    ELSE 1
                    END doublePayment, 

                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 1)
                    ELSE 0
                    END term1SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 2)
                    ELSE 0
                    END term2SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 3)
                    ELSE 0
                    END term3SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 4)
                    ELSE 0
                    END term4SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 5)
                    ELSE 0
                    END term5SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 6)
                    ELSE 0
                    END term6SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 7)
                    ELSE 0
                    END term7SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 8)
                    ELSE 0
                    END term8SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 9)
                    ELSE 0
                    END term9SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 10)
                    ELSE 0
                    END term10SNCAP,
                    CASE
                    WHEN SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id, a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.SNCAPNMSBDAYSINTERM(scy.stud_crse_year_id, 11)
                    ELSE 0
                    END term11SNCAP,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,1)
                        ELSE 0
                    END term1amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,2)
                        ELSE 0
                    END term2amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,3)
                        ELSE 0
                    END term3amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,4)
                        ELSE 0
                    END term4amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,5)
                        ELSE 0
                    END term5amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,6)
                        ELSE 0
                    END term6amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,7)
                        ELSE 0
                    END term7amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,8)
                        ELSE 0
                    END term8amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,9)
                        ELSE 0
                    END term9amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,10)
                        ELSE 0
                    END term9amount,
                    CASE
                        WHEN NON_SNCAP_SPEC_RECORD_EXIST(scy.stud_crse_year_id,a.award_id) = 'Y'
                        THEN NMSB_RULES_PROC_RECALC.NMSBDAYSINTERM(scy.stud_crse_year_id,11)
                        ELSE 0
                    END term10amount,               
                    SGAS.RULES_PROC_RECALC.getstudystartterm(scy.stud_crse_year_id) AS studystartterm,
                    SCY.STUD_REF_NO, scy.latest_crse_ind, ca.campus_id, a.assess_reason_code
from award a, stud s, stud_crse_year scy, crse_year cy, crse_session cs, crse c, inst i, stud_award_type sat, nmsb_spec_arr nsa, campus ca
where a.stud_crse_year_id = scy.stud_crse_year_id
and scy.stud_ref_no = s.stud_ref_no
and scy.crse_year_id = cy.crse_year_id
and cy.crse_session_id = cs.crse_session_id
and sat.stud_award_type = a.stud_award_type
and nsa.stud_ref_no(+) = scy.stud_ref_no
and nsa.session_code(+) = scy.session_code
and sat.loan_non_loan_fee <> 'Loan'  
and sat.type NOT IN('DSA','TRAV','MAN')
and sat.scheme = 'NMSB'
and cs.crse_id = c.crse_id
and scy.scheme_type = 'B'
and c.inst_code = i.inst_code
--and c.fees_campus = ca.campus_id
and c.maint_campus = ca.campus_id(+)
and scy.stud_crse_year_id = p_stud_crse_year_id;


p_start_dates := SGAS.RULES_PROC_RECALC.get_startdates (p_stud_crse_year_id);
   
END awardInstalmentsNMSB;


    PROCEDURE updateAwardInstalments( p_stud_crse_year_id IN NUMBER)

   IS



      CURSOR c_award_id
      IS
            select b.award_instalment_id,
            CASE
                WHEN a.amount = 0 OR b.amount = 0
                    THEN 0
                    ELSE FLOOR((b.amount/a.amount * a.recovered_amount))
                END recovered_amount,
           -- FLOOR((b.amount/a.amount * a.recovered_amount)) AS recovered_amount, 
            CASE
                WHEN a.amount = 0 OR b.amount = 0
                    THEN 0
                    ELSE (b.amount - FLOOR(b.amount/a.amount * a.recovered_amount))
                END net_amount
           -- (b.amount - FLOOR(b.amount/a.amount * a.recovered_amount)) as net_amount
            from award a, award_instalment b
            where a.award_id = b.award_id
            and b.payment_status = 'U'
            and a.stud_crse_year_id = p_stud_crse_year_id
            and a.stud_award_type <> 'SNIE'
            order by award_instalment_id;

      v_award_id         c_award_id%ROWTYPE;
      
      CURSOR c_awards
      IS
            select distinct a.award_id
            FROM award a, award_instalment b
            where a.award_id = b.award_id
            and a.stud_crse_year_id = p_stud_crse_year_id
            and b.payment_status = 'U'
            and a.recovered_amount > 0;
            
     v_awards           c_awards%ROWTYPE;

   BEGIN
   
        OPEN c_award_id;
                                                   
                            LOOP 

                                FETCH c_award_id
                                INTO v_award_id;
                                
                                EXIT WHEN c_award_id%NOTFOUND;
                                
                                UPDATE AWARD_INSTALMENT
                                SET recovered_amount = v_award_id.recovered_amount, net_amount = v_award_id.net_amount
                                WHERE award_instalment_id = v_award_id.award_instalment_id
                                and payment_status = 'U';

                                    
                             END LOOP;
                             
                             CLOSE c_award_id;
                             
                             
   COMMIT;
   
        
   
         OPEN c_awards;
         
            LOOP 
            
                FETCH c_awards
                INTO v_awards;
                
                EXIT WHEN c_awards%NOTFOUND;
                
                RemainderInstalments(v_awards.award_id);
                
            END LOOP;
            
            CLOSE c_awards;
               
            

END updateAwardInstalments;


PROCEDURE RemainderInstalments(p_award_id IN NUMBER)
IS

    l_award_recovered   NUMBER;
    l_award_inst_rec    NUMBER;
    l_remainder         NUMBER;
    l_loop              NUMBER;
    l_remove            NUMBER;
    l_stud_crse_year_id NUMBER;
    
    CURSOR c_award_instalment IS
    
    SELECT award_instalment_id, recovered_amount, net_amount
    FROM award_instalment
    WHERE award_id = p_award_id
    ORDER BY AWARD_INSTALMENT_ID;

    v_award_instalment    c_award_instalment%ROWTYPE;

BEGIN

    SELECT recovered_amount, stud_crse_year_id
    INTO l_award_recovered, l_stud_crse_year_id   
    FROM AWARD
    WHERE AWARD_ID = p_award_id;
    
    SELECT SUM(recovered_amount)
    INTO l_award_inst_rec                   
    FROM AWARD_INSTALMENT
    WHERE AWARD_ID = p_award_id;
    
    IF l_award_recovered < l_award_inst_rec ----  WE NEED TO SUBTRACT VALUES FROM AWARD_INSTALMENT RECORDS
                        THEN l_remainder := l_award_inst_rec - l_award_recovered;
                        
                        OPEN c_award_instalment;
                                     
                                    l_loop := 0;
                                    l_remove := 1;
                            LOOP 
                            
                                 FETCH c_award_instalment
                                                    INTO v_award_instalment;
                                                    
                                                    EXIT WHEN c_award_instalment%NOTFOUND;
                                    
                                    l_loop := l_loop + 1;
                                    
                                    IF l_loop = 1 AND sgas.nmsb_rules_proc_recalc.doublepayment(l_stud_crse_year_id) = 'Y'
                                        THEN 
                                            UPDATE AWARD_INSTALMENT
                                            SET RECOVERED_AMOUNT = v_award_instalment.recovered_amount-2, NET_AMOUNT = v_award_instalment.net_amount+2
                                            WHERE AWARD_INSTALMENT_ID = v_award_instalment.award_instalment_id;
                                            
                                        l_remainder := l_remainder - 2;
                                        
                                    ELSIF l_remove = 1
                                        THEN
                                    
                                          UPDATE AWARD_INSTALMENT
                                            SET RECOVERED_AMOUNT = v_award_instalment.recovered_amount - l_remove, NET_AMOUNT = v_award_instalment.net_amount + l_remove
                                            WHERE AWARD_INSTALMENT_ID = v_award_instalment.award_instalment_id;
                                        
                                        l_remainder := l_remainder - 1;
                                        
                                        IF l_remainder > 0
                                            THEN l_remove := 1;
                                        ELSE l_remove :=0;
                                        END IF;

                                    END IF;
                                    
                                    END LOOP;
                                    
                                    CLOSE c_award_instalment;

    ELSIF l_award_recovered > l_award_inst_rec  ---WE NEED TO ADD VALUES TO AWARD_INSTALMENT RECORDS  
            THEN l_remainder := l_award_recovered - l_award_inst_rec;
    
               
            
                l_loop := 0;
                l_remove := 1;
                
                OPEN c_award_instalment;
                
                        LOOP 
                        
                             FETCH c_award_instalment
                                                INTO v_award_instalment;
                                                
                                                EXIT WHEN c_award_instalment%NOTFOUND;
                                
                                l_loop := l_loop + 1;
                                   
                                IF l_loop = 1 AND sgas.nmsb_rules_proc_recalc.doublepayment(l_stud_crse_year_id) = 'Y'
                                    THEN 
                                        UPDATE AWARD_INSTALMENT
                                        SET RECOVERED_AMOUNT = (v_award_instalment.recovered_amount+2), NET_AMOUNT = (v_award_instalment.net_amount-2)
                                        WHERE AWARD_INSTALMENT_ID = v_award_instalment.award_instalment_id;
                                        
                                    l_remainder := l_remainder - 2;
                                    
                                ELSIF l_remove = 1
                                    THEN
                                
                                      UPDATE AWARD_INSTALMENT
                                        SET RECOVERED_AMOUNT = (v_award_instalment.recovered_amount+1), NET_AMOUNT = (v_award_instalment.net_amount-1)
                                        WHERE AWARD_INSTALMENT_ID = v_award_instalment.award_instalment_id;
                                    
                                    l_remainder := l_remainder - 1;
                                    
                                    IF l_remainder > 0
                                        THEN l_remove := 1;
                                    ELSE l_remove :=0;
                                    END IF;

                                END IF;
                                
                                END LOOP;
                                
                                CLOSE c_award_instalment;
    

    END IF;
    
    COMMIT;

    
END RemainderInstalments;

END nmsb_rules_proc_recalc;
/
