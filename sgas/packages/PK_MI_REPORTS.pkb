CREATE OR REPLACE PACKAGE BODY SGAS.PK_MI_REPORTS
AS
/******************************************************************************
   NAME:       MI REPORTS
   PURPOSE:    MI REPORTING

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16/02/2011 Paul Hughes    1. Created
   1.1        16/04/2011 Paul Hughes    2. Amended due to requirements
                           
******************************************************************************/

---REPORT 1 RETURNS THE NUMBER OF APPLICATIONS AT PARTICULAR STATUS IN A GIVEN MONTH/SESSION EITHER BY SCHEME OR FOR ALL SCHEMES
FUNCTION getApplicationStatusPerMonth(p_status IN VARCHAR, p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER
IS

    v_result    NUMBER;

BEGIN

        IF p_scheme_type = 'A' ---ALL SCHEME_TYPES
        
            THEN 
            
                        SELECT COUNT(*)
                        INTO v_result
                        FROM PROCESS_INSTANCE_DATA
                        WHERE application_status = p_status
                        AND COMPLETE_DATE IS NOT NULL
                        AND process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
                        AND complete_date BETWEEN p_date1 AND p_date2;
                        
            ELSE 

                        SELECT COUNT(*)
                        INTO v_result
                        FROM PROCESS_INSTANCE_DATA
                        WHERE SCHEME_TYPE = p_scheme_type
                        AND COMPLETE_DATE IS NOT NULL
                        AND application_status = p_status
                        AND process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
                        AND complete_date BETWEEN p_date1 AND p_date2;
                        
        END IF;
        
        
        
RETURN v_result;

END getApplicationStatusPerMonth;

---REPORT 1 - RETURNS THE TOTAL NUMBER OF APPLICATIONS PROCESSED REGARDLESS OF STATUS PER SCHEME TYPE OR ALL SCHEME TYPES
FUNCTION getTotalApplicationsPerMonth(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER
IS

    v_result    NUMBER;
    
BEGIN

        IF p_scheme_type = 'A'
        THEN
        
            select COUNT(*) 
            INTO v_result
            FROM PROCESS_INSTANCE_DATA a
            WHERE COMPLETE_DATE IS NOT NULL
            AND process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
            AND complete_date BETWEEN p_date1 AND p_date2;
            
        ELSE
        
            select COUNT(*) 
            INTO v_result
            FROM PROCESS_INSTANCE_DATA a
            WHERE COMPLETE_DATE IS NOT NULL
            AND process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
            AND a.scheme_type IN(p_scheme_type)
            AND a.complete_date BETWEEN p_date1 AND p_date2;
            
            
        END IF;



RETURN v_result;

END getTotalApplicationsPerMonth;


---REPORT 1 RETURNS THE AVERAGE PROCESSING TIME PER SCHEME TYPE FOR COMPLETED APPLICATIONS
FUNCTION getAverageProcessingTime(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER
IS

    v_result            NUMBER;
    v_days_to_process   NUMBER;
    v_total_apps        NUMBER;
    
BEGIN
    
    IF p_scheme_type = 'A' ---ALL SCHEME_TYPES
    THEN
    
                SELECT SUM(a.days_to_process)
                INTO v_days_to_process
                FROM PROCESS_INSTANCE_DATA a
                WHERE COMPLETE_DATE IS NOT NULL
                AND a.process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
                AND a.complete_date BETWEEN p_date1 AND p_date2;
                
                v_total_apps := getTotalApplicationsPerMonth(p_scheme_type, p_date1, p_date2);
                
                IF v_days_to_process > 0
                    THEN v_result := v_days_to_process/v_total_apps;
                ELSE v_result := 0;
                
                END IF;
                
     ELSE 
     
    
                SELECT SUM(a.days_to_process)
                INTO v_days_to_process
                FROM PROCESS_INSTANCE_DATA a
                WHERE COMPLETE_DATE IS NOT NULL
                AND process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
                AND a.scheme_type = p_scheme_type
                AND a.complete_date BETWEEN p_date1 AND p_date2;
                
                v_total_apps := getTotalApplicationsPerMonth(p_scheme_type, p_date1, p_date2);
                
                IF v_days_to_process > 0
                    THEN v_result := v_days_to_process/v_total_apps;
                ELSE v_result := 0;
                
                END IF;
                
                
      END IF;
                
      RETURN CEIL(v_result);
                
END getAverageProcessingTime;


---REPORT 1 RETURNS APPLICATIONS PROCESSED BY SCHEME TYPE WITHIN A PARTICULAR MONTH/SESSIOn
FUNCTION getAppSchemePerMonth(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR) RETURN NUMBER
IS

    v_result    NUMBER;
    
BEGIN

select COUNT(*) 
INTO v_result
FROM PROCESS_INSTANCE_DATA a
WHERE a.COMPLETE_DATE IS NOT NULL
AND process_bpm IN('NMSBStudentApplicationBPM','StudentApplicationBPM')
AND a.scheme_type = p_scheme_type
AND a.complete_date BETWEEN p_date1 AND p_date2;


RETURN v_result;

END getAppSchemePerMonth; 


----REPORT 2
  FUNCTION gettotalcorrespondencepermonth (
      p_scheme_type   IN   VARCHAR,
      p_date1         IN   VARCHAR,
      p_date2         IN   VARCHAR,
      p_category      IN   VARCHAR
   )
      RETURN NUMBER
   IS
      v_result   NUMBER;
      
   BEGIN
   

   
      IF p_scheme_type = 'A'                              ---ALL SCHEME_TYPES
      THEN
      
                IF p_category = 'A'
                THEN 
                     SELECT COUNT (*)
                       INTO v_result
                       FROM complete_task_data a
                      WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
                        AND TASK_TYPE <> 'A'
                        AND TASK_TYPE LIKE '%CORRESPONDENCE%';
                        
                ELSE
                
                       SELECT COUNT (*)
                       INTO v_result
                       FROM complete_task_data a
                      WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
                        AND TASK_TYPE <> 'A'
                        AND TASK_CATEGORY = p_category
                        AND TASK_TYPE LIKE '%CORRESPONDENCE%';
                        
                END IF;
                
                
      ELSE
      
                IF p_category = 'A'
                    THEN
                        
                        SELECT COUNT (*)
                        INTO v_result
                        FROM complete_task_data a
                        WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
                        AND a.TASK_TYPE <> 'A'
                        AND a.scheme_type = p_scheme_type
                        AND TASK_TYPE LIKE '%CORRESPONDENCE%';
                        
                ELSE
                
                        SELECT COUNT (*)
                        INTO v_result
                        FROM complete_task_data a
                        WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
                        AND TASK_TYPE <> 'A'
                        AND a.SCHEME_TYPE = p_scheme_type
                        AND TASK_CATEGORY = p_category
                        AND TASK_TYPE LIKE '%CORRESPONDENCE%';
                        
                END IF;
            
      END IF;

         RETURN v_result;

   END gettotalcorrespondencepermonth;
   
   -- report 2b
   FUNCTION getTotalCorresPerMonthRep2b (
      p_scheme_type   IN   VARCHAR,
      p_date1         IN   VARCHAR,
      p_date2         IN   VARCHAR
   )
      RETURN NUMBER
   IS
      v_result   NUMBER;
   BEGIN
      IF p_scheme_type = 'A'                              ---ALL SCHEME_TYPES
      THEN
         SELECT COUNT (*)
           INTO v_result
           FROM process_instance_data a
          WHERE a.complete_date IS NOT NULL
            AND a.complete_date BETWEEN p_date1 AND p_date2
            AND a.process_bpm LIKE '%Correspondence%';

         RETURN v_result;
      ELSE
         SELECT COUNT (*)
           INTO v_result
           FROM process_instance_data a
          WHERE a.scheme_type = p_scheme_type
            AND a.complete_date IS NOT NULL
            AND a.complete_date BETWEEN p_date1 AND p_date2
            AND a.process_bpm LIKE '%Correspondence%';

         RETURN v_result;
      END IF;
   END getTotalCorresPerMonthRep2b;

   FUNCTION getaverageproctimecorresRep2b (
      p_scheme_type   IN   VARCHAR,
      p_date1         IN   VARCHAR,
      p_date2         IN   VARCHAR
   )
      RETURN NUMBER
   IS
      v_result            NUMBER;
      v_days_to_process   NUMBER;
      v_total_apps        NUMBER;
      
   BEGIN
   
      IF p_scheme_type = 'A'  
                                  ---ALL SCHEME_TYPES
      THEN

         SELECT SUM (a.days_to_process)
           INTO v_days_to_process
           FROM process_instance_data a
          WHERE complete_date IS NOT NULL
            AND a.process_bpm LIKE '%Correspondence%'
            AND a.complete_date BETWEEN p_date1 AND p_date2;
      ELSE
         SELECT SUM (a.days_to_process)
           INTO v_days_to_process
           FROM process_instance_data a
          WHERE complete_date IS NOT NULL
            AND process_bpm LIKE '%Correspondence%'
            AND a.scheme_type = p_scheme_type
            AND a.complete_date BETWEEN p_date1 AND p_date2;
            
            
            END IF;

         v_total_apps :=
              getTotalCorresPerMonthRep2b (p_scheme_type, p_date1, p_date2);
              
              
   
              
         IF v_days_to_process > 0
         
         THEN
            v_result := v_days_to_process / v_total_apps;
         ELSE
            v_result := 0;
            
           
         END IF;
     
      

      v_result := CEIL(v_result);
               
               IF v_result IS NULL
                    THEN v_result := 0;
               END IF;
             
            RETURN v_result;
      
   END getaverageproctimecorresRep2b;


---REPORT 3
   FUNCTION getaverageprocessingtimecorres (
      p_scheme_type   IN   VARCHAR,
      p_date1         IN   VARCHAR,
      p_date2         IN   VARCHAR,
      p_category      IN   VARCHAR
   )
      RETURN NUMBER
   IS
      v_result            NUMBER;
      v_days_to_process   NUMBER;
      v_total_apps        NUMBER;
      
   BEGIN
   
      IF p_scheme_type = 'A'       
                             ---ALL SCHEME_TYPES
      THEN
      
            IF p_category = 'A'
            THEN
      
         SELECT SUM (a.days_to_process)
           INTO v_days_to_process
           FROM complete_task_data a
          WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
            AND TASK_TYPE <> 'A'
            AND a.TASK_TYPE LIKE '%CORRESPONDENCE%';
            
            ELSE
            
           SELECT SUM (a.days_to_process)
           INTO v_days_to_process
           FROM complete_task_data a
          WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
          AND TASK_TYPE <> 'A'
            AND a.TASK_TYPE LIKE '%CORRESPONDENCE%'
            AND a.TASK_CATEGORY = p_category;
                
            END IF;

      ELSE
      
            IF p_category = 'A'
            THEN
      
         SELECT SUM (a.days_to_process)
           INTO v_days_to_process
           FROM complete_task_data a
          WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
            AND TASK_TYPE <> 'A'
            AND a.TASK_TYPE LIKE '%CORRESPONDENCE%'
            AND a.scheme_type = p_scheme_type;
            
            ELSE
            
           SELECT SUM (a.days_to_process)
           INTO v_days_to_process
           FROM complete_task_data a
          WHERE a.task_complete_date BETWEEN p_date1 AND p_date2
            AND TASK_TYPE <> 'A'
            AND a.TASK_TYPE LIKE '%CORRESPONDENCE%'
            AND a.SCHEME_TYPE = p_scheme_type
            AND a.TASK_CATEGORY = p_category;
                
        END IF;





      END IF;
      
               v_total_apps :=
              gettotalcorrespondencepermonth (p_scheme_type, p_date1, p_date2, p_category);


         IF v_days_to_process > 0
         THEN
            v_result := v_days_to_process / v_total_apps;
         ELSE
            v_result := 0;
         END IF;
         
         v_result := CEIL(v_result);
               
               IF v_result IS NULL
                    THEN v_result := 0;
               END IF;
             
            RETURN v_result;

      
   END getaverageprocessingtimecorres;



FUNCTION getReport3Processed(p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR, p_type IN VARCHAR) RETURN NUMBER

IS

    l_result    NUMBER;
    
    BEGIN
    
        IF p_scheme_type = 'A'
        
            THEN
            
                IF p_start_session = 'A'
                    THEN 
           
            
                SELECT COUNT(*)
                INTO l_result
                FROM PROCESS_INSTANCE_DATA
                WHERE AUTO_CALC <> 'A'
                AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                AND COMPLETE_DATE IS NOT NULL
                AND DAYS_TO_PROCESS > p_min_days
                AND DAYS_TO_PROCESS <= p_max_days;
                
                ELSE 
                
                SELECT COUNT(*)
                INTO l_result
                FROM PROCESS_INSTANCE_DATA
                WHERE AUTO_CALC <> 'A'
                AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                AND COMPLETE_DATE IS NOT NULL
                AND SESSION_CODE = p_start_session
                AND DAYS_TO_PROCESS > p_min_days
                AND DAYS_TO_PROCESS <= p_max_days;
                
                END IF;
                
             ELSE
             
                IF p_start_session = 'A'
                    THEN 
                
                SELECT COUNT(*)
                INTO l_result
                FROM PROCESS_INSTANCE_DATA
                WHERE AUTO_CALC <> 'A'
                AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                AND COMPLETE_DATE IS NOT NULL
                AND SCHEME_TYPE = p_scheme_type
                AND DAYS_TO_PROCESS > p_min_days
                AND DAYS_TO_PROCESS <= p_max_days;
                
                ELSE
                
                SELECT COUNT(*)
                INTO l_result
                FROM PROCESS_INSTANCE_DATA
                WHERE AUTO_CALC <> 'A'
                AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                AND COMPLETE_DATE IS NOT NULL
                AND SESSION_CODE = p_start_session
                AND SCHEME_TYPE = p_scheme_type
                AND DAYS_TO_PROCESS > p_min_days
                AND DAYS_TO_PROCESS <= p_max_days;
                
                END IF;
                
 
            END IF;
            
            RETURN l_result;
            
END getReport3Processed;


FUNCTION getReport3AvgTime(p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR, p_type IN VARCHAR) RETURN NUMBER

IS

    l_result         NUMBER;
    l_total_days     NUMBER;
    l_number        NUMBER;
            
    BEGIN
    
        l_number := getReport3Processed(p_start_session, p_scheme_type, 19, 365, 'StudentApplication');
        
        IF p_scheme_type = 'A'
        
            THEN 
            
                IF p_start_session = 'A'
                
                    THEN 
                    
                                SELECT SUM(DAYS_TO_PROCESS)
                                INTO l_total_days
                                FROM PROCESS_INSTANCE_DATA
                                WHERE AUTO_CALC <> 'A'
                                AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                AND COMPLETE_DATE IS NOT NULL
                                AND DAYS_TO_PROCESS > p_min_days
                                AND DAYS_TO_PROCESS <= p_max_days;
                                
                     ELSE
                     
                             SELECT SUM(DAYS_TO_PROCESS)
                            INTO l_total_days
                            FROM PROCESS_INSTANCE_DATA
                            WHERE AUTO_CALC <> 'A'
                            AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                            AND COMPLETE_DATE IS NOT NULL
                            AND SESSION_CODE = p_start_session
                            AND DAYS_TO_PROCESS > p_min_days
                            AND DAYS_TO_PROCESS <= p_max_days;
                            
                     END IF;
            ELSE
            
                        IF p_start_session = 'A'
                            THEN
                            
                                        SELECT SUM(DAYS_TO_PROCESS)
                                        INTO l_total_days
                                        FROM PROCESS_INSTANCE_DATA
                                        WHERE AUTO_CALC <> 'A'
                                        AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                        AND COMPLETE_DATE IS NOT NULL
                                        AND SCHEME_TYPE = p_scheme_type
                                        AND DAYS_TO_PROCESS > p_min_days
                                        AND DAYS_TO_PROCESS <= p_max_days;
                            
                         ELSE
                         
                                        SELECT SUM(DAYS_TO_PROCESS)
                                        INTO l_total_days
                                        FROM PROCESS_INSTANCE_DATA
                                        WHERE AUTO_CALC <> 'A'
                                        AND PROCESS_BPM LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                        AND COMPLETE_DATE IS NOT NULL
                                        AND SESSION_CODE = p_start_session
                                        AND SCHEME_TYPE = p_scheme_type
                                        AND DAYS_TO_PROCESS > p_min_days
                                        AND DAYS_TO_PROCESS <= p_max_days;
                                        
                        END IF;
                        
               END IF;
               
               
               IF l_number > 0
               
                THEN l_result := l_total_days / l_number;
                ELSE l_result := 0;
                
               END IF;
               
               l_result := CEIL(l_result);
               
               IF l_result IS NULL
                    THEN l_result := 0;
               END IF;
             
            RETURN l_result;
            
  END getReport3AvgTime;          
                        
      
   
FUNCTION ProcessedReport5(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_teams IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR,
                                        p_type IN VARCHAR, p_category IN VARCHAR) RETURN NUMBER
   
   IS
   
   l_result     NUMBER;
   
   BEGIN
   
                           IF p_scheme_type = 'A'
                           
                                THEN
                                
                                    IF p_teams = 'A'
                                        THEN
                                        
                                               IF p_category = 'A'
                                                
                                               THEN 
                                        
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                               ELSE
                                               
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND TASK_CATEGORY = p_category
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                               END IF;
                                               
                                               
                                    ELSE  ---SELECTED TEAMS ONLY
                                    
                                            IF p_category = 'A'
                                                THEN
                                    
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND TEAM = p_teams
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                               
                                            ELSE
                                            
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND TEAM = p_teams
                                               AND TASK_CATEGORY = p_category
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                            END IF;
                                               
                                    END IF;
                                           
                           ELSE ---SELECTED SCHEME TYPES
                           
                                    IF p_teams = 'A'
                                        THEN
                                        
                                                IF p_category = 'A'
                                                    THEN 
                                    
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND SCHEME_TYPE = p_scheme_type
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                               ELSE
                                               
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND SCHEME_TYPE = p_scheme_type
                                               AND TASK_CATEGORY = p_category
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                               END IF;
                                               
                                         ELSE ---SELECTED TEAMS/SCHEMES
                                         
                                            IF p_category = 'A'
                                            
                                                THEN 
                                                            
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND SCHEME_TYPE = p_scheme_type
                                               AND TEAM = p_teams
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                         
                                         
                                            ELSE 
                                            
                                               SELECT COUNT(*)
                                               INTO l_result
                                               FROM COMPLETE_TASK_DATA
                                               WHERE TASK_TYPE <> 'A'
                                               AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                               AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                               AND SCHEME_TYPE = p_scheme_type
                                               AND TASK_CATEGORY = p_category
                                               AND TEAM = p_teams
                                               AND DAYS_TO_PROCESS > p_min_days
                                               AND DAYS_TO_PROCESS < p_max_days;
                                               
                                         END IF;
                                         
                                         END IF;
                                         
                           END IF;
   
   RETURN l_result;            
         

   END ProcessedReport5;
   
   
   FUNCTION getAverageTaskRep5(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_teams IN VARCHAR, p_type IN VARCHAR, p_category IN VARCHAR) 
                                    RETURN NUMBER
                                    
   IS
   
    l_result    NUMBER;
    l_days      NUMBER;
    l_total     NUMBER;
    
    BEGIN
    
        IF p_scheme_type = 'A'
        
            THEN
            
                IF p_teams = 'A'
                
                    THEN 
                    
                        IF p_category = 'A'
                        
                            THEN 
                    
                        SELECT SUM(DAYS_TO_PROCESS)
                        INTO l_days 
                        FROM COMPLETE_TASK_DATA
                        WHERE TASK_TYPE <> 'A'
                        AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                        AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2;
                        
                        ELSE
                            
                        SELECT SUM(DAYS_TO_PROCESS)
                        INTO l_days 
                        FROM COMPLETE_TASK_DATA
                        WHERE TASK_TYPE <> 'A'
                        AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                        AND TASK_CATEGORY = p_category
                        AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2;
                        
                        
                        END IF;
                        
                        
                ELSE ---SELECTED TEAM ALL SCHEMES
                
                        IF p_category = 'A'
                        
                            THEN 
                
                                    SELECT SUM(DAYS_TO_PROCESS)
                                    INTO l_days 
                                    FROM COMPLETE_TASK_DATA
                                    WHERE TASK_TYPE <> 'A'
                                    AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                    AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                    AND TEAM = p_teams;
                                    
                                    
                             ELSE 
                             
                                    SELECT SUM(DAYS_TO_PROCESS)
                                    INTO l_days 
                                    FROM COMPLETE_TASK_DATA
                                    WHERE TASK_TYPE <> 'A'
                                    AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                    AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                    AND TASK_CATEGORY = p_category
                                    AND TEAM = p_teams;
                                    
                          END IF;
                                    
                END IF;
                
         ELSE  ---ALL SCHEMES
         
                IF p_teams = 'A'
                
                    THEN 
                    
                            IF p_category = 'A'
                                THEN
                    
                                    SELECT SUM(DAYS_TO_PROCESS)
                                INTO l_days 
                                FROM COMPLETE_TASK_DATA
                                WHERE TASK_TYPE <> 'A'
                                AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                AND SCHEME_TYPE = p_scheme_type;
                                
                                
                             ELSE 
                             
                                SELECT SUM(DAYS_TO_PROCESS)
                                INTO l_days 
                                FROM COMPLETE_TASK_DATA
                                WHERE TASK_TYPE <> 'A'
                                AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                                AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                                AND TASK_CATEGORY = p_category
                                AND SCHEME_TYPE = p_scheme_type;
                                
                             END IF;
                                
                 ELSE ---SELECTED SCHMES/TEAMS
                 
                            IF p_category = 'A'
                            
                                THEN 
                 
                            SELECT SUM(DAYS_TO_PROCESS)
                            INTO l_days 
                            FROM COMPLETE_TASK_DATA
                            WHERE TASK_TYPE <> 'A'
                            AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                            AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                            AND SCHEME_TYPE = p_scheme_type
                            AND TEAM = p_teams;
                            
                            ELSE
                            
                                                        SELECT SUM(DAYS_TO_PROCESS)
                            INTO l_days 
                            FROM COMPLETE_TASK_DATA
                            WHERE TASK_TYPE <> 'A'
                            AND TASK_TYPE LIKE(CONCAT('%',CONCAT(p_type,'%')))
                            AND TASK_CREATION_DATE BETWEEN p_date1 AND p_date2
                            AND SCHEME_TYPE = p_scheme_type
                            AND TASK_CATEGORY = p_category
                            AND TEAM = p_teams;
                            
                            END IF;
                            
                    END IF;
                    
          END IF;
          
          l_total := ProcessedReport5(p_scheme_type , p_date1 , p_date2 , p_teams , 0,365, p_type, p_category);
          
          IF l_days > 0 
          
                THEN 
                      l_result := l_days / l_total;
                      
                ELSE l_result := 0;
                
          END IF;
          
          
          RETURN CEIL(l_result);
          
   END getAverageTaskRep5;
          
          
    FUNCTION getPercentOfTotCompledRep5(p_scheme_type IN VARCHAR, p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_teams IN VARCHAR, p_min_days IN VARCHAR, p_max_days IN VARCHAR, p_type IN VARCHAR, p_category IN VARCHAR ) RETURN NUMBER
       
    IS
    
    l_total     NUMBER;
    l_perDay    NUMBER;
    l_result    NUMBER;
    
    
    
    BEGIN
    
        l_total := ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 0, 365, p_type, p_category);
        
        l_perDay := ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, p_min_days, p_max_days, p_type, p_category);
        
            IF l_total > 0 
            
            THEN 
            
                   l_result := (l_perDay/l_total) * 100;
                   
            ELSE l_result := 0;
            
            END IF;
            
        RETURN CEIL(l_result);
        
    END getPercentOfTotCompledRep5;
    
   
        

----MAIN PROCEDURE TO RETURN DATA FOR REPORT 1
   PROCEDURE report1data (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  p_report1Applic_type IN OUT report1typeApplic_cursor, 
                                                                                 p_report1Scheme_type IN OUT report1typeScheme_cursor,               
                                                                                 ERROR_TEXT OUT NOCOPY VARCHAR2)
 
   IS
  
   BEGIN
   
      OPEN p_report1Applic_type FOR
   
      SELECT 'Return' AS STATUS,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getApplicationStatusPerMonth('T',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,  
                                                                                                                                     1 AS ord
       FROM DUAL
       UNION
       SELECT 'Rejected',
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getApplicationStatusPerMonth('R',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      2 AS ord
       FROM DUAL 
              UNION
       SELECT 'Calculated',
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getApplicationStatusPerMonth('C',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      3 AS ord
       FROM DUAL
                     UNION
       SELECT 'Withdrawn',
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getApplicationStatusPerMonth('W',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      4 AS ord
       FROM DUAL
                            UNION
       SELECT 'Non-Attendance',
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getApplicationStatusPerMonth('A',p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      5 AS ord
       FROM DUAL  
        UNION
              SELECT 'Total Applications Processed',
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getTotalApplicationsPerMonth(p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      6 AS ord
       FROM DUAL
               UNION
              SELECT 'Average Processing Time',
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAverageProcessingTime(p_scheme_type ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      7 AS ord
       FROM DUAL
                ORDER BY ord;
                
       OPEN p_report1Scheme_type FOR
       
       SELECT 'UG Applications Processed',
            getAppSchemePerMonth('U' ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAppSchemePerMonth('U' ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAppSchemePerMonth('U' ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAppSchemePerMonth('U' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAppSchemePerMonth('U' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAppSchemePerMonth('U' ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAppSchemePerMonth('U' ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAppSchemePerMonth('U' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAppSchemePerMonth('U' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAppSchemePerMonth('U' ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAppSchemePerMonth('U' ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAppSchemePerMonth('U' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAppSchemePerMonth('U' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAppSchemePerMonth('U' ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAppSchemePerMonth('U' ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAppSchemePerMonth('U' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAppSchemePerMonth('U' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAppSchemePerMonth('U' ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAppSchemePerMonth('U' ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAppSchemePerMonth('U' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAppSchemePerMonth('U' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      1 AS ord
       FROM DUAL
       UNION
       SELECT 'UG Applications Avg Processing Time',
            getAverageProcessingTime('U' ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAverageProcessingTime('U' ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAverageProcessingTime('U' ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAverageProcessingTime('U' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAverageProcessingTime('U' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAverageProcessingTime('U' ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAverageProcessingTime('U' ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAverageProcessingTime('U' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAverageProcessingTime('U' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAverageProcessingTime('U' ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAverageProcessingTime('U' ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAverageProcessingTime('U' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAverageProcessingTime('U' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAverageProcessingTime('U' ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAverageProcessingTime('U' ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAverageProcessingTime('U' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAverageProcessingTime('U' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAverageProcessingTime('U' ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAverageProcessingTime('U' ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAverageProcessingTime('U' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAverageProcessingTime('U' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                                      2 AS ord
            FROM DUAL
              UNION
       SELECT 'PG Applications Processed',
            getAppSchemePerMonth('P' ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAppSchemePerMonth('P' ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAppSchemePerMonth('P' ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAppSchemePerMonth('P' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAppSchemePerMonth('P' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAppSchemePerMonth('P' ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAppSchemePerMonth('P' ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAppSchemePerMonth('P' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAppSchemePerMonth('P' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAppSchemePerMonth('P' ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAppSchemePerMonth('P' ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAppSchemePerMonth('P' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAppSchemePerMonth('P' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAppSchemePerMonth('P' ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAppSchemePerMonth('P' ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAppSchemePerMonth('P' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAppSchemePerMonth('P' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAppSchemePerMonth('P' ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAppSchemePerMonth('P' ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAppSchemePerMonth('P' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAppSchemePerMonth('P' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                     3 AS ord
          
       FROM DUAL
       UNION
                   SELECT 'PG Applications Avg Processing Time',
            getAverageProcessingTime('P' ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAverageProcessingTime('P' ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAverageProcessingTime('P' ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAverageProcessingTime('P' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAverageProcessingTime('P' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAverageProcessingTime('P' ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAverageProcessingTime('P' ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAverageProcessingTime('P' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAverageProcessingTime('P' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAverageProcessingTime('P' ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAverageProcessingTime('P' ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAverageProcessingTime('P' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAverageProcessingTime('P' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAverageProcessingTime('P' ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAverageProcessingTime('P' ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAverageProcessingTime('P' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAverageProcessingTime('P' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAverageProcessingTime('P' ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAverageProcessingTime('P' ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAverageProcessingTime('P' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAverageProcessingTime('P' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                      4 AS ord
            FROM DUAL
                     UNION
       SELECT 'NMSB Applications Processed',
            getAppSchemePerMonth('B' ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAppSchemePerMonth('B' ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAppSchemePerMonth('B' ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAppSchemePerMonth('B' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAppSchemePerMonth('B' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAppSchemePerMonth('B' ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAppSchemePerMonth('B' ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAppSchemePerMonth('B' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAppSchemePerMonth('B' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAppSchemePerMonth('B' ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAppSchemePerMonth('B' ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAppSchemePerMonth('B' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAppSchemePerMonth('B' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAppSchemePerMonth('B' ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAppSchemePerMonth('B' ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAppSchemePerMonth('B' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAppSchemePerMonth('B' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAppSchemePerMonth('B' ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAppSchemePerMonth('B' ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAppSchemePerMonth('B' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAppSchemePerMonth('B' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                  5 AS ord
       FROM DUAL
             UNION
       SELECT 'NMSB Applications Avg Processing Time',
            getAverageProcessingTime('B' ,CONCAT('01-APR-',p_start_session), CONCAT('01-MAY-',p_start_session)) AS APR,
            getAverageProcessingTime('B' ,CONCAT('01-MAY-',p_start_session), CONCAT('01-JUN-',p_start_session)) AS MAY,
            getAverageProcessingTime('B' ,CONCAT('01-JUN-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS JUN,
            getAverageProcessingTime('B' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session)) AS QTR1,
            getAverageProcessingTime('B' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-AUG-',p_start_session)) AS JUL,
            getAverageProcessingTime('B' ,CONCAT('01-AUG-',p_start_session), CONCAT('01-SEP-',p_start_session)) AS AUG,
            getAverageProcessingTime('B' ,CONCAT('01-SEP-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS SEP,
            getAverageProcessingTime('B' ,CONCAT('01-JUL-',p_start_session), CONCAT('01-OCT-',p_start_session)) AS QTR2,
            getAverageProcessingTime('B' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-NOV-',p_start_session)) AS OCT,
            getAverageProcessingTime('B' ,CONCAT('01-NOV-',p_start_session), CONCAT('01-DEC-',p_start_session)) AS NOV,
            getAverageProcessingTime('B' ,CONCAT('01-DEC-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS DEC,
            getAverageProcessingTime('B' ,CONCAT('01-OCT-',p_start_session), CONCAT('01-JAN-',p_start_session+1)) AS QTR3,
            getAverageProcessingTime('B' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-FEB-',p_start_session+1)) AS JAN2,
            getAverageProcessingTime('B' ,CONCAT('01-FEB-',p_start_session+1), CONCAT('01-MAR-',p_start_session+1)) AS FEB2,
            getAverageProcessingTime('B' ,CONCAT('01-MAR-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS MAR2,
            getAverageProcessingTime('B' ,CONCAT('01-JAN-',p_start_session+1), CONCAT('01-APR-',p_start_session+1)) AS QTR4,
            getAverageProcessingTime('B' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-MAY-',p_start_session+1)) AS APR2,
            getAverageProcessingTime('B' ,CONCAT('01-MAY-',p_start_session+1), CONCAT('01-JUN-',p_start_session+1)) AS MAY2,
            getAverageProcessingTime('B' ,CONCAT('01-JUN-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS JUN2,
            getAverageProcessingTime('B' ,CONCAT('01-APR-',p_start_session+1), CONCAT('01-JUL-',p_start_session+1)) AS QTR5,
            getAverageProcessingTime('B' ,CONCAT('01-APR-',p_start_session), CONCAT('01-JUL-',p_start_session+1)) AS TOTAL,
                                                                                                                  6 AS ord
       FROM DUAL
    
        
         ORDER BY ord;
         
            
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END report1data;
   

---REPORT 2 ------------------------------------------------------------------------------------------------------------------------------
PROCEDURE report2data (
      p_start_session IN VARCHAR, p_scheme_type IN VARCHAR, p_category IN VARCHAR, 
      p_report2Corres_type IN OUT report2typeCorres_cursor, 
      p_report2Scheme_type IN OUT report2typeScheme_cursor, 
      ERROR_TEXT OUT NOCOPY VARCHAR2
   )
   IS
   BEGIN
      OPEN p_report2Corres_type FOR
         SELECT 'Total',
                gettotalcorrespondencepermonth ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                gettotalcorrespondencepermonth ('A', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                gettotalcorrespondencepermonth ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                gettotalcorrespondencepermonth ('A', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session + 1),p_category) AS dec,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                gettotalcorrespondencepermonth ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                gettotalcorrespondencepermonth ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  1 AS ord
                  
             FROM DUAL
             UNION
             SELECT 'Average Processing Time', 
                getaverageprocessingtimecorres ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                getaverageprocessingtimecorres ('A', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                getaverageprocessingtimecorres ('A', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                getaverageprocessingtimecorres ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                getaverageprocessingtimecorres ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                getaverageprocessingtimecorres ('A', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                getaverageprocessingtimecorres ('A', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                getaverageprocessingtimecorres ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                getaverageprocessingtimecorres ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                getaverageprocessingtimecorres ('A', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                getaverageprocessingtimecorres ('A', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                getaverageprocessingtimecorres ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                getaverageprocessingtimecorres ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                getaverageprocessingtimecorres ('A', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                getaverageprocessingtimecorres ('A', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                getaverageprocessingtimecorres ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                getaverageprocessingtimecorres ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                getaverageprocessingtimecorres ('A', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                getaverageprocessingtimecorres ('A', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                getaverageprocessingtimecorres ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                getaverageprocessingtimecorres ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  2 AS ord
             FROM DUAL
             Order by ord;
             
             OPEN p_report2Scheme_type FOR
             SELECT 'UG Correspondence Processed',
                gettotalcorrespondencepermonth ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                gettotalcorrespondencepermonth ('U', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                gettotalcorrespondencepermonth ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                gettotalcorrespondencepermonth ('U', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                gettotalcorrespondencepermonth ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                gettotalcorrespondencepermonth ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  1 AS ord
                  FROM DUAL
             UNION
             SELECT 'UG Average Processing Time', 
                getaverageprocessingtimecorres ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                getaverageprocessingtimecorres ('U', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                getaverageprocessingtimecorres ('U', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                getaverageprocessingtimecorres ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                getaverageprocessingtimecorres ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                getaverageprocessingtimecorres ('U', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                getaverageprocessingtimecorres ('U', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                getaverageprocessingtimecorres ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                getaverageprocessingtimecorres ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                getaverageprocessingtimecorres ('U', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                getaverageprocessingtimecorres ('U', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                getaverageprocessingtimecorres ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                getaverageprocessingtimecorres ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                getaverageprocessingtimecorres ('U', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                getaverageprocessingtimecorres ('U', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                getaverageprocessingtimecorres ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                getaverageprocessingtimecorres ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                getaverageprocessingtimecorres ('U', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                getaverageprocessingtimecorres ('U', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                getaverageprocessingtimecorres ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                getaverageprocessingtimecorres ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  2 AS ord
                  FROM DUAL
                  UNION
                SELECT 'PG Correspondence Processed',
                gettotalcorrespondencepermonth ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                gettotalcorrespondencepermonth ('P', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                gettotalcorrespondencepermonth ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                gettotalcorrespondencepermonth ('P', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                gettotalcorrespondencepermonth ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                gettotalcorrespondencepermonth ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  3 AS ord
                  FROM DUAL
                UNION SELECT 'PG Average Processing Time',
                getaverageprocessingtimecorres ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                getaverageprocessingtimecorres ('P', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                getaverageprocessingtimecorres ('P', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                getaverageprocessingtimecorres ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                getaverageprocessingtimecorres ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                getaverageprocessingtimecorres ('P', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                getaverageprocessingtimecorres ('P', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                getaverageprocessingtimecorres ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                getaverageprocessingtimecorres ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                getaverageprocessingtimecorres ('P', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                getaverageprocessingtimecorres ('P', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                getaverageprocessingtimecorres ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                getaverageprocessingtimecorres ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                getaverageprocessingtimecorres ('P', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                getaverageprocessingtimecorres ('P', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                getaverageprocessingtimecorres ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                getaverageprocessingtimecorres ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                getaverageprocessingtimecorres ('P', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                getaverageprocessingtimecorres ('P', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                getaverageprocessingtimecorres ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                getaverageprocessingtimecorres ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  4 AS ord
                  FROM DUAL
                UNION SELECT 'NMSB Correspondence Processed',
                gettotalcorrespondencepermonth ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                gettotalcorrespondencepermonth ('B', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                gettotalcorrespondencepermonth ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                gettotalcorrespondencepermonth ('B', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                gettotalcorrespondencepermonth ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                gettotalcorrespondencepermonth ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  5 AS ord
                  FROM DUAL
                UNION SELECT 'NMSB Average Processing Time',
                getaverageprocessingtimecorres ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session),p_category) AS apr,
                getaverageprocessingtimecorres ('B', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session),p_category) AS may,
                getaverageprocessingtimecorres ('B', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS jun,
                getaverageprocessingtimecorres ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session),p_category) AS qtr1,
                getaverageprocessingtimecorres ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session),p_category) AS jul,         
                getaverageprocessingtimecorres ('B', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session),p_category) AS aug,
                getaverageprocessingtimecorres ('B', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS sep,
                getaverageprocessingtimecorres ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session),p_category) AS qtr2,         
                getaverageprocessingtimecorres ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session),p_category) AS oct,         
                getaverageprocessingtimecorres ('B', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session),p_category) AS nov,
                getaverageprocessingtimecorres ('B', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS dec,
                getaverageprocessingtimecorres ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1),p_category) AS qtr3,
                getaverageprocessingtimecorres ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1),p_category) AS jan2,
                getaverageprocessingtimecorres ('B', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1),p_category) AS feb2,
                getaverageprocessingtimecorres ('B', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS mar2,
                getaverageprocessingtimecorres ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1),p_category) AS qtr4,                                     
                getaverageprocessingtimecorres ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1),p_category) AS apr2,
                getaverageprocessingtimecorres ('B', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1),p_category) AS may2,
                getaverageprocessingtimecorres ('B', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS jun2,
                getaverageprocessingtimecorres ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1),p_category) AS qtr5,
                getaverageprocessingtimecorres ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1),p_category) AS total,                                    
                  6 AS ord
                  FROM DUAL
         ORDER BY ord;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END report2data;
   
   PROCEDURE report2bdata (
      p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  
      p_report2bCorres_type IN OUT report2btypeCorres_cursor, 
      p_report2bScheme_type IN OUT report2btypeScheme_cursor, 
      ERROR_TEXT OUT NOCOPY VARCHAR2
   )
   IS
   BEGIN
      OPEN p_report2bCorres_type FOR
         SELECT 'Correspondence Tasks', 
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session + 1)) AS dec,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getTotalCorresPerMonthRep2b ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  1 AS ord
                  
             FROM DUAL
             UNION
             SELECT 'Average Processing Time', 
                getaverageproctimecorresRep2b ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getaverageproctimecorresRep2b ('A', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getaverageproctimecorresRep2b ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getaverageproctimecorresRep2b ('A', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getaverageproctimecorresRep2b ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getaverageproctimecorresRep2b ('A', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  2 AS ord
             FROM DUAL
             Order by ord;
             
             OPEN p_report2bScheme_type FOR
             SELECT 'UG Correspondence Processed',
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getTotalCorresPerMonthRep2b ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  1 AS ord
                  FROM DUAL
             UNION
             SELECT 'UG Average Processing Time', 
                getaverageproctimecorresRep2b ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getaverageproctimecorresRep2b ('U', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getaverageproctimecorresRep2b ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getaverageproctimecorresRep2b ('U', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getaverageproctimecorresRep2b ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getaverageproctimecorresRep2b ('U', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  2 AS ord
                  FROM DUAL
                  UNION
                SELECT 'PG Correspondence Processed',
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getTotalCorresPerMonthRep2b ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  3 AS ord
                  FROM DUAL
                UNION SELECT 'PG Average Processing Time',
                getaverageproctimecorresRep2b ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getaverageproctimecorresRep2b ('P', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getaverageproctimecorresRep2b ('p', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getaverageproctimecorresRep2b ('p', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getaverageproctimecorresRep2b ('p', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getaverageproctimecorresRep2b ('p', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getaverageproctimecorresRep2b ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getaverageproctimecorresRep2b ('P', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  4 AS ord
                  FROM DUAL
                UNION SELECT 'NMSB Correspondence Processed',
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getTotalCorresPerMonthRep2b ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  5 AS ord
                  FROM DUAL
                UNION SELECT 'NMSB Average Processing Time',
                getaverageproctimecorresRep2b ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-MAY-',p_start_session)) AS apr,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-MAY-',p_start_session),CONCAT ('01-JUN-',p_start_session)) AS may,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-JUN-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS jun,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session)) AS qtr1,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-AUG-',p_start_session)) AS jul,         
                getaverageproctimecorresRep2b ('B', CONCAT ('01-AUG-',p_start_session),CONCAT ('01-SEP-',p_start_session)) AS aug,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-SEP-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS sep,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-JUL-',p_start_session),CONCAT ('01-OCT-',p_start_session)) AS qtr2,         
                getaverageproctimecorresRep2b ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-NOV-',p_start_session)) AS oct,         
                getaverageproctimecorresRep2b ('B', CONCAT ('01-NOV-',p_start_session),CONCAT ('01-DEC-',p_start_session)) AS nov,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-DEC-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS dec,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-OCT-',p_start_session),CONCAT ('01-JAN-',p_start_session+1)) AS qtr3,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-FEB-',p_start_session+1)) AS jan2,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-FEB-',p_start_session+1),CONCAT ('01-MAR-',p_start_session+1)) AS feb2,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-MAR-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS mar2,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-JAN-',p_start_session+1),CONCAT ('01-APR-',p_start_session+1)) AS qtr4,                                     
                getaverageproctimecorresRep2b ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-MAY-',p_start_session+1)) AS apr2,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-MAY-',p_start_session+1),CONCAT ('01-JUN-',p_start_session+1)) AS may2,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-JUN-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS jun2,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-APR-',p_start_session+1),CONCAT ('01-JUL-',p_start_session+1)) AS qtr5,
                getaverageproctimecorresRep2b ('B', CONCAT ('01-APR-',p_start_session),CONCAT ('01-JUL-',p_start_session+1)) AS total,                                    
                  6 AS ord
                  FROM DUAL
         ORDER BY ord;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END report2bdata;
   
   
  PROCEDURE report3adata (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  p_report3aApplic_type IN OUT report3atypeApplic_cursor, 
                                                                                p_report3aScheme_type IN OUT report3atypeScheme_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2)
                                                                                
  IS
  
  BEGIN
  
    OPEN 
   
        p_report3aApplic_type FOR
        
                                                                    ---> MIN DAYS <= MAX_DAYS
                                                  
        
        SELECT 'Applications Processed' AS status, 
                getReport3Processed(p_start_session, p_scheme_type, 11, 15, 'StudentApplication')  AS days1set,
                getReport3Processed(p_start_session, p_scheme_type, 15, 20, 'StudentApplication')  AS days2set,
                getReport3Processed(p_start_session, p_scheme_type, 20, 25, 'StudentApplication')  AS days3set,
                getReport3Processed(p_start_session, p_scheme_type, 25, 30, 'StudentApplication')  AS days4set,
                getReport3Processed(p_start_session, p_scheme_type, 30, 35, 'StudentApplication')  AS days5set,
                getReport3Processed(p_start_session, p_scheme_type, 35, 40, 'StudentApplication')  AS days6set,
                getReport3Processed(p_start_session, p_scheme_type, 40, 45, 'StudentApplication')  AS days7set,
                getReport3Processed(p_start_session, p_scheme_type, 45, 50, 'StudentApplication')  AS days8set,
                getReport3Processed(p_start_session, p_scheme_type, 50, 55, 'StudentApplication')  AS days9set,
                getReport3Processed(p_start_session, p_scheme_type, 55, 60, 'StudentApplication')  AS days10set,
                getReport3Processed(p_start_session, p_scheme_type, 60, 65, 'StudentApplication')  AS days11set,
                getReport3Processed(p_start_session, p_scheme_type, 65, 100, 'StudentApplication')  AS days12set,
                getReport3Processed(p_start_session, p_scheme_type, 100, 365, 'StudentApplication')  AS days13set,
                getReport3AvgTime(p_start_session, p_scheme_type, 19, 365, 'StudentApplication' ) AS AvgTime,
                getReport3Processed(p_start_session, p_scheme_type, 11, 365, 'StudentApplication')  AS total, 1 AS ORD 
                FROM DUAL
                ORDER BY ORD;
                
                
    OPEN
              
        p_report3aScheme_type FOR
        
        SELECT 'UG Applications Processed' AS status,
                getReport3Processed(p_start_session, 'U', 11, 15, 'StudentApplication')  AS days1set,
                getReport3Processed(p_start_session, 'U', 15, 20, 'StudentApplication')  AS days2set,
                getReport3Processed(p_start_session, 'U', 20, 25, 'StudentApplication')  AS days3set,
                getReport3Processed(p_start_session, 'U', 25, 30, 'StudentApplication')  AS days4set,
                getReport3Processed(p_start_session, 'U', 30, 35, 'StudentApplication')  AS days5set,
                getReport3Processed(p_start_session, 'U', 35, 40, 'StudentApplication')  AS days6set,
                getReport3Processed(p_start_session, 'U', 40, 45, 'StudentApplication')  AS days7set,
                getReport3Processed(p_start_session, 'U', 45, 50, 'StudentApplication')  AS days8set,
                getReport3Processed(p_start_session, 'U', 50, 55, 'StudentApplication')  AS days9set,
                getReport3Processed(p_start_session, 'U', 55, 60, 'StudentApplication')  AS days10set,
                getReport3Processed(p_start_session, 'U', 60, 65, 'StudentApplication')  AS days11set,
                getReport3Processed(p_start_session, 'U', 65, 100, 'StudentApplication')  AS days12set,
                getReport3Processed(p_start_session, 'U', 100, 365, 'StudentApplication')  AS days13set,
                getReport3AvgTime(p_start_session, 'U', 19, 365, 'StudentApplication' ) AS AvgTime,
                getReport3Processed(p_start_session, 'U', 11, 365, 'StudentApplication')  AS total, 1 AS ord
                FROM DUAL
         UNION
                 SELECT 'PG Applications Processed' AS status,
                getReport3Processed(p_start_session, 'P', 11, 15, 'StudentApplication')  AS days1set,
                getReport3Processed(p_start_session, 'P', 15, 20, 'StudentApplication')  AS days2set,
                getReport3Processed(p_start_session, 'P', 20, 25, 'StudentApplication')  AS days3set,
                getReport3Processed(p_start_session, 'P', 25, 30, 'StudentApplication')  AS days4set,
                getReport3Processed(p_start_session, 'P', 30, 35, 'StudentApplication')  AS days5set,
                getReport3Processed(p_start_session, 'P', 35, 40, 'StudentApplication')  AS days6set,
                getReport3Processed(p_start_session, 'P', 40, 45, 'StudentApplication')  AS days7set,
                getReport3Processed(p_start_session, 'P', 45, 50, 'StudentApplication')  AS days8set,
                getReport3Processed(p_start_session, 'P', 50, 55, 'StudentApplication')  AS days9set,
                getReport3Processed(p_start_session, 'P', 55, 60, 'StudentApplication')  AS days10set,
                getReport3Processed(p_start_session, 'P', 60, 65, 'StudentApplication')  AS days11set,
                getReport3Processed(p_start_session, 'P', 65, 100, 'StudentApplication')  AS days12set,
                getReport3Processed(p_start_session, 'P', 100, 365, 'StudentApplication')  AS days13set,
                getReport3AvgTime(p_start_session, 'P', 19, 365, 'StudentApplication' ) AS AvgTime,
                getReport3Processed(p_start_session, 'P', 11, 365, 'StudentApplication')  AS total, 2 AS ord
                FROM DUAL
         UNION
                 SELECT 'NMSB Applications Processed' AS status,
                getReport3Processed(p_start_session, 'B', 11, 15, 'StudentApplication')  AS days1set,
                getReport3Processed(p_start_session, 'B', 15, 20, 'StudentApplication')  AS days2set,
                getReport3Processed(p_start_session, 'B', 20, 25, 'StudentApplication')  AS days3set,
                getReport3Processed(p_start_session, 'B', 25, 30, 'StudentApplication')  AS days4set,
                getReport3Processed(p_start_session, 'B', 30, 35, 'StudentApplication')  AS days5set,
                getReport3Processed(p_start_session, 'B', 35, 40, 'StudentApplication')  AS days6set,
                getReport3Processed(p_start_session, 'B', 40, 45, 'StudentApplication')  AS days7set,
                getReport3Processed(p_start_session, 'B', 45, 50, 'StudentApplication')  AS days8set,
                getReport3Processed(p_start_session, 'B', 50, 55, 'StudentApplication')  AS days9set,
                getReport3Processed(p_start_session, 'B', 55, 60, 'StudentApplication')  AS days10set,
                getReport3Processed(p_start_session, 'B', 60, 65, 'StudentApplication')  AS days11set,
                getReport3Processed(p_start_session, 'B', 65, 100, 'StudentApplication')  AS days12set,
                getReport3Processed(p_start_session, 'B', 100, 365, 'StudentApplication')  AS days13set,
                getReport3AvgTime(p_start_session, 'B', 19, 365, 'StudentApplication' ) AS AvgTime,
                getReport3Processed(p_start_session, 'B', 11, 365, 'StudentApplication')  AS total, 3 AS ord
                FROM DUAL
          UNION
                SELECT 'Total' AS status, 
                getReport3Processed(p_start_session, p_scheme_type, 11, 15, 'StudentApplication')  AS days1set,
                getReport3Processed(p_start_session, p_scheme_type, 15, 20, 'StudentApplication')  AS days2set,
                getReport3Processed(p_start_session, p_scheme_type, 20, 25, 'StudentApplication')  AS days3set,
                getReport3Processed(p_start_session, p_scheme_type, 25, 30, 'StudentApplication')  AS days4set,
                getReport3Processed(p_start_session, p_scheme_type, 30, 35, 'StudentApplication')  AS days5set,
                getReport3Processed(p_start_session, p_scheme_type, 35, 40, 'StudentApplication')  AS days6set,
                getReport3Processed(p_start_session, p_scheme_type, 40, 45, 'StudentApplication')  AS days7set,
                getReport3Processed(p_start_session, p_scheme_type, 45, 50, 'StudentApplication')  AS days8set,
                getReport3Processed(p_start_session, p_scheme_type, 50, 55, 'StudentApplication')  AS days9set,
                getReport3Processed(p_start_session, p_scheme_type, 55, 60, 'StudentApplication')  AS days10set,
                getReport3Processed(p_start_session, p_scheme_type, 60, 65, 'StudentApplication')  AS days11set,
                getReport3Processed(p_start_session, p_scheme_type, 65, 100, 'StudentApplication')  AS days12set,
                getReport3Processed(p_start_session, p_scheme_type, 100, 365, 'StudentApplication')  AS days13set,
                getReport3AvgTime(p_start_session, p_scheme_type, 19, 365, 'StudentApplication' ) AS AvgTime,
                getReport3Processed(p_start_session, p_scheme_type, 11, 365, 'StudentApplication')  AS total, 4 AS ord
                FROM DUAL
                ORDER BY ORD;
         
     EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   
   END report3adata;
   
   
   
     PROCEDURE report3cdata (p_start_session IN VARCHAR, p_scheme_type IN VARCHAR,  p_report3cApplic_type IN OUT report3ctypeApplic_cursor, 
                                                                                p_report3cScheme_type IN OUT report3ctypeScheme_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2)
                                                                                
  IS
  
  BEGIN
  
    OPEN 
   
        p_report3cApplic_type FOR
        
                                             
        
        SELECT 'Applications Processed' AS status, 
                getReport3Processed(p_start_session, p_scheme_type, 11, 15, 'Correspondence')  AS days1set,
                getReport3Processed(p_start_session, p_scheme_type, 15, 20, 'Correspondence')  AS days2set,
                getReport3Processed(p_start_session, p_scheme_type, 20, 25, 'Correspondence')  AS days3set,
                getReport3Processed(p_start_session, p_scheme_type, 25, 30, 'Correspondence')  AS days4set,
                getReport3Processed(p_start_session, p_scheme_type, 30, 35, 'Correspondence')  AS days5set,
                getReport3Processed(p_start_session, p_scheme_type, 35, 40, 'Correspondence')  AS days6set,
                getReport3Processed(p_start_session, p_scheme_type, 40, 45, 'Correspondence')  AS days7set,
                getReport3Processed(p_start_session, p_scheme_type, 45, 50, 'Correspondence')  AS days8set,
                getReport3Processed(p_start_session, p_scheme_type, 50, 55, 'Correspondence')  AS days9set,
                getReport3Processed(p_start_session, p_scheme_type, 55, 60, 'Correspondence')  AS days10set,
                getReport3Processed(p_start_session, p_scheme_type, 60, 65, 'Correspondence')  AS days11set,
                getReport3Processed(p_start_session, p_scheme_type, 65, 100, 'Correspondence')  AS days12set,
                getReport3Processed(p_start_session, p_scheme_type, 100, 365, 'Correspondence')  AS days13set,
                getReport3AvgTime(p_start_session, p_scheme_type, 19, 365, 'Correspondence' ) AS AvgTime,
                getReport3Processed(p_start_session, p_scheme_type, 11, 365, 'Correspondence')  AS total, 1 AS ORD 
                FROM DUAL
                ORDER BY ORD;
                
                
    OPEN
              
        p_report3cScheme_type FOR
        
        SELECT 'UG Applications Processed' AS status,
                getReport3Processed(p_start_session, 'U', 11, 15, 'Correspondence')  AS days1set,
                getReport3Processed(p_start_session, 'U', 15, 20, 'Correspondence')  AS days2set,
                getReport3Processed(p_start_session, 'U', 20, 25, 'Correspondence')  AS days3set,
                getReport3Processed(p_start_session, 'U', 25, 30, 'Correspondence')  AS days4set,
                getReport3Processed(p_start_session, 'U', 30, 35, 'Correspondence')  AS days5set,
                getReport3Processed(p_start_session, 'U', 35, 40, 'Correspondence')  AS days6set,
                getReport3Processed(p_start_session, 'U', 40, 45, 'Correspondence')  AS days7set,
                getReport3Processed(p_start_session, 'U', 45, 50, 'Correspondence')  AS days8set,
                getReport3Processed(p_start_session, 'U', 50, 55, 'Correspondence')  AS days9set,
                getReport3Processed(p_start_session, 'U', 55, 60, 'Correspondence')  AS days10set,
                getReport3Processed(p_start_session, 'U', 60, 65, 'Correspondence')  AS days11set,
                getReport3Processed(p_start_session, 'U', 65, 100, 'Correspondence')  AS days12set,
                getReport3Processed(p_start_session, 'U', 100, 365, 'Correspondence')  AS days13set,
                getReport3AvgTime(p_start_session, 'U', 19, 365, 'Correspondence' ) AS AvgTime,
                getReport3Processed(p_start_session, 'U', 11, 365, 'Correspondence')  AS total, 1 AS ord
                FROM DUAL
         UNION
                 SELECT 'PG Applications Processed' AS status,
                getReport3Processed(p_start_session, 'P', 11, 15, 'Correspondence')  AS days1set,
                getReport3Processed(p_start_session, 'P', 15, 20, 'Correspondence')  AS days2set,
                getReport3Processed(p_start_session, 'P', 20, 25, 'Correspondence')  AS days3set,
                getReport3Processed(p_start_session, 'P', 25, 30, 'Correspondence')  AS days4set,
                getReport3Processed(p_start_session, 'P', 30, 35, 'Correspondence')  AS days5set,
                getReport3Processed(p_start_session, 'P', 35, 40, 'Correspondence')  AS days6set,
                getReport3Processed(p_start_session, 'P', 40, 45, 'Correspondence')  AS days7set,
                getReport3Processed(p_start_session, 'P', 45, 50, 'Correspondence')  AS days8set,
                getReport3Processed(p_start_session, 'P', 50, 55, 'Correspondence')  AS days9set,
                getReport3Processed(p_start_session, 'P', 55, 60, 'Correspondence')  AS days10set,
                getReport3Processed(p_start_session, 'P', 60, 65, 'Correspondence')  AS days11set,
                getReport3Processed(p_start_session, 'P', 65, 100, 'Correspondence')  AS days12set,
                getReport3Processed(p_start_session, 'P', 100, 365, 'Correspondence')  AS days13set,
                getReport3AvgTime(p_start_session, 'P', 19, 365, 'Correspondence' ) AS AvgTime,
                getReport3Processed(p_start_session, 'P', 11, 365, 'Correspondence')  AS total, 2 AS ord
                FROM DUAL
         UNION
                 SELECT 'NMSB Applications Processed' AS status,
                getReport3Processed(p_start_session, 'B', 11, 15, 'Correspondence')  AS days1set,
                getReport3Processed(p_start_session, 'B', 15, 20, 'Correspondence')  AS days2set,
                getReport3Processed(p_start_session, 'B', 20, 25, 'Correspondence')  AS days3set,
                getReport3Processed(p_start_session, 'B', 25, 30, 'Correspondence')  AS days4set,
                getReport3Processed(p_start_session, 'B', 30, 35, 'Correspondence')  AS days5set,
                getReport3Processed(p_start_session, 'B', 35, 40, 'Correspondence')  AS days6set,
                getReport3Processed(p_start_session, 'B', 40, 45, 'Correspondence')  AS days7set,
                getReport3Processed(p_start_session, 'B', 45, 50, 'Correspondence')  AS days8set,
                getReport3Processed(p_start_session, 'B', 50, 55, 'Correspondence')  AS days9set,
                getReport3Processed(p_start_session, 'B', 55, 60, 'Correspondence')  AS days10set,
                getReport3Processed(p_start_session, 'B', 60, 65, 'Correspondence')  AS days11set,
                getReport3Processed(p_start_session, 'B', 65, 100, 'Correspondence')  AS days12set,
                getReport3Processed(p_start_session, 'B', 100, 365, 'Correspondence')  AS days13set,
                getReport3AvgTime(p_start_session, 'B', 19, 365, 'Correspondence' ) AS AvgTime,
                getReport3Processed(p_start_session, 'B', 11, 365, 'Correspondence')  AS total, 3 AS ord
                FROM DUAL
          UNION
                SELECT 'Total' AS status, 
                getReport3Processed(p_start_session, p_scheme_type, 11, 15, 'Correspondence')  AS days1set,
                getReport3Processed(p_start_session, p_scheme_type, 15, 20, 'Correspondence')  AS days2set,
                getReport3Processed(p_start_session, p_scheme_type, 20, 25, 'Correspondence')  AS days3set,
                getReport3Processed(p_start_session, p_scheme_type, 25, 30, 'Correspondence')  AS days4set,
                getReport3Processed(p_start_session, p_scheme_type, 30, 35, 'Correspondence')  AS days5set,
                getReport3Processed(p_start_session, p_scheme_type, 35, 40, 'Correspondence')  AS days6set,
                getReport3Processed(p_start_session, p_scheme_type, 40, 45, 'Correspondence')  AS days7set,
                getReport3Processed(p_start_session, p_scheme_type, 45, 50, 'Correspondence')  AS days8set,
                getReport3Processed(p_start_session, p_scheme_type, 50, 55, 'Correspondence')  AS days9set,
                getReport3Processed(p_start_session, p_scheme_type, 55, 60, 'Correspondence')  AS days10set,
                getReport3Processed(p_start_session, p_scheme_type, 60, 65, 'Correspondence')  AS days11set,
                getReport3Processed(p_start_session, p_scheme_type, 65, 100, 'Correspondence')  AS days12set,
                getReport3Processed(p_start_session, p_scheme_type, 100, 365, 'Correspondence')  AS days13set,
                getReport3AvgTime(p_start_session, p_scheme_type, 19, 365, 'Correspondence' ) AS AvgTime,
                getReport3Processed(p_start_session, p_scheme_type, 11, 365, 'Correspondence')  AS total, 4 AS ord
                FROM DUAL
                ORDER BY ORD;
         
     EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   
   END report3cdata;
        
   
   
   
   
   
   PROCEDURE report5data (p_date1 IN VARCHAR, p_date2 IN VARCHAR, p_scheme_type IN VARCHAR, p_category IN VARCHAR, p_teams IN VARCHAR,
                                                                                p_report5DaysTaken_Type IN OUT report5typeDaysTaken_cursor, 
                                                                                ERROR_TEXT OUT NOCOPY VARCHAR2)
   IS
  
   BEGIN
   
      OPEN p_report5DaysTaken_Type FOR
      
      
      SELECT '1 day' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 0,2,'STUDENTAPPLICATION',p_category) AS NOAP,
                        getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 0, 2,'STUDENTAPPLICATION',p_category) AS PTCS,
                        ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 0,2,'CORRESPONDENCE',p_category) AS NOCP,
                        getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 0, 2,'CORRESPONDENCE',p_category) AS PTCSC, 1 AS ord                
      FROM DUAL
      UNION
      SELECT '2 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 1,3,'STUDENTAPPLICATION',p_category) AS NOAP,
                        getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 1, 3,'STUDENTAPPLICATION',p_category) AS PTCS,
                        ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 1,3,'CORRESPONDENCE',p_category) AS NOCP,
                        getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 1, 3,'CORRESPONDENCE',p_category) AS PTCSC, 2 AS ord
      FROM DUAL
      UNION
      SELECT '3 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 2,4,'STUDENTAPPLICATION',p_category) AS NOAP,
                      getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 2, 4,'STUDENTAPPLICATION',p_category) AS PTCS,
                      ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 2,4,'CORRESPONDENCE',p_category) AS NOCP,
                      getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 2, 4,'CORRESPONDENCE',p_category) AS PTCSC, 3 AS ord
      FROM DUAL
      UNION
      SELECT '4 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 3,5,'STUDENTAPPLICATION',p_category) AS NOAP,
                      getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 3, 5,'STUDENTAPPLICATION',p_category) AS PTCS,
                      ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 3,5,'CORRESPONDENCE',p_category) AS NOCP,
                      getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 3, 5,'CORRESPONDENCE',p_category) AS PTCSC, 4 AS ord
      FROM DUAL
      UNION
      SELECT '5 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 4,6,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 4, 6,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 4,6,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 4, 6,'CORRESPONDENCE',p_category) AS PTCSC, 5 AS ord
      FROM DUAL
      UNION
      SELECT '6 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 5,7,'STUDENTAPPLICATION',p_category) AS NOAP,
                      getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 5, 7,'STUDENTAPPLICATION',p_category) AS PTCS,
                      ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 5,7,'CORRESPONDENCE',p_category) AS NOCP,
                      getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 5, 7,'CORRESPONDENCE',p_category) AS PTCSC, 6 AS ord
      FROM DUAL
      UNION
      SELECT '7 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 6,8,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 6, 8,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 6,8,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 6, 8,'CORRESPONDENCE',p_category) AS PTCSC, 7 AS ord
      FROM DUAL
      UNION
      SELECT '8 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 7,9,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 7, 9,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 7,9,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 7, 9,'CORRESPONDENCE',p_category) AS PTCSC, 8 AS ord
      FROM DUAL
      UNION
      SELECT '9 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 8,10,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 8, 10,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 8,10,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 8, 10,'CORRESPONDENCE',p_category) AS PTCSC, 9 AS ord
      FROM DUAL
      UNION
      SELECT '10 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 9,11,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 9, 11,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 9,11,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 9, 11,'CORRESPONDENCE',p_category) AS PTCSC, 10 AS ord
      FROM DUAL
      UNION
      SELECT '11 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 10,12,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 10, 12,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 10,12,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 10, 12,'CORRESPONDENCE',p_category) AS PTCSC, 11 AS ord
      FROM DUAL
      UNION
      SELECT '12 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 11,13,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 11, 13,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 11,13,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 11, 13,'CORRESPONDENCE',p_category) AS PTCSC, 12 AS ord
      FROM DUAL
      UNION
      SELECT '13 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 12,14,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 12, 14,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 12,14,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 12, 14,'CORRESPONDENCE',p_category) AS PTCSC, 13 AS ord
      FROM DUAL
      UNION
      SELECT '14 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 13,15,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 13, 15,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 13,15,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 13, 15,'CORRESPONDENCE',p_category) AS PTCSC, 14 AS ord
      FROM DUAL
      UNION
      SELECT '15 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 14,16,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 14, 16,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 14,16,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 14, 16,'CORRESPONDENCE',p_category) AS PTCSC, 15 AS ord
      FROM DUAL
      UNION
      SELECT '16 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 15,17,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 15, 17,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 15,17,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 15, 17,'CORRESPONDENCE',p_category) AS PTCSC, 16 AS ord
      FROM DUAL
      UNION
      SELECT '17 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 16,18,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 16, 18,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 16,18,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 16, 18,'CORRESPONDENCE',p_category) AS PTCSC, 17 AS ord
      FROM DUAL
      UNION
      SELECT '18 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 17,19,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 17, 19,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 17,19,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 17, 19,'CORRESPONDENCE',p_category) AS PTCSC, 18 AS ord
      FROM DUAL
      UNION
      SELECT '19 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 18,20,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 18, 20,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 18,20,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 18, 20,'CORRESPONDENCE',p_category) AS PTCSC, 19 AS ord
      FROM DUAL
      UNION
      SELECT '20 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 19,21,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 19, 21,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 19,21,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 19, 21,'CORRESPONDENCE',p_category) AS PTCSC, 20 AS ord
      FROM DUAL
      UNION
      SELECT '21 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 20,22,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 20, 22,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 20,22,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 20, 22,'CORRESPONDENCE',p_category) AS PTCSC, 21 AS ord
      FROM DUAL
      UNION
      SELECT '22 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 21,23,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 21, 23,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 21,23,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 21, 23,'CORRESPONDENCE',p_category) AS PTCSC, 22 AS ord
      FROM DUAL
      UNION
      SELECT '23 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 22,24,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 22, 24,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 22,24,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 22, 24,'CORRESPONDENCE',p_category) AS PTCSC, 23 AS ord
      FROM DUAL
      UNION
      SELECT '24 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 23,25,'STUDENTAPPLICATION',p_category)AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 23, 25,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 23,25,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 23, 25,'CORRESPONDENCE',p_category) AS PTCSC, 24 AS ord
      FROM DUAL
      UNION
      SELECT '25 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 24,26,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 24, 26,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 24,26,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 24, 26,'CORRESPONDENCE',p_category) AS PTCSC, 25 AS ord
      FROM DUAL
      UNION
      SELECT '> 25 days' AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 24,365,'STUDENTAPPLICATION',p_category) AS NOAP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 24, 365,'STUDENTAPPLICATION',p_category) AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 24,365,'CORRESPONDENCE',p_category) AS NOCP,
                            getPercentOfTotCompledRep5(p_scheme_type, p_date1, p_date2, p_teams, 24, 365,'CORRESPONDENCE',p_category) AS PTCSC, 26 AS ord
      FROM DUAL
      UNION
      SELECT 'Average' AS status, getAverageTaskRep5(p_scheme_type, p_date1 , p_date2, p_teams,'STUDENTAPPLICATION',p_category) AS NOAP,
                            null AS PTCS,
                            getAverageTaskRep5(p_scheme_type, p_date1 , p_date2, p_teams,'CORRESPONDENCE',p_category) AS NOCP,
                            null AS PTCSC, 27 AS ord
                  FROM DUAL
      UNION
      SELECT 'Total'   AS status, ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 0,365,'STUDENTAPPLICATION',p_category) AS NOAP,
                            null AS PTCS,
                            ProcessedReport5(p_scheme_type, p_date1, p_date2, p_teams, 0,365,'CORRESPONDENCE',p_category) AS NOCP,
                            null AS PTCSC, 28 AS ord
      FROM DUAL
      ORDER BY ord;
   
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   
   END report5data;


END PK_MI_REPORTS;
/
