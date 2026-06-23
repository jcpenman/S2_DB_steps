SET SERVEROUTPUT ON; 

DECLARE

    l_stud_ref_no     NUMBER;

    CURSOR c_students IS
    
    SELECT SCY.STUD_REF_NO, SCY.START_DATE_ABROAD, SCY.END_DATE_ABROAD, sgas.rules_proc_recalc.getEndDateTerm(scy.stud_crse_year_id,sgas.rules_proc_recalc.number_of_terms(scy.stud_crse_year_id)) AS CourseEndDate,
           sgas.rules_proc_recalc.getStartDateTerm(scy.stud_crse_year_id,1) AS courseStartDate 
    FROM STUD_CRSE_YEAR scy
    WHERE APPLICATION_STATUS = 'C' ---- WHAT ABOUT WITHDRAWN
    AND scy.start_date_abroad IS NOT NULL
    AND scy.end_date_abroad IS NOT NULL
    AND scy.latest_crse_ind = 'Y';
   
    v_studentsRec c_students%ROWTYPE;
    
 BEGIN
 
    OPEN c_students;
    
    LOOP
        FETCH c_students INTO v_studentsRec;
        EXIT WHEN c_students%NOTFOUND;
        
        IF (v_studentsRec.START_DATE_ABROAD < v_studentsRec.courseStartDate) AND (v_studentsRec.END_DATE_ABROAD > v_studentsRec.CourseEndDate)
        THEN
            DBMS_OUTPUT.PUT_LINE ('Abroad Student '|| v_studentsRec.stud_ref_no ||' commenced on ' ||v_studentsRec.START_DATE_ABROAD || ' which is before the INST/CRSE start date of ' || v_studentsRec.courseStartDate || ' and concluded on ' ||v_studentsRec.END_DATE_ABROAD || ' which is after the INST/CRSE end date of ' || v_studentsRec.CourseEndDate || '.');       
        
        ELSIF v_studentsRec.START_DATE_ABROAD < v_studentsRec.courseStartDate
                THEN
             DBMS_OUTPUT.PUT_LINE ('Abroad Student '|| v_studentsRec.stud_ref_no ||' commenced on ' ||v_studentsRec.START_DATE_ABROAD || ' which is before the INST/CRSE start date of ' || v_studentsRec.courseStartDate || '.' );       
        ELSIF v_studentsRec.END_DATE_ABROAD > v_studentsRec.CourseEndDate
        THEN
            DBMS_OUTPUT.PUT_LINE ('Abroad Student '|| v_studentsRec.stud_ref_no || ' concluded on ' ||v_studentsRec.END_DATE_ABROAD || ' which is after the INST/CRSE end date of ' || v_studentsRec.CourseEndDate || '.'); 

        END IF;
        
          
    END LOOP;
    
    CLOSE c_students;
    
  END;
  

