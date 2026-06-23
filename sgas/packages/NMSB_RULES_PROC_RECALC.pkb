CREATE OR REPLACE PACKAGE BODY SGAS.nmsb_rules_proc_recalc
AS
/******************************************************************************
   NAME:       NMSB_RULES_PROC_RECALC
   PURPOSE:    This package is used in order to supply the Rules service with values in which to calculate the NMSB Student Award

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01.07.2010   Paul Hughes     Created this package body
   1.1        21.03.2011   Clark Bolan      Amended updateAwardInstalments service to include'SNIE'
   1.2        28.03.2011   Paul Hughes      Marked as final live version
   1.3        04.05.2011   Clark Bolan      lastest crse year ind = 'Y' added to the get_prev_single_rate FUNCTION
   1.4        04.05.2011   Paul Hughes     Double Payment changed to return 1 if in course year > 1
   1.5        31.05.2011   Clark Bolan     2 FUNCTIONS added to handle paid instalments when we have left over debt.
   1.6        08.06.2011   Paul Hughes     SNB_SINGLE_RATE now taken from current stud_crse_year record instead of new. 
   1.7        13.01.2015   Ranj Benning    Added NMSB CoS 2015 Changes
   1.8        29/10/2019   James Baird     Removed the @GRASS for course and institution tables.
   1.9        20.06.2022   Clark Bolan     Overpayments changes 

******************************************************************************/

   ---THIS IS A SIMPLE FLAG TO SEE IF NMSB_SPEC_ARR RECORDS EXIST.
   FUNCTION sncap_spec_record_exist (
      p_stud_crse_year_id   IN   NUMBER,
      p_award_id            IN   NUMBER
   )
      RETURN CHAR
   IS
      l_count    NUMBER;
      l_number   NUMBER;
      l_result   CHAR;
   BEGIN
      SELECT COUNT (*)
        INTO l_number
        FROM award a
       WHERE award_id = p_award_id AND stud_award_type = 'SNCAP';

      IF l_number > 0      --THIS IS SNCAP TYPE WE NEED TO DO FURTHER ANALYSIS
      THEN
         ---IF ANY MODIFICATIONS ARE MADE TO THIS SQL PLEASE ALSO UPDATE FUNCTION SNCAPNMSBDAYSINTERM
         SELECT COUNT (*)
           INTO l_count
           FROM (SELECT a.stud_ref_no
                   FROM nmsb_spec_arr a, stud_crse_year b
                  WHERE a.stud_ref_no = b.stud_ref_no
                    AND a.session_code = b.session_code
                    AND a.nmsb_spec_arr_type IN ('M', 'C')
                    AND a.recommence_date IS NOT NULL
                    AND b.stud_crse_year_id = p_stud_crse_year_id
                 UNION
                 SELECT a.stud_ref_no
                   FROM nmsb_spec_arr a, stud_crse_year b
                  WHERE a.stud_ref_no = b.stud_ref_no
                    AND a.session_code = b.session_code
                    AND a.nmsb_spec_arr_type IN ('M', 'C')
                    AND b.stud_crse_year_id = p_stud_crse_year_id
                    AND a.recommence_date IS NULL
                 UNION
                 SELECT a.stud_ref_no
                   FROM nmsb_spec_arr a, stud_crse_year b
                  WHERE a.stud_ref_no = b.stud_ref_no
                    AND a.session_code = b.session_code
                    AND a.nmsb_spec_arr_type = 'E'
                    AND b.stud_crse_year_id = p_stud_crse_year_id
                    AND a.recommence_date IS NULL
                 UNION
                 SELECT a.stud_ref_no
                   FROM nmsb_spec_arr a, stud_crse_year b
                  WHERE a.stud_ref_no = b.stud_ref_no
                    AND a.session_code = b.session_code
                    AND a.nmsb_spec_arr_type = 'E'
                    AND b.stud_crse_year_id = p_stud_crse_year_id
                    AND a.recommence_date + 3 > a.end_date
                    AND a.recommence_date IS NOT NULL);

         IF l_count > 0
         THEN
            l_result := 'Y';
         ELSE
            l_result := 'N';
         END IF;
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END sncap_spec_record_exist;

   FUNCTION non_sncap_spec_record_exist (
      p_stud_crse_year_id   IN   NUMBER,
      p_award_id            IN   NUMBER
   )
      RETURN CHAR
   IS
      l_count    NUMBER;
      l_number   NUMBER;
      l_result   CHAR;
   BEGIN
      SELECT COUNT (*)
        INTO l_number
        FROM award a
       WHERE award_id = p_award_id
             AND stud_award_type NOT IN ('SNCAP', 'SNIE');

      IF l_number > 0
      THEN
         --IF ANY MODIFICATIONS ARE MADE TO SQL BELOW PLEASE ALSO AMEND SQL AT FUNCTION NMSB_DAYS_IN_TERM
         SELECT COUNT (*)
           INTO l_count
           FROM (SELECT a.stud_ref_no
                   FROM nmsb_spec_arr a, stud_crse_year b
                  WHERE a.stud_ref_no = b.stud_ref_no
                    AND a.session_code = b.session_code
                    AND a.nmsb_spec_arr_type IN ('M', 'C', 'E')
                    AND b.stud_crse_year_id = p_stud_crse_year_id
                    AND a.recommence_date + 3 > a.end_date
                    AND a.recommence_date IS NOT NULL
                 UNION
                 SELECT a.stud_ref_no
                   FROM nmsb_spec_arr a, stud_crse_year b
                  WHERE a.stud_ref_no = b.stud_ref_no
                    AND a.session_code = b.session_code
                    AND a.nmsb_spec_arr_type IN ('M', 'C', 'E')
                    AND b.stud_crse_year_id = p_stud_crse_year_id
                    AND a.recommence_date IS NULL);

         IF l_count > 0
         THEN
            l_result := 'Y';
         ELSE
            l_result := 'N';
         END IF;
      ELSE
         l_result := 'N';
      END IF;

      RETURN l_result;
   END non_sncap_spec_record_exist;

   FUNCTION numberoftermsincludingstartend (
      p_stud_crse_year_id   IN   NUMBER,
      p_award_id            IN   NUMBER
   )
      RETURN NUMBER
   IS
      --  l_sncap CHAR;
      --  l_nonsncap  CHAR;
      l_days       NUMBER;
      l_result     NUMBER;
      l_no_terms   NUMBER;
      l_final      NUMBER := 0;
   --  l_startDateExist CHAR;
   BEGIN
      l_no_terms :=
                 sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);

      IF     sgas.rules_proc_recalc.checkstartdate (p_stud_crse_year_id) =
                                                                          'N'
         AND sgas.rules_proc_recalc.checkwithdraworcrsechng
                                                          (p_stud_crse_year_id) =
                                                                           'N'
      THEN
         l_final := l_no_terms;
---THERE IS NO NEED TO LOOP OVER TERMS IF THESE ARE BLANK ITS A SIMPLE RETURN OF THE NUMBER OF TERMS
      ELSE
         --we don't want to have to do with if there is no course change, withdraw_date or start_date so we check this first.
         FOR idx IN 1 .. l_no_terms
         LOOP
            l_days :=
               rules_proc_recalc.getdaysinattendanceinterm
                                                        (p_stud_crse_year_id,
                                                         idx
                                                        );

            IF l_days > 0
            THEN
               l_result := 1;
            ELSE
               l_result := 0;
            END IF;

            l_final := l_final + l_result;
         END LOOP;
      END IF;

      RETURN l_final;
   END numberoftermsincludingstartend;

   FUNCTION nmsbspecarrrecordexist (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_record_exist   CHAR;
      l_count          NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM nmsb_spec_arr a, stud_crse_year b
       WHERE a.stud_ref_no = b.stud_ref_no
         AND a.session_code = b.session_code
         AND b.latest_crse_ind = 'Y'
         AND b.stud_crse_year_id = p_stud_crse_year_id;

      IF l_count > 0
      THEN
         l_record_exist := 'Y';
      ELSE
         l_record_exist := 'N';
      END IF;

      RETURN l_record_exist;
   END nmsbspecarrrecordexist;

---THIS WORKS OUT THE VALUE USED IN THE AWARD_CALCULATION FOR SNCAP AWARDS.  IT WILL RETURN, 0, 1 or a floating point number
   FUNCTION sncapnmsbdaysinterm (
      p_stud_crse_year_id   IN   NUMBER,
      p_term_no             IN   NUMBER
   )
      RETURN FLOAT
   IS
      spec_arr_record_exist   CHAR;
      l_daysinterm            NUMBER;
      l_daysinattendance      NUMBER;
      l_maxtermstart          DATE;
      l_mintermend            DATE;
      l_holidays              NUMBER;
      l_result                FLOAT;

      ----GETS THE RELEVANT INFORMATION FROM THE NMSB_SPEC_ARR TABLE
      CURSOR c_nmsb_dates
      IS
         --IF ANY MODICATIONS ARE MADE TO THIS SQL PLEASE AMEND FUNCTION SNCAP_SPEC_RECORD_EXIST FUNCTION
         SELECT a.start_date AS start_date,
                a.recommence_date - 1 AS end_date
           FROM nmsb_spec_arr a, stud_crse_year b
          WHERE a.stud_ref_no = b.stud_ref_no
            AND a.session_code = b.session_code
            AND a.nmsb_spec_arr_type IN ('M', 'C')
            AND a.recommence_date IS NOT NULL
            AND b.stud_crse_year_id = p_stud_crse_year_id
         UNION
         SELECT a.start_date AS start_date,
                sgas.rules_proc_recalc.getstudyenddate
                                             (b.stud_crse_year_id)
                                                                  AS end_date
           FROM nmsb_spec_arr a, stud_crse_year b
          WHERE a.stud_ref_no = b.stud_ref_no
            AND a.session_code = b.session_code
            AND a.nmsb_spec_arr_type IN ('M', 'C')
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.recommence_date IS NULL
         UNION
         SELECT a.start_date AS start_date,
                sgas.rules_proc_recalc.getstudyenddate
                                             (b.stud_crse_year_id)
                                                                  AS end_date
           FROM nmsb_spec_arr a, stud_crse_year b
          WHERE a.stud_ref_no = b.stud_ref_no
            AND a.session_code = b.session_code
            AND a.nmsb_spec_arr_type = 'E'
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.recommence_date IS NULL
         UNION
         SELECT a.end_date AS start_date, recommence_date AS end_date
           FROM nmsb_spec_arr a, stud_crse_year b
          WHERE a.stud_ref_no = b.stud_ref_no
            AND a.session_code = b.session_code
            AND a.nmsb_spec_arr_type = 'E'
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.recommence_date + 3 > a.end_date
            AND a.recommence_date IS NOT NULL;

      v_nmsb_dates            c_nmsb_dates%ROWTYPE;
   BEGIN
      spec_arr_record_exist :=
          nmsb_rules_proc_recalc.nmsbspecarrrecordexist (p_stud_crse_year_id);
      l_daysinterm :=
         sgas.rules_proc_recalc.getdaysinattendanceinterm
                                                        (p_stud_crse_year_id,
                                                         p_term_no
                                                        );
      l_daysinattendance :=
                 sgas.rules_proc_recalc.daysinattendance (p_stud_crse_year_id);

      --RETURNS START OF TERM ( THIS MAYBE NULL VALUE)
      SELECT NVL
                (nmsb_rules_proc_recalc.getmaxstartdateterm
                                                         (p_stud_crse_year_id,
                                                          p_term_no
                                                         ),
                 TO_DATE ('01/01/9999', 'DD/MM/YYYY')
                )
        INTO l_maxtermstart
        FROM DUAL;

      --RETURNS END OF TERM (THIS MAYBE NULL VALUE)
      SELECT NVL
                (nmsb_rules_proc_recalc.getminenddateterm
                                                         (p_stud_crse_year_id,
                                                          p_term_no
                                                         ),
                 TO_DATE ('01/01/9999', 'DD/MM/YYYY')
                )
        INTO l_mintermend
        FROM DUAL;

      CASE
         WHEN     spec_arr_record_exist = 'Y'
              AND (   TRUNC (l_maxtermstart) =
                                          TO_DATE ('01/01/9999', 'DD/MM/YYYY')
                   OR TRUNC (l_mintermend) =
                                          TO_DATE ('01/01/9999', 'DD/MM/YYYY')
                  )
         THEN
            l_result := 0;
         WHEN spec_arr_record_exist = 'N'
         THEN
            l_result := 1;
         ELSE
       ---REMAINING MAIN LOGIC IS IN THIS SECTION  spec_arr_record_exist = 'Y'
            l_holidays := 0;

            OPEN c_nmsb_dates;

            LOOP
               FETCH c_nmsb_dates
                INTO v_nmsb_dates;

               EXIT WHEN c_nmsb_dates%NOTFOUND;

               CASE
                  WHEN TRUNC (v_nmsb_dates.start_date)
                         BETWEEN TRUNC (l_maxtermstart)
                             AND TRUNC (l_mintermend)
                  THEN
                     IF     v_nmsb_dates.start_date >= l_maxtermstart
                        AND v_nmsb_dates.end_date <= l_mintermend
                     THEN
                        l_holidays :=
                             l_holidays
                           + (  v_nmsb_dates.end_date
                              + 1
                              - v_nmsb_dates.start_date
                             );
                     ELSIF     (v_nmsb_dates.start_date) >= (l_maxtermstart)
                           AND (v_nmsb_dates.end_date) > (l_mintermend)
                     THEN
                        l_holidays :=
                             l_holidays
                           + (l_mintermend + 1 - v_nmsb_dates.start_date);
                     END IF;
                  WHEN TRUNC (v_nmsb_dates.end_date)
                         BETWEEN TRUNC (l_maxtermstart)
                             AND TRUNC (l_mintermend)
                  THEN
                     IF     v_nmsb_dates.start_date < l_maxtermstart
                        AND v_nmsb_dates.end_date <= l_mintermend
                     THEN
                        l_holidays :=
                             l_holidays
                           + (v_nmsb_dates.end_date + 1 - l_maxtermstart);
                     END IF;
                  WHEN TRUNC (v_nmsb_dates.end_date) > l_mintermend
                  AND TRUNC (v_nmsb_dates.start_date) < l_maxtermstart
                  THEN
                     l_holidays := 9999;
                  ELSE
                     l_holidays := l_holidays + 0;
               END CASE;
            END LOOP;

            CLOSE c_nmsb_dates;

            IF l_holidays = 0
            THEN
               l_result := 1;
            ELSIF l_holidays >= 9999
            THEN
               l_result := 0;
            ELSE
               l_result := (l_daysinterm - l_holidays) / l_daysinattendance;
            END IF;
      END CASE;

      RETURN l_result;
   END sncapnmsbdaysinterm;

---THIS WORKS OUT THE VALUE USED IN THE AWARD_CALCULATION FOR NON SNCAP AWARDS.  IT WILL RETURN, 0, 1 or a floating point number
   FUNCTION nmsbdaysinterm (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER)
      RETURN FLOAT
   IS
      spec_arr_record_exist   CHAR;
      l_daysinterm            NUMBER;
      l_daysinattendance      NUMBER;
      l_maxtermstart          DATE;
      l_mintermend            DATE;
      l_holidays              NUMBER;
      l_result                FLOAT;
      x                       NUMBER;

      ----GETS THE RELEVANT INFORMATION FROM THE NMSB_SPEC_ARR TABLE
      CURSOR c_nmsb_dates
      IS
    ---IF ANY MODIFICATIONS ARE MADE TO SQL BELOW PLEASE UPDATE FUNCTION NON_SNCAP_SPEC_RECORD_EXIST
----THESE DATES ARE NOT PAID
         SELECT end_date + 1 AS start_date, recommence_date - 1 AS end_date
           FROM nmsb_spec_arr a, stud_crse_year b
          WHERE a.stud_ref_no = b.stud_ref_no
            AND a.session_code = b.session_code
            AND a.nmsb_spec_arr_type IN ('M', 'C', 'E')
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.recommence_date + 3 > a.end_date
            AND a.recommence_date IS NOT NULL
         UNION
         SELECT a.end_date + 1 AS start_date,
                sgas.rules_proc_recalc.getstudyenddate
                                             (b.stud_crse_year_id)
                                                                  AS end_date
           FROM nmsb_spec_arr a, stud_crse_year b
          WHERE a.stud_ref_no = b.stud_ref_no
            AND a.session_code = b.session_code
            AND a.nmsb_spec_arr_type IN ('M', 'C', 'E')
            AND b.stud_crse_year_id = p_stud_crse_year_id
            AND a.recommence_date IS NULL;

      v_nmsb_dates            c_nmsb_dates%ROWTYPE;
   BEGIN
      spec_arr_record_exist :=
          nmsb_rules_proc_recalc.nmsbspecarrrecordexist (p_stud_crse_year_id);
      l_daysinterm :=
         sgas.rules_proc_recalc.getdaysinattendanceinterm
                                                        (p_stud_crse_year_id,
                                                         p_term_no
                                                        );
      l_daysinattendance :=
                 sgas.rules_proc_recalc.daysinattendance (p_stud_crse_year_id);

      --RETURNS START OF TERM ( THIS MAYBE NULL VALUE)
      SELECT NVL
                (nmsb_rules_proc_recalc.getmaxstartdateterm
                                                         (p_stud_crse_year_id,
                                                          p_term_no
                                                         ),
                 TO_DATE ('01/01/9999', 'DD/MM/YYYY')
                )
        INTO l_maxtermstart
        FROM DUAL;

      --RETURNS END OF TERM (THIS MAYBE NULL VALUE)
      SELECT NVL
                (nmsb_rules_proc_recalc.getminenddateterm
                                                         (p_stud_crse_year_id,
                                                          p_term_no
                                                         ),
                 TO_DATE ('01/01/9999', 'DD/MM/YYYY')
                )
        INTO l_mintermend
        FROM DUAL;

      CASE
         WHEN    TRUNC (l_maxtermstart) = TO_DATE ('01/01/9999', 'DD/MM/YYYY')
              OR TRUNC (l_mintermend) = TO_DATE ('01/01/9999', 'DD/MM/YYYY')
         THEN
            l_result := 0;
         WHEN spec_arr_record_exist = 'N'
         THEN
            l_result := 1;
         ELSE
       ---REMAINING MAIN LOGIC IS IN THIS SECTION  spec_arr_record_exist = 'Y'
            l_holidays := 0;

            OPEN c_nmsb_dates;

            LOOP
               FETCH c_nmsb_dates
                INTO v_nmsb_dates;

               EXIT WHEN c_nmsb_dates%NOTFOUND;

               CASE
                  WHEN TRUNC (v_nmsb_dates.start_date)
                         BETWEEN TRUNC (l_maxtermstart)
                             AND TRUNC (l_mintermend)
                  THEN
                     IF     v_nmsb_dates.start_date >= l_maxtermstart
                        AND v_nmsb_dates.end_date <= l_mintermend
                     THEN
                        l_holidays :=
                             l_holidays
                           + (  v_nmsb_dates.end_date
                              + 1
                              - v_nmsb_dates.start_date
                             );
                     ELSIF     (v_nmsb_dates.start_date) >= (l_maxtermstart)
                           AND (v_nmsb_dates.end_date) > (l_mintermend)
                     THEN
                        l_holidays :=
                             l_holidays
                           + (l_mintermend + 1 - v_nmsb_dates.start_date);
                     END IF;
                  WHEN TRUNC (v_nmsb_dates.end_date)
                         BETWEEN TRUNC (l_maxtermstart)
                             AND TRUNC (l_mintermend)
                  THEN
                     IF     v_nmsb_dates.start_date < l_maxtermstart
                        AND v_nmsb_dates.end_date <= l_mintermend
                     THEN
                        l_holidays :=
                             l_holidays
                           + (v_nmsb_dates.end_date + 1 - l_maxtermstart);
                     END IF;
                  WHEN TRUNC (v_nmsb_dates.end_date) > l_mintermend
                  AND TRUNC (v_nmsb_dates.start_date) < l_maxtermstart
                  THEN
                     l_holidays := 9999;
                  ELSE
                     l_holidays := l_holidays + 0;
               END CASE;
            END LOOP;

            CLOSE c_nmsb_dates;

            IF l_holidays = 0
            THEN
               l_result := 1;
            ELSIF l_holidays >= 9999
            THEN
               l_result := 0;
            ELSE
               l_result := (l_daysinterm - l_holidays) / l_daysinattendance;
            END IF;
      END CASE;

      -- RETURN l_holidays;
      RETURN l_result;
   END nmsbdaysinterm;

---STUDENT IS ENTITLED TO A DOUBLE PAYMENT ONLY IF THE START DATE IS EITHER NULL OR EXITS IN TERM 1 ONLY ELSE A SINGLE PAYMENT WILL BE MADE
   FUNCTION doublepayment (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_double         CHAR (1);
      l_temp           DATE;
      l_start          CHAR (1);
      start_date       DATE;
      l_stud_ref_no    NUMBER;
      l_session_code   NUMBER;
      l_morecrseyr     CHAR;
      l_count          NUMBER;
      l_no_terms       NUMBER;
   BEGIN
      l_no_terms :=
                 sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);

      IF l_no_terms < 11
      THEN
         l_double := 'N';
      ELSE
         l_morecrseyr :=
            sgas.rules_proc_recalc.more_studcrse_year_record
                                                         (p_stud_crse_year_id);

         SELECT stud_ref_no, session_code
           INTO l_session_code, l_stud_ref_no
           FROM stud_crse_year
          WHERE stud_crse_year_id = p_stud_crse_year_id;

         SELECT COUNT
                   (stud_crse_year_id)
                                    --IF THIS THE FIRST STUD_CRSE_YEAR RECORD?
           INTO l_count
           FROM stud_crse_year
          WHERE stud_ref_no = l_stud_ref_no
            AND session_code = l_session_code
            AND stud_crse_year_id < p_stud_crse_year_id;

         IF     l_morecrseyr = 'Y'
            AND l_count > 0        ---THIS IS NOT THE FIRST COURSE YEAR RECORD
         THEN
            l_double := 'N';
         ELSE
            l_start :=
                  sgas.rules_proc_recalc.checkstartdate (p_stud_crse_year_id);

            IF l_start = 'N'
            THEN
               l_double := 'Y';
            ELSE
               l_temp :=
                  sgas.nmsb_rules_proc_recalc.gettermenddate
                                                        (p_stud_crse_year_id,
                                                         1
                                                        );

               SELECT start_date
                 INTO start_date
                 FROM stud_crse_year
                WHERE stud_crse_year_id = p_stud_crse_year_id;

               IF TRUNC (start_date) > TRUNC (l_temp)
               THEN
                  l_double := 'N';
               ELSE
                  l_double := 'Y';
               END IF;
            END IF;
         END IF;
      END IF;

      RETURN l_double;
   END doublepayment;

---THIS FUNCTION SIMPLY RETURNS THE LAST DAY OF THE TERM (IT DOES NOT TAKE COURSE CHANGE OR WITHDRAW DATES INTO ACCOUNT
   FUNCTION gettermenddate (p_stud_crse_year_id IN NUMBER, p_term_no IN NUMBER)
      RETURN DATE
   IS
      l_end_date       DATE;
      l_default_term   CHAR (1);
      l_max_term       CHAR (2);
   BEGIN
      l_default_term :=
             sgas.rules_proc_recalc.check_default_terms (p_stud_crse_year_id);
      l_max_term :=
                 sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);

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
              FROM crse_term ct, stud_crse_year scy
             WHERE scy.crse_year_id = ct.crse_year_id
               AND ct.term_no = p_term_no
               AND scy.stud_crse_year_id = p_stud_crse_year_id;
         END IF;
      ELSE
         l_end_date := NULL;
      END IF;

      RETURN l_end_date;
   END gettermenddate;

---IF THERE IS A RECORD ON THE NMSB_SPEC_ARR TABLE WHICH HAPPENS TO OVERLAP ANY OF THE TERM DATES THIS WILL SET A FLAG TO 'Y'
   FUNCTION overlaptermdates (
      p_stud_crse_year_id   IN   NUMBER,
      p_award_id            IN   NUMBER
   )
      RETURN CHAR
   IS
      l_sncap      CHAR;
      l_nonsncap   CHAR;
      l_overlap    CHAR (1);
      l_no_terms   NUMBER;
      l_temp       NUMBER;
      l_check      NUMBER;
      l_records    NUMBER;
   BEGIN
      -- get number of terms to loop over
      l_sncap := sncap_spec_record_exist (p_stud_crse_year_id, p_award_id);
      l_nonsncap :=
                non_sncap_spec_record_exist (p_stud_crse_year_id, p_award_id);

      IF l_sncap = 'N' AND l_nonsncap = 'N'
      THEN
         l_overlap := 'N';
      ELSIF l_sncap = 'Y' AND l_nonsncap = 'N'
      THEN
         l_no_terms :=
                 sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);
         l_overlap := 'N';

         FOR idx IN 1 .. l_no_terms
         LOOP
            l_temp :=
               sgas.nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                        (p_stud_crse_year_id,
                                                         idx
                                                        );

            IF l_temp <> 1
            THEN
               l_overlap := 'Y';
            END IF;
         END LOOP;
      ELSE                                                 ---l_nonSNCAP = 'Y'
         l_no_terms :=
                 sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);
         l_overlap := 'N';

         FOR idx IN 1 .. l_no_terms
         LOOP
            l_temp :=
               sgas.nmsb_rules_proc_recalc.nmsbdaysinterm
                                                        (p_stud_crse_year_id,
                                                         idx
                                                        );

            IF l_temp <> 1
            THEN
               l_overlap := 'Y';
            END IF;
         END LOOP;
      END IF;

      IF l_overlap = NULL
      THEN
         l_overlap := 'N';
      END IF;

      RETURN l_overlap;
   END overlaptermdates;

---SIMPLE FUNCTION WHICH RETURNS THE MINIMUM VALUE BETWEEN COURSE_CHANGE_DATE AND WITHDRAW DATE.  IF NONE OF THESE DATES EXIST A NULL VALUE IS OUTPUT.
   FUNCTION getminwithdrawcrsechange (p_stud_crse_year_id IN NUMBER)
      RETURN DATE
   IS
      l_end        DATE;
      l_withdraw   DATE;
      l_crse_chg   DATE;
   BEGIN
      SELECT NVL (scy.crse_chg, TO_DATE ('01/01/3000', 'DD/MM/YYYY')),
             NVL (scy.withdraw_date, TO_DATE ('01/01/3000', 'DD/MM/YYYY'))
        INTO l_crse_chg,
             l_withdraw
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = p_stud_crse_year_id;

      -- WE NEED TO FIND THE MIN DATE BETWEEN SCY.WITHDRAW_DATE, SCY.CRSE_CHG AND COURSE END DATE FOR TERM
      CASE
         WHEN     TRUNC (l_crse_chg) = TO_DATE ('01/01/3000', 'DD/MM/YYYY')
              AND l_withdraw = TO_DATE ('01/01/3000', 'DD/MM/YYYY')
         THEN
            l_end := NULL;
         WHEN l_withdraw <= l_crse_chg
         THEN
            l_end := l_withdraw;
         WHEN l_crse_chg < l_withdraw
         THEN
            l_end := l_crse_chg;
         ELSE
            l_end := NULL;
      END CASE;

      RETURN l_end;
   END getminwithdrawcrsechange;

---THIS FUNCTION WILL RETURN THE START_DATE FROM STUD_CRSE_YEAR RECORD ONLY IF IT EXISTS IN THE TERM INSERTED INTO FUNCTION.  IF THE START_DATE
--IS AFTER THE TERM_END DATE IT WILL RETURN NULL.  NOTE:  THIS FUNCTION IS USED IN CONJUNTION WITH getMAXEndDateTerm.  This function does not take withdraw/crsechange into account
   FUNCTION getmaxstartdateterm (
      p_stud_crse_year_id   IN   NUMBER,
      p_term_no             IN   NUMBER
   )
      RETURN DATE
   IS
      l_startdateexist    CHAR;
                          --- RETURNS 'Y' if stud_crse_Year.start_date exists
      l_scystartdate      DATE;
      l_term_start_date   DATE;
      l_term_end_date     DATE;
      l_default_term      CHAR;
      l_result            DATE;
   BEGIN
      l_startdateexist :=
                  sgas.rules_proc_recalc.checkstartdate (p_stud_crse_year_id);
                                          ---RETURNS 'Y' IF START_DATE EXISTS
      l_default_term :=
             sgas.rules_proc_recalc.check_default_terms (p_stud_crse_year_id);

      IF l_startdateexist = 'Y'
      THEN
         SELECT scy.start_date
           INTO l_scystartdate
           FROM stud_crse_year scy
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
           FROM crse_term ct, stud_crse_year scy
          WHERE scy.crse_year_id = ct.crse_year_id
            AND ct.term_no = p_term_no
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
      END IF;

      CASE
         WHEN l_scystartdate > l_term_end_date
         THEN
            l_result := NULL;
         WHEN     (l_scystartdate <= l_term_end_date)
              AND (l_scystartdate <= l_term_start_date)
         THEN
            l_result := l_term_start_date;
         WHEN     (l_scystartdate > l_term_start_date)
              AND (l_scystartdate <= l_term_end_date)
         THEN
            l_result := l_scystartdate;
         WHEN l_scystartdate IS NULL
         THEN
            l_result := l_term_start_date;
         ELSE
            l_result := NULL;
      END CASE;

      RETURN l_result;
   END getmaxstartdateterm;

---THIS FUNCTION WILL RETURN MINIMUM BETWEEN WITHDRAW_DATE, CRSE_CHANGE_DATE OR TERM_END_DATE.  THIS FUNCTION MAY RETURN NULL IF THE STUDENT HAS WITHDRAWN OR CHANGED COURSE BEFORE
---THE TERM OR STARTED AFTER THE TERM ENDED.
   FUNCTION getminenddateterm (
      p_stud_crse_year_id   IN   NUMBER,
      p_term_no             IN   NUMBER
   )
      RETURN DATE
   IS
      l_withdrawcrseexist   CHAR;
   --- RETURNS 'Y' if stud_crse_Year.withdraw_date OR crse_change date exists
      l_minenddate          DATE;
                        --HOLDS MINIMUM BETWEEN CRSE_CHANGE AND WITHDRAW DATE
      l_term_start_date     DATE;
      l_term_end_date       DATE;
      l_default_term        CHAR;
      l_result              DATE;
   BEGIN
      l_withdrawcrseexist :=
         sgas.rules_proc_recalc.checkwithdraworcrsechng (p_stud_crse_year_id);
                                                      ---RETURNS 'Y' IF XISTS
      l_default_term :=
             sgas.rules_proc_recalc.check_default_terms (p_stud_crse_year_id);

      IF l_withdrawcrseexist = 'Y'
      THEN
         l_minenddate :=
            sgas.nmsb_rules_proc_recalc.getminwithdrawcrsechange
                                                         (p_stud_crse_year_id);
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
           FROM crse_term ct, stud_crse_year scy
          WHERE scy.crse_year_id = ct.crse_year_id
            AND ct.term_no = p_term_no
            AND scy.stud_crse_year_id = p_stud_crse_year_id;
      END IF;

      CASE
         WHEN l_minenddate < l_term_start_date
         THEN
            l_result := NULL;
         WHEN     l_minenddate > l_term_start_date
              AND l_minenddate <= l_term_end_date
         THEN
            l_result := l_minenddate;
         WHEN l_minenddate > l_term_end_date
         THEN
            l_result := l_term_end_date;
         WHEN l_minenddate IS NULL
         THEN
            l_result := l_term_end_date;
      END CASE;

      RETURN l_result;
   END getminenddateterm;

/* Formatted on 16/03/2018 14:38:39 (QP5 v5.215.12089.38647) */
FUNCTION oldestchild (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
IS
   RESULT   NUMBER;
BEGIN
   SELECT MIN (c.std_id)
     INTO RESULT
     FROM stud_crse_year a, stud_dependant c
    WHERE     a.stud_session_id = c.stud_session_id(+)
          AND a.stud_crse_year_id = p_stud_crse_year_id
          AND c.relation_id NOT IN (34, 48)
          AND TRUNC (c.dob) =
                 (SELECT MIN (c.dob)
                    FROM stud_crse_year a, stud_dependant c
                   WHERE     a.stud_session_id = c.stud_session_id(+)
                         AND c.relation_id NOT IN (34, 48)
                         AND a.stud_crse_year_id = p_stud_crse_year_id);

   RETURN RESULT;
END oldestchild;
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
           FROM crse_year a,
                stud_crse_year b,
                crse_session c,
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
      SELECT MONTHS_BETWEEN (l_startfirstday, a.dob) / 12 age
                        --we need to calculate DAYS_BETWEEN not MONTHS_BETWEEN
        -- SELECT (l_startfirstday - a.dob) / 365
      INTO   l_ageonstartcourse
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
              FROM inst_term a, stud_crse_year b
             WHERE a.inst_code = b.inst_code
               AND a.session_code = l_start_year
               AND b.stud_crse_year_id = p_stud_crse_year_id
               AND a.term_no = 1;
         WHEN l_default_start = 'N'
         THEN
            --DEFAULT TERMS ARE NOT USED THEREFORE WE NEED TO LOOK UP THE CRSE_YEAR_ID FROM THERE FIRST YEAR
            SELECT a.start_date
              INTO l_startfirstday
              FROM crse_term a,
                   crse_year b,
                   stud_crse_year c,
                   crse_session d,
                   crse e
             WHERE a.crse_year_id = b.crse_year_id
               AND b.crse_session_id = d.crse_session_id
               AND d.crse_id = e.crse_id
               AND b.inst_code = c.inst_code   --- INSTITUTION CODE FROM STEPS
               AND b.crse_year_no = c.crse_year_no
               -- COURSE YEAR NUMBER FROM STEPS
               AND c.crse_code = e.crse_code             --CRSECODE FROM STEPS
               AND c.stud_crse_year_id = p_stud_crse_year_id
               -- USING THE CURRENT STUDENT REFERENCE NUMBER FROM STEPS
               AND d.session_code = l_start_year
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
       
       IF p_session_code - 1 < STEPS_RELEASE_YEAR
       
        THEN

      SELECT iv1.snb_rate
        INTO l_single_rate
        FROM (SELECT NVL (a.snb_single_rate, 'Y') snb_rate
                FROM stud_crse_year@grass a
               WHERE a.stud_ref_no = p_stud_ref_no
                 AND a.session_code = (p_session_code - 1)
                 AND a.scheme_type = 'B'
                 AND a.latest_crse_ind = 'Y'
              UNION
              SELECT 'Y'                                -- no data, return 'Y'
                FROM DUAL) iv1
       WHERE ROWNUM < 2;
       
       ELSE 
       
                  SELECT iv1.snb_rate
                INTO l_single_rate
                FROM (SELECT NVL (a.snb_single_rate, 'Y') snb_rate
                        FROM stud_crse_year a
                       WHERE a.stud_ref_no = p_stud_ref_no
                         AND a.session_code = (p_session_code - 1)
                         AND a.scheme_type = 'B'
                         AND a.latest_crse_ind = 'Y'
                      UNION
                      SELECT 'Y'                                -- no data, return 'Y'
                        FROM DUAL) iv1
               WHERE ROWNUM < 2;
               
       END IF;
       

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

   FUNCTION getenddateterm (p_stud_crse_year_id IN NUMBER, p_term_no NUMBER)
      RETURN DATE
   IS
      l_end_date       DATE;
      l_default_term   CHAR (1);
      l_max_term       CHAR (2);
   BEGIN
      l_default_term :=
             sgas.rules_proc_recalc.check_default_terms (p_stud_crse_year_id);
      l_max_term :=
                 sgas.rules_proc_recalc.number_of_terms (p_stud_crse_year_id);

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
            SELECT NVL (ct.end_date, TO_DATE ('01/01/9999', 'DD/MM/YYYY'))
              INTO l_end_date
              FROM crse_term ct, stud_crse_year scy
             WHERE scy.crse_year_id = ct.crse_year_id
               AND ct.term_no = p_term_no
               AND scy.stud_crse_year_id = p_stud_crse_year_id;
         END IF;
      ELSE
         l_end_date := NULL;
      END IF;

      RETURN l_end_date;
   END getenddateterm;

   FUNCTION get_paid_instalments_nmsb (p_stud_crse_year_id IN NUMBER)
      RETURN CHAR
   IS
      l_result   CHAR;
      l_count    NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM award a, award_instalment b
       WHERE a.award_id = b.award_id AND payment_status = 'S'
       and B.RETURNED IN('N','T','A')
       AND a.stud_crse_year_id = p_stud_crse_year_id;

      IF l_count = 0
      THEN
         l_result := 'N';
      ELSE
         l_result := 'Y';
      END IF;

      RETURN l_result;
   END get_paid_instalments_nmsb;


   
   FUNCTION get_sum_paid_recovery (p_award_id IN NUMBER)
      RETURN NUMBER
   IS
      l_result   NUMBER;
      l_count    NUMBER;
   BEGIN
   SELECT COUNT(b.recovered_amount)
        INTO l_count
        FROM award_instalment b
       WHERE b.award_id = p_award_id AND b.payment_status = 'S'
       and B.RETURNED IN('N','T','A');
   
   IF l_count = 0
   THEN
        l_result := 0;
   ELSE
       SELECT SUM (b.recovered_amount)
         INTO l_result
         FROM award_instalment b
        WHERE b.award_id = p_award_id AND b.payment_status = 'S'
        and B.RETURNED IN('N','T','A');
        
   END IF;     

      RETURN l_result;
   END get_sum_paid_recovery;

   FUNCTION get_no_unpaid_instalments (p_award_id IN NUMBER)
      RETURN NUMBER
   IS
      l_result   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_result
        FROM award_instalment ai
       WHERE ai.payment_status = 'U' AND ai.award_id = p_award_id;

      RETURN l_result;
   END get_no_unpaid_instalments;
   
   FUNCTION get_debt_amount (p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
   IS
        l_scheme CHAR;
        l_result NUMBER;
   BEGIN
        SELECT scheme_type
        INTO l_scheme
        FROM stud_crse_year
        WHERE stud_crse_year_id = p_stud_crse_year_id;

        
        IF l_scheme = 'B'
        THEN
            SELECT NVL(a.snb_overpayment, 0)
            INTO l_result
            FROM stud a, stud_crse_year b
            WHERE a.stud_ref_no = b.stud_ref_no
            AND b.stud_crse_year_id = p_stud_crse_year_id;
       ELSE
            SELECT NVL(a.overpayment, 0)
            INTO l_result
            FROM stud a, stud_crse_year b
            WHERE a.stud_ref_no = b.stud_ref_no
            AND b.stud_crse_year_id = p_stud_crse_year_id;
       END IF;
       
       RETURN l_result;
       
      END get_debt_amount;
      
   FUNCTION get_stud_debt(p_stud_crse_year_id IN NUMBER)
   RETURN NUMBER
   IS
    
   l_unpaid_debt_instal NUMBER;
   l_debt NUMBER;
   
   BEGIN
   
   l_debt := sgas.nmsb_rules_proc_recalc.get_debt_amount (p_stud_crse_year_id);
   
       SELECT sum(b.recovered_amount)
       INTO l_unpaid_debt_instal
       FROM award a, award_instalment b
       WHERE a.award_id = B.AWARD_ID
       AND B.PAYMENT_STATUS = 'U';
   
   l_debt := l_debt - l_unpaid_debt_instal;
   
   IF l_debt <= 0 
   THEN
            l_debt := 0;
   ELSE
            l_debt := l_debt;
   END IF;
   
   
   RETURN l_debt;
   
   END  get_stud_debt;
   
   
   ---THE PROCEDURE BELOW RETRIEVES THE NMSB PAYMENT(INSTALMENT) DATES FOR A STUDENT (USING STUD_CRSE_YEAR_ID)
   ---THIS IS FOR NMSB STUDENTS FROM SESSION 2015 ONWARDS 
   PROCEDURE get_NMSBPaymentDatesForStud (
      p_stud_crse_year_id   IN   NUMBER,
      nmsb_dates_cursor  IN OUT nmsb_dates_cursor_type
   )
   IS
       endDate     DATE;
       startDate   DATE;       
       
   BEGIN              
       startDate := RULES_PROC_RECALC.getStudyStartDate(p_stud_crse_year_id); 
       endDate   := RULES_PROC_RECALC.getStudyEnddate (p_stud_crse_year_id);   
             
       OPEN nmsb_dates_cursor FOR
            SELECT RULES_PROC_RECALC.getStudyStartDate (p_stud_crse_year_id) AS payment_date
            FROM DUAL
            UNION
            SELECT payment_date
            FROM nmsb_payment_date tab
            WHERE tab.payment_date > startDate AND tab.payment_date <= endDate
            ORDER BY payment_date ASC;  
   END get_NMSBPaymentDatesForStud;
   
      PROCEDURE get_NMSBPaymentDatesForStud_2022 (
      p_stud_crse_year_id   IN   NUMBER,
      nmsb_dates_cursor  IN OUT nmsb_dates_cursor_type
   )
   IS
       endDate     DATE;
       startDate   DATE;       
       
   BEGIN              
       startDate := SGAS.RULES_PROC_RECALC.GETSTARTDATETERM(p_stud_crse_year_id,1); 
       endDate   := SGAS.RULES_PROC_RECALC.getStudyEnddate_2022 (p_stud_crse_year_id);   
             
       OPEN nmsb_dates_cursor FOR
            SELECT SGAS.RULES_PROC_RECALC.GETSTARTDATETERM(p_stud_crse_year_id,1) AS payment_date
            FROM DUAL
            UNION
            SELECT payment_date
            FROM nmsb_payment_date tab
            WHERE tab.payment_date > startDate AND tab.payment_date <= endDate
            ORDER BY payment_date ASC;  
   END get_NMSBPaymentDatesForStud_2022;
   
   

   
   ---THE PROCEDURE BELOW RETRIEVES THE NMSB PAYMENT DATES FOR THE COURSE YEAR (USING STUD_CRSE_YEAR_ID) 
   ---THE START AND END DATES ARE THE COURSE (TERM) DATES - THEY DO NOT TAKE LATER STUDY START DATES OR COURSE CHANGES INTO ACCOUNT
   ---THIS IS FOR NMSB STUDENTS FROM SESSION 2015 ONWARDS 
   PROCEDURE get_NMSBPaymentDatesForCrseYr (
      p_stud_crse_year_id  IN   NUMBER,
      nmsb_dates_cursor IN OUT nmsb_dates_cursor_type
   )
   IS
       endDate     DATE;
       startDate   DATE;       
       
   BEGIN       
       startDate   := rules_proc_recalc.getStartDateTerm (p_stud_crse_year_id, 1);
       endDate     := rules_proc_recalc.getEndDateTerm (p_stud_crse_year_id, 1);
             
       OPEN nmsb_dates_cursor FOR
            SELECT to_char (payment_date, 'dd/MM/YYYY')
            FROM nmsb_payment_date tab
            WHERE tab.payment_date >= startDate AND tab.payment_date <= endDate
            ORDER BY payment_date ASC;              
   END get_NMSBPaymentDatesForCrseYr;

   
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
         SELECT sgas.rules_proc_recalc.daysinattendance
                                     (p_stud_crse_year_id)

                                                         AS daysinattendance,
          sgas.rules_proc_recalc.daysInAttendanceNoWithdrawal (p_stud_crse_year_id)
                                                         AS daysinattendanceNoWithdrawal                                                         
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

   
   
   PROCEDURE getAssessTuitionFeesDoc (
      p_stud_crse_year_id   IN              NUMBER,
      p_tuitionFees_type    IN OUT          tuitionFees_cursor,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )        
IS
BEGIN
   OPEN p_tuitionFees_type FOR
      SELECT a.location_ind,                                  
                            c.commence_session,               
                                                            d.scheme_type,
             scy.inst_code,      
             scy.calc_fee,                                           
             rules_proc_recalc.getfeespaidamount
                                     (p_stud_crse_year_id)
                                                         AS fees_paid_amount,                                                                                   
             CASE
                WHEN (scy.calc_fee = 'Y')
                AND sgas.rules_proc_recalc.getattendfeecutoffdate
                                                        (scy.stud_crse_year_id) =
                                                                           'Y'
                AND sgas.rules_proc_recalc.prevfees (scy.stud_crse_year_id) =
                                                                           'N'
                   THEN 'Y'
                ELSE 'N'
             END attendfeecutoff
        --    ,
        --    'N' AS nmsb_absence,
        --    NULL AS nmsb_absence_return_date
            ,
            scy.nmsb_absence,
            scy.nmsb_absence_return_date,
            scy.start_date,
            e.cutoff_date,
            CASE
                WHEN (scy.start_date > e.cutoff_date)
                THEN 'Y'
                ELSE 'N'
             END isStudyStartAfterCutOff   
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


            
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getAssessTuitionFeesDoc;   

   PROCEDURE calculatedependants (
      p_stud_crse_year_id   IN              NUMBER,
      p_dependants_type     IN OUT          dependants_cursor,
      ERROR_TEXT            OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      OPEN p_dependants_type FOR
         SELECT CASE
                   WHEN a.relation_id = 48 OR a.relation_id = 34
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
            AND a.relation_id(+) IN (34,48)
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
         SELECT b.lpcg_paid_amount caprequested, b.max_lpcg_paid capmax
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
                     WHEN std_id =
                                oldestchild (p_stud_crse_year_id)
                        THEN 'Y'
                     ELSE 'N'
                  END oldestchild,
                  c.start_date AS studdepstartdate,
                  c.end_date AS studdeptenddate
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
         SELECT TRUNC
                   (get_ageonstartcourse (p_stud_crse_year_id),
                    0
                   ) AS ageonstartcourse, NVL(b.snb_single_rate,'Y') AS singlerate
              --  get_prev_single_rate (p_stud_crse_year_id) AS singlerate
           FROM stud a, stud_crse_year b
          WHERE b.stud_crse_year_id = p_stud_crse_year_id
            AND a.stud_ref_no = b.stud_ref_no;
   EXCEPTION
      WHEN OTHERS
      THEN
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END studtypenmsb;

   PROCEDURE calcawardinput (
      p_stud_crse_year_id     IN              NUMBER,
      p_calcawardinput_type   IN OUT          calcawardinput_cursor,
      p_awards_cursor         IN OUT         all_award_cursor_type,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      OPEN p_calcawardinput_type FOR
         SELECT a.stud_crse_year_id, a.inst_code, a.crse_id, a.crse_year_no,
                a.stud_ref_no, a.session_code,
                CASE
                   WHEN a.first_calc_date IS NOT NULL
                   AND a.withdraw_date IS NULL
                   AND a.crse_chg IS NULL
                      THEN 'D'
                   WHEN a.first_calc_date IS NOT NULL
                   AND a.withdraw_date IS NOT NULL
                   AND a.crse_chg IS NULL
                      THEN 'W'
                   WHEN a.first_calc_date IS NOT NULL
                   AND a.withdraw_date IS NULL
                   AND a.crse_chg IS NOT NULL
                      THEN 'C'
                   ELSE 'I'
                END assess_reason_code,
                sgas.rules_proc_recalc.getstartdateterm
                                     (p_stud_crse_year_id,
                                      1
                                     ) AS coursestartdate,
                sgas.nmsb_rules_proc_recalc.getenddateterm
                   (p_stud_crse_year_id,
                    sgas.rules_proc_recalc.number_of_terms
                                                          (p_stud_crse_year_id)
                   ) AS courseenddate,
                
                CASE
                   WHEN a.withdraw_date IS NULL
                   AND a.crse_chg IS NULL
                      THEN a.withdraw_date
                   WHEN a.withdraw_date IS NULL AND a.crse_chg IS NOT NULL
                      THEN a.crse_chg
                   WHEN a.withdraw_date IS NOT NULL AND a.crse_chg IS NULL
                      THEN a.withdraw_date
                   WHEN a.withdraw_date <= a.crse_chg
                      THEN a.withdraw_date
                   ELSE a.crse_chg
                END crseorwithdrawaldate,
                a.start_date, NVL (a.calc_nmsb, 'N'),
                NVL (a.nmsb_init_expenses, 'N') AS initialexpenses,
                a.calc_dep_grant, a.calc_spa, a.calc_lpcg AS calccap,

                A.CALC_FEE as calc_tuition_fees,
                e.snb_overpayment,
                CASE
                    WHEN a.withdraw_date IS NOT NULL
                        THEN 'W'
                    WHEN a.non_att_actioned = 'Y' AND a.non_att_actioned_date IS NOT NULL
                    THEN 'A'
                    ELSE 'C'
                END app_status, a.latest_crse_ind,
                A.NMSB_AWARD_END_REASON,
                A.WITHDRAW_DATE,
                A.CRSE_CHG
           FROM stud_crse_year a, crse_year c, crse_session d, stud e
          WHERE a.stud_crse_year_id = p_stud_crse_year_id
            AND c.crse_year_id = a.crse_year_id
            AND a.stud_ref_no = e.stud_ref_no
            AND c.crse_session_id = d.crse_session_id;

      OPEN p_awards_cursor FOR
         SELECT a.award_id AS award_id, a.stud_award_type AS stud_award_type
           FROM award a
          WHERE a.stud_crse_year_id = p_stud_crse_year_id;
   END calcawardinput;

   PROCEDURE awardinstalmentsnmsb (
      p_stud_crse_year_id          IN       NUMBER,
      p_awardinstalmentnmsb_type   IN OUT   awardinstalmentsnmsb_cursor,
      p_start_dates                IN OUT   startdates_cursor_type,
      p_nmsb_dates                 IN OUT   nmsb_dates_cursor_type
   )
   IS
   BEGIN
      OPEN p_awardinstalmentnmsb_type FOR
         SELECT a.award_id, a.stud_crse_year_id, a.stud_award_type, a.amount,
                a.recovered_amount, a.contrib_amount,
                a.net_amount, a.unclaimed_fee_loan,
                s.payment_method, a.assessment_date, scy.start_date,
                scy.session_code,
                CASE
                   WHEN (s.payment_method = 'C')
                      THEN 'H'
                   WHEN (s.payment_method = 'B' AND s.nominee = 'N'
                        )
                      THEN 'B'
                   ELSE 'N'
                END payment_addr,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     1
                                    ) AS term1startdate,
                sgas.nmsb_rules_proc_recalc.numberoftermsincludingstartend
                                       (scy.stud_crse_year_id,
                                        a.award_id
                                       ) AS termsaddone,
                NVL
                   (sgas.nmsb_rules_proc_recalc.overlaptermdates
                                                       (scy.stud_crse_year_id,
                                                        a.award_id
                                                       ),
                    'N'
                   ) AS nsaoverlapterms,
                CASE
                   WHEN sat.stud_award_type = 'SNCAP'
                   AND nsa.nmsb_spec_arr_type IN ('M', 'C')
                      THEN 'Y'
                   ELSE 'N'
                END sncaptypemc,
                CASE
                   WHEN scy.crse_year_no = 1
                      THEN CASE
                             WHEN sgas.nmsb_rules_proc_recalc.doublepayment
                                         (scy.stud_crse_year_id) =
                                                            'Y'
                                THEN 2
                             ELSE 1
                          END
                   ELSE 1
                END doublepayment,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        1
                                                       )
                   ELSE 0
                END term1sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        2
                                                       )
                   ELSE 0
                END term2sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        3
                                                       )
                   ELSE 0
                END term3sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        4
                                                       )
                   ELSE 0
                END term4sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        5
                                                       )
                   ELSE 0
                END term5sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        6
                                                       )
                   ELSE 0
                END term6sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        7
                                                       )
                   ELSE 0
                END term7sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        8
                                                       )
                   ELSE 0
                END term8sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                           (scy.stud_crse_year_id,
                                            a.award_id
                                           ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        9
                                                       )
                   ELSE 0
                END term9sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        10
                                                       )
                   ELSE 0
                END term10sncap,
                CASE
                   WHEN sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.sncapnmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        11
                                                       )
                   ELSE 0
                END term11sncap,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        1
                                                       )
                   ELSE 0
                END term1amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        2
                                                       )
                   ELSE 0
                END term2amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        3
                                                       )
                   ELSE 0
                END term3amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        4
                                                       )
                   ELSE 0
                END term4amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        5
                                                       )
                   ELSE 0
                END term5amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        6
                                                       )
                   ELSE 0
                END term6amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        7
                                                       )
                   ELSE 0
                END term7amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        8
                                                       )
                   ELSE 0
                END term8amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        9
                                                       )
                   ELSE 0
                END term9amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                          (scy.stud_crse_year_id,
                                           a.award_id
                                          ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        10
                                                       )
                   ELSE 0
                END term9amount,
                CASE
                   WHEN non_sncap_spec_record_exist
                                         (scy.stud_crse_year_id,
                                          a.award_id
                                         ) = 'Y'
                      THEN nmsb_rules_proc_recalc.nmsbdaysinterm
                                                       (scy.stud_crse_year_id,
                                                        11
                                                       )
                   ELSE 0
                END term10amount,
                sgas.rules_proc_recalc.getstudystartterm
                                     (scy.stud_crse_year_id)
                                                           AS studystartterm,
                scy.stud_ref_no, scy.latest_crse_ind, ca.campus_id,
                a.assess_reason_code,
                cy.cutoff_date AS fee_payment_date,
                sgas.rules_proc_recalc.getpaidfees
                                        (scy.stud_crse_year_id)
                                                              AS prepaidfees,
                ca.payment_method AS feespaymentmethod                                                              
           FROM award a,
                stud s,
                stud_crse_year scy,
                crse_year cy,
                crse_session cs,
                crse c,
                inst i,
                stud_award_type sat,
                nmsb_spec_arr nsa,
                campus ca
          WHERE a.stud_crse_year_id = scy.stud_crse_year_id
            AND scy.stud_ref_no = s.stud_ref_no
            AND scy.crse_year_id = cy.crse_year_id
            AND cy.crse_session_id = cs.crse_session_id
            AND sat.stud_award_type = a.stud_award_type
            AND nsa.stud_ref_no(+) = scy.stud_ref_no
            AND nsa.session_code(+) = scy.session_code
            AND sat.loan_non_loan_fee <> 'Loan'
            AND sat.TYPE NOT IN ('DSA', 'TRAV', 'MAN')
            AND sat.scheme = 'NMSB'
            AND cs.crse_id = c.crse_id
            AND scy.scheme_type = 'B'
            AND c.inst_code = i.inst_code
--and c.fees_campus = ca.campus_id
            AND c.maint_campus = ca.campus_id(+)
            AND scy.stud_crse_year_id = p_stud_crse_year_id;

      p_start_dates :=
                   sgas.rules_proc_recalc.get_startdates (p_stud_crse_year_id);
      sgas.nmsb_rules_proc_recalc.get_NMSBPaymentDatesForStud (p_stud_crse_year_id, p_nmsb_dates);                                      
   END awardinstalmentsnmsb;
   
   PROCEDURE awardinstalmentsnmsb_2022 (
      p_stud_crse_year_id          IN       NUMBER,
      p_awardinstalmentnmsb_type   IN OUT   awardinstalmentsnmsb_cursor,
      p_start_dates                IN OUT   startdates_cursor_type,
      p_nmsb_dates                 IN OUT   nmsb_dates_cursor_type
   )
   IS
   BEGIN
      OPEN p_awardinstalmentnmsb_type FOR
         SELECT s.payment_method, 
                scy.start_date,
                scy.session_code,
                CASE
                   WHEN (s.payment_method = 'C')
                      THEN 'H'
                   WHEN (s.payment_method = 'B' AND s.nominee = 'N'
                        )
                      THEN 'B'
                   ELSE 'N'
                END payment_addr,
                sgas.rules_proc_recalc.getstartdateterm
                                    (scy.stud_crse_year_id,
                                     1
                                    ) AS term1startdate,
                CASE
                   WHEN scy.crse_year_no = 1
                      THEN CASE
                             WHEN sgas.nmsb_rules_proc_recalc.doublepayment
                                         (scy.stud_crse_year_id) =
                                                            'Y'
                                THEN 2
                             ELSE 1
                          END
                   ELSE 1
                END doublepayment,
                sgas.rules_proc_recalc.getstudystartterm
                                     (scy.stud_crse_year_id)
                                                           AS studystartterm,
                                                           
                scy.stud_ref_no, scy.latest_crse_ind,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     1
                                    ) AS term1enddate,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     2
                                    ) AS term2enddate,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     3
                                    ) AS term3enddate,
                sgas.rules_proc_recalc.getenddateterm
                                    (scy.stud_crse_year_id,
                                     4
                                    ) AS term4endate                               
           FROM 
                stud s,
                stud_crse_year scy,
                crse_year cy,
                crse_session cs,
                crse c,
                inst i,
                nmsb_spec_arr nsa,
                campus ca
          WHERE 
            scy.stud_ref_no = s.stud_ref_no
            AND scy.crse_year_id = cy.crse_year_id
            AND cy.crse_session_id = cs.crse_session_id
            AND nsa.stud_ref_no(+) = scy.stud_ref_no
            AND nsa.session_code(+) = scy.session_code
            AND cs.crse_id = c.crse_id
            AND scy.scheme_type = 'B'
            AND c.inst_code = i.inst_code
            AND c.maint_campus = ca.campus_id(+)
            AND scy.stud_crse_year_id = p_stud_crse_year_id;

      p_start_dates :=
                   sgas.rules_proc_recalc.get_startdates2022 (p_stud_crse_year_id);
      sgas.nmsb_rules_proc_recalc.get_NMSBPaymentDatesForStud_2022 (p_stud_crse_year_id, p_nmsb_dates);  
      
                                          
   END awardinstalmentsnmsb_2022;   


/* Formatted on 2013/03/13 15:12 (Formatter Plus v4.8.8) */
PROCEDURE updateawardinstalments (p_stud_crse_year_id IN NUMBER)
IS
   l_paid_instal     CHAR;

   CURSOR c_award_id
   IS
      SELECT   b.award_instalment_id,
               CASE
                  WHEN a.amount = 0 OR b.amount = 0
                     THEN 0
                  ELSE FLOOR ((b.amount / a.amount * a.recovered_amount)
                             )
               END recovered_amount,
               CASE
                  WHEN a.amount = 0 OR b.amount = 0
                     THEN 0
                  ELSE (  b.amount
                        - FLOOR (b.amount / a.amount * a.recovered_amount)
                       )
               END net_amount
          FROM award a, award_instalment b
         WHERE a.award_id = b.award_id
           AND a.award_src = 'A'
           AND b.payment_status = 'U'
           AND a.stud_crse_year_id = p_stud_crse_year_id
      ORDER BY award_instalment_id;

   v_award_id        c_award_id%ROWTYPE;

   CURSOR c_paid_award_id
   IS
      SELECT   b.award_instalment_id,
               CASE
                  WHEN a.amount = 0 OR b.amount = 0
                     THEN 0
                  ELSE FLOOR
                         (  (  a.recovered_amount
                             - sgas.nmsb_rules_proc_recalc.get_sum_paid_recovery
                                                                   (a.award_id)
                            )
                          / sgas.nmsb_rules_proc_recalc.get_no_unpaid_instalments
                                                                   (a.award_id)
                         )
               END recovered_amount,
               CASE
                  WHEN a.amount = 0 OR b.amount = 0
                     THEN 0
                  ELSE (  b.amount
                        - FLOOR
                             (  (  a.recovered_amount
                                 - sgas.nmsb_rules_proc_recalc.get_sum_paid_recovery
                                                                   (a.award_id)
                                )
                              / sgas.nmsb_rules_proc_recalc.get_no_unpaid_instalments
                                                                   (a.award_id)
                             )
                       )
               END net_amount
          FROM award a, award_instalment b
         WHERE a.award_id = b.award_id
           AND a.award_src = 'A'
           AND b.payment_status = 'U'
           AND a.stud_crse_year_id = p_stud_crse_year_id
      ORDER BY award_instalment_id;

   v_paid_award_id   c_paid_award_id%ROWTYPE;

   CURSOR c_awards
   IS
      SELECT DISTINCT a.award_id
                 FROM award a, award_instalment b
                WHERE a.award_id = b.award_id
                  AND a.stud_crse_year_id = p_stud_crse_year_id
                  AND b.payment_status = 'U'
                  AND a.award_src = 'A'
                  AND a.recovered_amount > 0;

   v_awards          c_awards%ROWTYPE;

   CURSOR c_paid_awards
   IS
      SELECT DISTINCT a.award_id
                 FROM award a, award_instalment b
                WHERE a.award_id = b.award_id
                  AND a.stud_crse_year_id = p_stud_crse_year_id
                  ---  AND b.payment_status = 'U'
                  AND a.award_src = 'A'
                  AND b.payment_status = 'S'
                  AND b.returned IN ('N', 'A', 'T')
                  AND a.recovered_amount > 0;

   v_paid_awards     c_paid_awards%ROWTYPE;
BEGIN
   l_paid_instal :=
      sgas.nmsb_rules_proc_recalc.get_paid_instalments_nmsb
                                                         (p_stud_crse_year_id);
                                                         

   IF l_paid_instal = 'N'
   THEN
      OPEN c_award_id;

      LOOP
         FETCH c_award_id
          INTO v_award_id;

         EXIT WHEN c_award_id%NOTFOUND;

         
         UPDATE award_instalment
            SET recovered_amount = v_award_id.recovered_amount,
                net_amount = v_award_id.net_amount
          WHERE award_instalment_id = v_award_id.award_instalment_id
            AND payment_status = 'U';
      END LOOP;

      CLOSE c_award_id;
   ELSE
      OPEN c_paid_award_id;

      LOOP
         FETCH c_paid_award_id
          INTO v_paid_award_id;

         EXIT WHEN c_paid_award_id%NOTFOUND;
         

         UPDATE award_instalment
            SET recovered_amount = v_paid_award_id.recovered_amount,
                net_amount = v_paid_award_id.net_amount
          WHERE award_instalment_id = v_paid_award_id.award_instalment_id
            AND payment_status = 'U';
      END LOOP;

      CLOSE c_paid_award_id;
   END IF;

   COMMIT;

   IF l_paid_instal = 'N'
   THEN
      OPEN c_awards;

      LOOP
         FETCH c_awards
          INTO v_awards;

         EXIT WHEN c_awards%NOTFOUND;
         remainderinstalments (v_awards.award_id);
      END LOOP;

      CLOSE c_awards;
   ELSE
      OPEN c_paid_awards;

      LOOP
         FETCH c_paid_awards
          INTO v_paid_awards;

         EXIT WHEN c_paid_awards%NOTFOUND;
         remainderinstalments (v_paid_awards.award_id);
      END LOOP;

      CLOSE c_paid_awards;
   END IF;
END updateawardinstalments;
   

   PROCEDURE remainderinstalments (p_award_id IN NUMBER)
   IS
      l_award_recovered     NUMBER;
      l_award_inst_rec      NUMBER;
      l_remainder           NUMBER;
      l_loop                NUMBER;
      l_remove              NUMBER;
      l_stud_crse_year_id   NUMBER;
      l_paid                NUMBER;

      CURSOR c_award_instalment
      IS
         SELECT   award_instalment_id, recovered_amount, net_amount
             FROM award_instalment
            WHERE award_id = p_award_id AND payment_status = 'U'
         ORDER BY award_instalment_id;

      v_award_instalment    c_award_instalment%ROWTYPE;
   BEGIN
      SELECT recovered_amount, stud_crse_year_id
        INTO l_award_recovered, l_stud_crse_year_id
        FROM award
       WHERE award_id = p_award_id;

      SELECT SUM (recovered_amount)
        INTO l_award_inst_rec
        FROM award_instalment
       WHERE award_id = p_award_id
       AND payment_status IN('S','U')   ---NEW ADDED
       AND returned IN('N','A','T');        ---NEW ADDED

      SELECT COUNT (*)
        INTO l_paid
        FROM award_instalment
       WHERE award_id = p_award_id
       AND payment_status IN('S','U')   --NEW ADDED
       AND returned IN('N','A','T');    --NEW ADDED

      IF l_award_recovered <
            l_award_inst_rec
                ----  WE NEED TO SUBTRACT VALUES FROM AWARD_INSTALMENT RECORDS
      THEN
         l_remainder := l_award_inst_rec - l_award_recovered;

         OPEN c_award_instalment;

         l_loop := 0;
         l_remove := 1;

         LOOP
            FETCH c_award_instalment
             INTO v_award_instalment;

            EXIT WHEN c_award_instalment%NOTFOUND;
            l_loop := l_loop + 1;

            IF     l_loop = 1
               AND sgas.nmsb_rules_proc_recalc.doublepayment
                                                          (l_stud_crse_year_id) =
                                                                           'Y'
               AND l_paid = 0
            THEN
               UPDATE award_instalment
                  SET recovered_amount =
                                       v_award_instalment.recovered_amount - 2,
                      net_amount = v_award_instalment.net_amount + 2
                WHERE award_instalment_id =
                                        v_award_instalment.award_instalment_id;

               l_remainder := l_remainder - 2;
            ELSIF l_remove = 1
            THEN
               UPDATE award_instalment
                  SET recovered_amount =
                                v_award_instalment.recovered_amount - l_remove,
                      net_amount = v_award_instalment.net_amount + l_remove
                WHERE award_instalment_id =
                                        v_award_instalment.award_instalment_id;

               l_remainder := l_remainder - 1;

               IF l_remainder > 0
               THEN
                  l_remove := 1;
               ELSE
                  l_remove := 0;
               END IF;
            END IF;
         END LOOP;

         CLOSE c_award_instalment;
      ELSIF l_award_recovered >
              l_award_inst_rec
                          ---WE NEED TO ADD VALUES TO AWARD_INSTALMENT RECORDS
      THEN
         l_remainder := l_award_recovered - l_award_inst_rec;
         l_loop := 0;
         l_remove := 1;

         OPEN c_award_instalment;

         LOOP
            FETCH c_award_instalment
             INTO v_award_instalment;

            EXIT WHEN c_award_instalment%NOTFOUND;
            l_loop := l_loop + 1;

            IF     l_loop = 1
               AND sgas.nmsb_rules_proc_recalc.doublepayment
                                                          (l_stud_crse_year_id) =
                                                                           'Y'
               AND l_paid = 0 
            THEN
               UPDATE award_instalment
                  SET recovered_amount =
                                    (v_award_instalment.recovered_amount + 2
                                    ),
                      net_amount = (v_award_instalment.net_amount - 2)
                WHERE award_instalment_id =
                                        v_award_instalment.award_instalment_id;

               l_remainder := l_remainder - 2;
               
               
            ELSIF l_remove = 1 AND v_award_instalment.net_amount > 0  ---CHECK ON NET AMOUNT BEING GREATER THAN 0
            THEN
               UPDATE award_instalment
                  SET recovered_amount =
                                    (v_award_instalment.recovered_amount + 1
                                    ),
                      net_amount = (v_award_instalment.net_amount - 1)
                WHERE award_instalment_id =
                                        v_award_instalment.award_instalment_id;

               l_remainder := l_remainder - 1;

               IF l_remainder > 0
               THEN
                  l_remove := 1;
               ELSE
                  l_remove := 0;
               END IF;
               
               
            ELSIF l_remove = 1 AND v_award_instalment.net_amount = 0  ---NEW CONDITION FOR WHEN NET_AMOUNT IS 0 to DO NOTHING
            THEN

               IF l_remainder > 0
               THEN
                  l_remove := 1;
               ELSE
                  l_remove := 0;
               END IF;
               
               
            END IF;
         END LOOP;

         CLOSE c_award_instalment;
      END IF;

      COMMIT;
   END remainderinstalments;

PROCEDURE update_award_table_recovered (p_stud_crse_year_id IN NUMBER)
   IS
   
   l_debt   NUMBER;
   l_paid   NUMBER;
   
     CURSOR c_award_id
      IS

         SELECT stud_award_type, award_id, recovered_amount, net_amount, sgas.rules_proc_recalc.get_paid_SUM_net_Instalment(award_id) as netpaid FROM(
         select a.stud_award_type, a.award_id, a.recovered_amount as recovered_amount, SUM(b.net_amount) AS net_amount
         from award a, award_instalment b, stud_award_type c
         where a.award_id = b.award_id
         and c.stud_award_type = a.stud_award_type
         and c.type NOT IN('MAN','DSA','TRAV')
         and a.stud_crse_year_id = p_stud_crse_year_id
         and B.PAYMENT_STATUS = 'U'
         and C.STUD_AWARD_TYPE <> 'SNCAP'
         and C.STUD_AWARD_TYPE <> 'SNFEE'
         group by a.stud_award_type, a.award_id, a.recovered_amount)
         order by (CASE WHEN stud_award_type = 'SNIE' THEN 0
                        WHEN stud_award_type = 'SNB' THEN 1
                        WHEN stud_award_type = 'SNDA' THEN 2
                        WHEN stud_award_type = 'SNSPA' THEN 3 END);
         
        
      v_award_id        c_award_id%ROWTYPE;
      
BEGIN

    ----GET OVERPAYMENT AMOUNT
    
    l_debt := SGAS.NMSB_RULES_PROC_RECALC.get_debt_amount(p_stud_crse_year_id);

           
    IF l_debt > 0 
    
            THEN --------MAIN LOGIC HERE TO LOOP OVER AWARDS AND REMOVE SOME DEBT IF WE CAN
            
            OPEN c_award_id;

                  LOOP
            FETCH c_award_id
             INTO v_award_id;

            EXIT WHEN c_award_id%NOTFOUND;
            
            IF l_debt > 0 AND v_award_id.net_amount > 0
            
                    THEN
                    
            
                            IF l_debt > (v_award_id.net_amount)
                            
                                THEN 
                                
                                        /*
                                        UPDATE AWARD a
                                            SET a.RECOVERED_AMOUNT = a.RECOVERED_AMOUNT + v_award_id.net_amount, 
                                            A.NET_AMOUNT = 0 +  v_award_id.netpaid
                                            WHERE a.award_id = v_award_id.award_id;
                                            
                                        l_debt := l_debt -  (v_award_id.net_amount - v_award_id.recovered_amount);
                                        */
                                        
                                        
                                      UPDATE AWARD
                                            SET recovered_amount = (recovered_amount + v_award_id.net_amount), 
                                                net_amount = v_award_id.netpaid
                                                WHERE award_id = v_award_id.award_id;
                                                
                                        l_debt := l_debt - v_award_id.net_amount;
                                        
                                        
                                        
                            ELSE 
                            
                                UPDATE AWARD a
                                            SET a.RECOVERED_AMOUNT = a.RECOVERED_AMOUNT + l_debt,
                                            A.NET_AMOUNT = A.NET_AMOUNT - l_debt                                       
                                            WHERE a.award_id = v_award_id.award_id;
                                            
                                            l_debt := 0;
                                            
                            END IF;
            
            ELSE l_debt := l_debt;
            
            END IF;
            


         END LOOP;

         CLOSE c_award_id;
         
         UPDATE stud
         SET snb_overpayment = l_debt
         WHERE stud_ref_no IN(select stud_ref_no from stud_crse_year
                                where stud_crse_year_id = p_stud_crse_year_id);
            
            
    ELSE l_debt := l_debt;
    
    END IF;     
      
      
      
      ----CALL EXISTING PROCEDURE TO DISH OUT REMAINING FUNDS
      
      
      
      
      
      
      
   END update_award_table_recovered;   
   
   
END nmsb_rules_proc_recalc;
/