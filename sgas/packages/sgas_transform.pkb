--Transform package : transfer new COMPLETE_WEB_APPLICATIONS column ESTRANGED_ON_APP to RAW_DATA ESTRANGED
	
	CREATE OR REPLACE PACKAGE BODY SGAS.TRANSFORM
/******************************************************************************
   NAME:       TRANSFORM
   PURPOSE:    Pre-Synchronise called by SHELL SCRIPT :
                synchronise_pre_batch_run_steps.sh

   REVISIONS: 
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/10/2015    C.bolan        Moved to STEPS database as part of 
                                           OLS2016. All '_F' fields removed in
                                           the INSERT to RAW_DATA
                                           
  1.1        11/10/2019     M.Tolmie       Update for Estrangement COS2020-21                                         
   
******************************************************************************/

AS
   -- The following function is used for selecting the UG and PG application data from 
   -- the interface table on the web database and using the application_data_copy_genric function to copy the data to 
   -- the interface table on the STEPS database using a database link 
   
   FUNCTION application_data_copy_steps
      RETURN VARCHAR2
   IS
      --
      v_return_string   VARCHAR2 (1000) := NULL;
      v_web_submitted   VARCHAR2 (20) := NULL;
      v_retval          VARCHAR2 (1000) := NULL;
      v_retvaldeps      VARCHAR2 (1000) := NULL;

      CURSOR c_apps
      IS
         SELECT *
           FROM COMPLETE_WEB_APPLICATIONS@web
          WHERE     NVL (application_type, 'Z') IN ('3', '7', 'B') 
                AND object_id IS NOT NULL;

                
      CURSOR c_dep_apps 
      IS
        SELECT *
            FROM COMPLETE_WEB_APP_DEP@web;
                     

   BEGIN
      --
      DBMS_OUTPUT.put_line (
            '*** DATA TRANSFER of UG,PG and NMSB students to StEPS STARTING AT '
         || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
         || ' ***');
      v_return_string := 'opening cursor';

      --
      v_web_submitted := TO_DATE (SYSDATE, 'dd/mon/yyyy');
      
      FOR STUD_REC_DEP IN c_dep_apps
      LOOP
        BEGIN
        
            --call the function to copy the data from web to StEPS
            v_retvaldeps := copy_dep_app_data(STUD_REC_DEP, 'S');
            
        END;
      END LOOP;

      FOR STUD_REC IN c_apps
      LOOP
         BEGIN
            --
             v_retval := application_data_copy_genric(STUD_REC, 'S');
         --
         END;
      --
      END LOOP;
      
      
    
      --
      DBMS_OUTPUT.put_line (
            '*** DATA TRANSFER of UG, PG and NMSB students to StEPS ENDING AT '
         || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
         || ' ***');
      RETURN ('OK');
   --
   END application_data_copy_steps;

    --The following function is used for copying the application data from 
    --the interface table on the web database to the interface table on    
    --steps database

   FUNCTION application_data_copy_genric (
      stud_rec          IN complete_web_applications@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2
   IS
      v_return_string               VARCHAR2 (1000);
      v_web_submitted               VARCHAR2 (20);
      v_loan_dec_date               VARCHAR2 (20);
      v_scottish_cand               VARCHAR2 (11);
      v_raw_data_id                 VARCHAR2 (44);
      v_batch_id                    VARCHAR2 (16);
      v_envelope_id                 VARCHAR2 (16);
      v_add_dep                     VARCHAR2 (1);
      v_ben_dec_sig                 VARCHAR2 (1);
      v_dob                         VARCHAR2 (20);
      v_dep_dob                     VARCHAR2 (20);
      v_marriage_date               VARCHAR2 (20);
      v_proc                        BOOLEAN;
      v_err_mess                    VARCHAR2 (256);
      v_BEN1_PAYE                   VARCHAR2 (11);
      v_BEN2_PAYE                   VARCHAR2 (11);
      v_BEN1_SELF_EMPLOYMENT        VARCHAR2 (11);
      v_BEN2_SELF_EMPLOYMENT        VARCHAR2 (11);
      v_BEN1_PROPERTY               VARCHAR2 (11);
      v_BEN2_PROPERTY               VARCHAR2 (11);
      v_BEN1_PENSIONS               VARCHAR2 (11);
      v_BEN2_PENSIONS               VARCHAR2 (11);
      v_BEN1_WORKING_TAX_CREDIT     VARCHAR2 (11);                   
      v_BEN2_WORKING_TAX_CREDIT     VARCHAR2 (11);                   
      v_BEN1_BENEFITS               VARCHAR2 (11);
      v_BEN2_BENEFITS               VARCHAR2 (11);
      v_BEN1_NAT_SAVINGS            VARCHAR2 (11);
      v_BEN2_NAT_SAVINGS            VARCHAR2 (11);
      v_BEN1_INTEREST               VARCHAR2 (11);
      v_BEN2_INTEREST               VARCHAR2 (11);
      v_BEN1_DIVIDEND               VARCHAR2 (11);
      v_BEN2_DIVIDEND               VARCHAR2 (11);
      v_BEN1_OTHER_INC              VARCHAR2 (11);
      v_BEN2_OTHER_INC              VARCHAR2 (11);
      v_BEN1_OTHER_DED              VARCHAR2 (11);
      v_BEN2_OTHER_DED              VARCHAR2 (11);
      v_BEN1_AB36                   VARCHAR2 (1);
      v_BEN2_AB36                   VARCHAR2 (1);
      v_BEN1_ADDR1                  VARCHAR2 (65);
      v_BEN2_ADDR1                  VARCHAR2 (65);
      v_BEN1_ADDR2                  VARCHAR2 (65);
      v_BEN2_ADDR2                  VARCHAR2 (65);
      v_BEN1_ADDR3                  VARCHAR2 (32);
      v_BEN2_ADDR3                  VARCHAR2 (32);
      v_BEN1_ADDR4                  VARCHAR2 (32);
      v_BEN2_ADDR4                  VARCHAR2 (32);
      v_BEN1_SHARE_STUDENT          VARCHAR2(1);
      v_BEN2_SHARE_STUDENT          VARCHAR2(1);
      v_BEN1_FORENAMES              VARCHAR2 (25);
      v_BEN2_FORENAMES              VARCHAR2 (25);
      v_BEN1_HEI_CONSENT            VARCHAR2 (1);
      v_BEN2_HEI_CONSENT            VARCHAR2 (1);
      v_BEN1_HOUSE_NO_NAME          VARCHAR2 (32);
      v_BEN2_HOUSE_NO_NAME          VARCHAR2 (32);
      v_BEN1_MAINTENANCE_PAYMENT    VARCHAR2 (1);
      v_BEN2_MAINTENANCE_PAYMENT    VARCHAR2 (1);
      v_BEN1_NI_NO                  VARCHAR2 (9);
      v_BEN2_NI_NO                  VARCHAR2 (9); 
      v_BEN1_OTHER_INC_DETAILS      VARCHAR2 (50);   
      v_BEN2_OTHER_INC_DETAILS      VARCHAR2 (50);
      v_BEN1_POSTCODE               VARCHAR2 (32);
      v_BEN2_POSTCODE               VARCHAR2 (32);
      v_BEN1_REL_TYPE               VARCHAR2 (4);
      v_BEN2_REL_TYPE               VARCHAR2 (4);
      v_BEN1_SURNAME                VARCHAR2 (25);
      v_BEN2_SURNAME                VARCHAR2 (25);
      v_BEN1_TITLE                  VARCHAR2 (8);
      v_BEN2_TITLE                  VARCHAR2 (8);
      v_NO_INCOME_REAS_PERS_1       VARCHAR2 (60);
      v_NO_INCOME_REAS_PERS_2       VARCHAR2 (60);
      v_loan_signature              VARCHAR2 (1);
      l_stud_rec                    complete_web_applications@web%ROWTYPE;
      v_db_name                     VARCHAR2 (25) := NULL;
      v_lpcg                        sas_claims.lpcg@web%TYPE;                                        
      v_amount_1                    NUMBER (9, 2);
      v_amount_2                    NUMBER (9, 2);
      v_amount_3                    NUMBER (9, 2);
      v_amount_4                    NUMBER (9, 2);
      v_amount_5                    NUMBER (9, 2);
      v_amount_6                    NUMBER (9, 2);
      v_source_1                    VARCHAR2 (1);
      v_source_2                    VARCHAR2 (1);
      v_source_3                    VARCHAR2 (1);
      v_source_4                    VARCHAR2 (1);
      v_source_5                    VARCHAR2 (1);
      v_source_6                    VARCHAR2 (1);
      v_psas_pt                     VARCHAR2 (1);
      v_BEN1_EMAIL                  VARCHAR2 (80);
      v_BEN2_EMAIL                  VARCHAR2 (80);
   BEGIN
      
      v_db_name := 'StEPS';
      l_stud_rec := STUD_REC;
      v_proc := TRUE;

      IF (    l_stud_rec.application_Type IN ('3', '7', 'B')
          AND l_stud_rec.object_id IS NOT NULL)
      THEN
         v_proc := TRUE;
         v_batch_id := NULL;
         v_envelope_id := NULL;
         v_scottish_cand := NULL;
         v_err_mess := NULL;
         v_raw_data_id := NULL;
         v_ben_dec_sig := NULL;
         v_add_dep := NULL;
         v_return_string := NULL;
         v_dob := NULL;
         v_dep_dob := NULL;
         v_BEN1_PAYE := NULL;
         v_BEN2_PAYE := NULL;
         v_BEN1_SELF_EMPLOYMENT := NULL;
         v_BEN2_SELF_EMPLOYMENT := NULL;
         v_BEN1_PROPERTY := NULL;
         v_BEN2_PROPERTY := NULL;
         v_BEN1_PENSIONS := NULL;
         v_BEN2_PENSIONS := NULL;
         v_BEN1_WORKING_TAX_CREDIT := NULL;                          
         v_BEN2_WORKING_TAX_CREDIT := NULL;                          
         v_BEN1_BENEFITS := NULL;
         v_BEN2_BENEFITS := NULL;
         v_BEN1_NAT_SAVINGS := NULL;
         v_BEN2_NAT_SAVINGS := NULL;
         v_BEN1_INTEREST := NULL;
         v_BEN2_INTEREST := NULL;
         v_BEN1_DIVIDEND := NULL;
         v_BEN2_DIVIDEND := NULL;
         v_BEN1_OTHER_INC := NULL;
         v_BEN2_OTHER_INC := NULL;
         v_BEN1_OTHER_DED := NULL;
         v_BEN2_OTHER_DED := NULL;
         v_marriage_date := NULL;
         v_loan_dec_date := NULL;
         v_loan_signature := NULL;
         v_lpcg := NULL;                          
         
                               
         --  Get eistream record
         /*
         v_return_string := 'getting EIStream record from EDM REF database';
         v_proc :=
            get_eistream_record (l_stud_rec.stud_ref_no,
                                 l_stud_rec.object_id,
                                 v_batch_id,
                                 v_envelope_id,
                                 v_err_mess); 
        
         --
         IF NOT v_proc
         THEN
            DBMS_OUTPUT.put_line (
                  'Error '
               || v_err_mess
               || ' while '
               || v_return_string
               || ' for student '
               || TO_CHAR (l_stud_rec.stud_ref_no));
         END IF;
         */

         -- Get raw data id

         IF v_proc
         THEN
            v_return_string :=
               'getting raw data ID from the StEPS database ';
            v_proc :=
               get_raw_data_id (l_stud_rec.stud_ref_no,
                                v_raw_data_id,
                                v_err_mess,
                                which_db_to_use,
                                l_stud_rec.application_Type);

            --
            IF NOT v_proc
            THEN
               DBMS_OUTPUT.put_line (
                     'Error '
                  || v_err_mess
                  || ' while '
                  || v_return_string
                  || ' for student '
                  || TO_CHAR (l_stud_rec.stud_ref_no));
            END IF;
         END IF;

         

         -- Reformatting dep_dob so that it will go through pre-transform
         IF v_proc
         THEN
            v_return_string := 'reformatting dep_dob ';

            IF l_stud_rec.dep_dob IS NOT NULL
            THEN
               v_proc :=
                  reformat_date_for_rawdata (l_stud_rec.dep_dob,
                                             v_dep_dob,
                                             v_err_mess);

               IF NOT v_proc
               THEN
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
               END IF;
            END IF;
         END IF;         
         
         
         -- Reformatting dob so that it will go through pre-transform
         IF v_proc
         THEN
            v_return_string := 'reformatting dob ';

            IF l_stud_rec.dob IS NOT NULL
            THEN
               v_proc :=
                  reformat_date_for_rawdata (l_stud_rec.dob,
                                             v_dob,
                                             v_err_mess);

               IF NOT v_proc
               THEN
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
               END IF;
            END IF;
         END IF;

         -- Reformatting web submitted so that it populates raw data to get through pre-transform
         IF v_proc
         THEN
            v_return_string := 'reformatting web submitted date ';

            IF l_stud_rec.web_submitted IS NOT NULL
            THEN
               v_proc :=
                  reformat_date_for_rawdata (l_stud_rec.web_submitted,
                                             v_web_submitted,
                                             v_err_mess);

               IF NOT v_proc
               THEN
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
               END IF;
            END IF;
         END IF;

         -- Max loan requested
         IF v_proc
         THEN
            IF     NVL (l_stud_rec.max_loan_requested, 'N') = 'N'
               AND NVL (l_stud_rec.loan_request, 0) = 0
               AND NVL (l_stud_rec.max_fee_loan, 'N') = 'N'
               AND                                   -- JM add fee loan checks
                  NVL (l_stud_rec.fee_loan_amount, 0) = 0
            THEN                                     -- JM add fee loan checks
               --
               v_loan_dec_date := NULL;
               v_loan_signature := NULL;
            ELSE
               v_loan_dec_date := v_web_submitted;
               v_loan_signature := 'Y';
            END IF;
         END IF;

         --
         -- Reformatting web submitted so that it populates raw data to get through pre-transform
         IF v_proc
         THEN
            v_return_string := 'reformatting marriage submitted date ';

            IF l_stud_rec.marriage_date IS NOT NULL
            THEN
               v_proc :=
                  reformat_date_for_rawdata (l_stud_rec.marriage_date,
                                             v_marriage_date,
                                             v_err_mess);

               IF NOT v_proc
               THEN
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
               END IF;
            END IF;
         END IF;

         --
         --
         IF v_proc
         THEN
            v_return_string := 'reformatting benefactor currency fields ';

            BEGIN
               v_BEN1_PAYE := format_currency_rec1 (l_stud_rec.BEN1_PAYE);
               v_BEN2_PAYE := format_currency_rec1 (l_stud_rec.BEN2_PAYE);
               v_BEN1_SELF_EMPLOYMENT := format_currency_rec1 (l_stud_rec.BEN1_SELF_EMPLOYMENT);
               v_BEN2_SELF_EMPLOYMENT := format_currency_rec1 (l_stud_rec.BEN2_SELF_EMPLOYMENT);
               v_BEN1_PROPERTY := format_currency_rec1 (l_stud_rec.BEN1_PROPERTY);
               v_BEN2_PROPERTY := format_currency_rec1 (l_stud_rec.BEN2_PROPERTY);
               v_BEN1_PENSIONS := format_currency_rec1 (l_stud_rec.BEN1_PENSIONS);
               v_BEN2_PENSIONS := format_currency_rec1 (l_stud_rec.BEN2_PENSIONS);
               v_BEN1_WORKING_TAX_CREDIT := format_currency_rec1 (l_stud_rec.BEN1_WORKING_TAX_CREDIT); 
               v_BEN2_WORKING_TAX_CREDIT := format_currency_rec1 (l_stud_rec.BEN2_WORKING_TAX_CREDIT); 
               v_BEN1_BENEFITS := format_currency_rec1 (l_stud_rec.BEN1_BENEFITS);
               v_BEN2_BENEFITS := format_currency_rec1 (l_stud_rec.BEN2_BENEFITS);
               v_BEN1_NAT_SAVINGS := format_currency_rec1 (l_stud_rec.BEN1_NAT_SAVINGS);
               v_BEN2_NAT_SAVINGS := format_currency_rec1 (l_stud_rec.BEN2_NAT_SAVINGS);
               v_BEN1_INTEREST := format_currency_rec1 (l_stud_rec.BEN1_INTEREST);
               v_BEN2_INTEREST := format_currency_rec1 (l_stud_rec.BEN2_INTEREST);
               v_BEN1_DIVIDEND := format_currency_rec1 (l_stud_rec.BEN1_DIVIDEND);
               v_BEN2_DIVIDEND := format_currency_rec1 (l_stud_rec.BEN2_DIVIDEND);
               v_BEN1_OTHER_INC := format_currency_rec1 (l_stud_rec.BEN1_OTHER_INC);
               v_BEN2_OTHER_INC := format_currency_rec1 (l_stud_rec.BEN2_OTHER_INC);
               v_BEN1_OTHER_DED := format_currency_rec1 (l_stud_rec.BEN1_OTHER_DED);
               v_BEN2_OTHER_DED := format_currency_rec1 (l_stud_rec.BEN2_OTHER_DED);
               v_BEN1_AB36 := l_stud_rec.BEN1_AB36;                
               v_BEN2_AB36  := l_stud_rec.BEN2_AB36;           
               v_BEN1_ADDR1 := l_stud_rec.BEN1_ADDR1;                 
               v_BEN2_ADDR1  := l_stud_rec.BEN2_ADDR1;               
               v_BEN1_ADDR2 := l_stud_rec.BEN1_ADDR2;                
               v_BEN2_ADDR2  := l_stud_rec.BEN2_ADDR2;                
               v_BEN1_ADDR3 := l_stud_rec.BEN1_ADDR3;             
               v_BEN2_ADDR3    := l_stud_rec.BEN2_ADDR3;             
               v_BEN1_ADDR4  := l_stud_rec.BEN1_ADDR4;          
               v_BEN2_ADDR4   := l_stud_rec.BEN2_ADDR4;           
               v_BEN1_SHARE_STUDENT  := l_stud_rec.BEN1_CONSENT_TO_SHARE_STUDENT;
               v_BEN2_SHARE_STUDENT := l_stud_rec.BEN2_CONSENT_TO_SHARE_STUDENT;
               v_BEN1_FORENAMES   := l_stud_rec.BEN1_FORENAMES;          
               v_BEN2_FORENAMES  := l_stud_rec.BEN2_FORENAMES;          
               v_BEN1_HEI_CONSENT  := l_stud_rec.BEN1_HEI_CONSENT;          
               v_BEN2_HEI_CONSENT  := l_stud_rec.BEN2_HEI_CONSENT;         
               v_BEN1_HOUSE_NO_NAME  := l_stud_rec.BEN1_HOUSE_NO_NAME;         
               v_BEN2_HOUSE_NO_NAME := l_stud_rec.BEN2_HOUSE_NO_NAME;         
               v_BEN1_MAINTENANCE_PAYMENT := l_stud_rec.BEN1_MAINTENANCE_PAYMENT;   
               v_BEN2_MAINTENANCE_PAYMENT  := l_stud_rec.BEN2_MAINTENANCE_PAYMENT; 
               v_BEN1_NI_NO  := l_stud_rec.BEN1_NI_NO;                
               v_BEN2_NI_NO := l_stud_rec.BEN2_NI_NO;                
               v_BEN1_OTHER_INC_DETAILS   := l_stud_rec.BEN1_OTHER_INC_DETAILS;  
               v_BEN2_OTHER_INC_DETAILS   := l_stud_rec.BEN2_OTHER_INC_DETAILS;  
               v_BEN1_POSTCODE  := l_stud_rec.BEN1_POSTCODE;            
               v_BEN2_POSTCODE  := l_stud_rec.BEN2_POSTCODE;          
               v_BEN1_REL_TYPE  := l_stud_rec.BEN1_REL_TYPE;            
               v_BEN2_REL_TYPE  := l_stud_rec.BEN2_REL_TYPE;          
               v_BEN1_SURNAME  := l_stud_rec.BEN1_SURNAME;             
               v_BEN2_SURNAME  := l_stud_rec.BEN2_SURNAME;           
               v_BEN1_TITLE    := l_stud_rec.BEN1_TITLE;               
               v_BEN2_TITLE  := l_stud_rec.BEN2_TITLE;
               v_NO_INCOME_REAS_PERS_1 := l_stud_rec.NO_INCOME_REAS_PERS_1; 
               v_NO_INCOME_REAS_PERS_2 := l_stud_rec.NO_INCOME_REAS_PERS_2;
               v_BEN1_EMAIL := l_stud_rec.BEN1_EMAIL_ADDR;
               v_BEN2_EMAIL := l_stud_rec.BEN2_EMAIL_ADDR;

            EXCEPTION
               WHEN OTHERS
               THEN
                  v_proc := FALSE;
                  v_err_mess := TO_CHAR (SQLCODE) || ' ' || TO_CHAR (SQLERRM);
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
            END;
         END IF;


       
         v_return_string := 'setting student income amounts and source';
         v_amount_1 := NVL(format_currency_rec1 (l_stud_rec.amount_1), 0);
         v_amount_2 := format_currency_rec1 (l_stud_rec.amount_2);
         v_amount_3 := format_currency_rec1 (l_stud_rec.amount_3);
         v_amount_4 := format_currency_rec1 (l_stud_rec.amount_4);
         v_amount_5 := format_currency_rec1 (l_stud_rec.amount_5);
         v_amount_6 := format_currency_rec1 (l_stud_rec.amount_6);
         v_source_1 := l_stud_rec.source_1;
         v_source_2 := l_stud_rec.source_2;
         v_source_3 := l_stud_rec.source_3;
         v_source_4 := l_stud_rec.source_4;
         v_source_5 := l_stud_rec.source_5;
         v_source_6 := l_stud_rec.source_6;
         
         
         
         --set BEN_DEC_SIG 
           IF l_stud_rec.ben1_surname IS NOT NULL THEN
                 v_ben_dec_sig := 'Y';
              ELSE
                 v_ben_dec_sig := 'N';
           END IF;
           
         --set ADD_DEP_DETAILS
           IF l_stud_rec.DEP_FORENAMES IS NOT NULL THEN
                v_add_dep := 'Y';
              ELSE
                v_add_dep := 'N';
           END IF;    
           
            --reformat IS_COURSE_FULL_TIME invert the answer so it behaves properly in STEPS
           CASE 
            WHEN l_stud_rec.IS_COURSE_FULL_TIME = 'Y' THEN v_psas_pt := 'N';
            WHEN  l_stud_rec.IS_COURSE_FULL_TIME = 'N' THEN v_psas_pt := 'Y';
            ELSE v_psas_pt := 'Y';
           END CASE;
           
           
           
           
           --reformat the benefactors if only BEN2 is present
           IF l_stud_rec.BEN1_SURNAME is null AND l_stud_rec.BEN2_SURNAME is not null 
            THEN            
                  
                      v_BEN1_PAYE := l_stud_rec.BEN2_PAYE;                
                      v_BEN2_PAYE := null;
                      v_BEN1_SELF_EMPLOYMENT := l_stud_rec.BEN2_SELF_EMPLOYMENT;
                      v_BEN2_SELF_EMPLOYMENT:= null;
                      v_BEN1_PROPERTY := l_stud_rec.BEN2_PROPERTY;        
                      v_BEN2_PROPERTY:= null;        
                      v_BEN1_PENSIONS := l_stud_rec.BEN2_PENSIONS;          
                      v_BEN2_PENSIONS := null;       
                      v_BEN1_WORKING_TAX_CREDIT := l_stud_rec.BEN2_WORKING_TAX_CREDIT;   
                      v_BEN2_WORKING_TAX_CREDIT := null;
                      v_BEN1_BENEFITS := l_stud_rec.BEN2_BENEFITS;           
                      v_BEN2_BENEFITS := null;          
                      v_BEN1_NAT_SAVINGS := l_stud_rec.BEN2_NAT_SAVINGS;    
                      v_BEN2_NAT_SAVINGS := null;       
                      v_BEN1_INTEREST  := l_stud_rec.BEN2_INTEREST;           
                      v_BEN2_INTEREST  := null;         
                      v_BEN1_DIVIDEND  := l_stud_rec.BEN2_DIVIDEND;              
                      v_BEN2_DIVIDEND:= null;           
                      v_BEN1_OTHER_INC  := l_stud_rec.BEN2_OTHER_INC;          
                      v_BEN2_OTHER_INC:= null;           
                      v_BEN1_OTHER_DED := l_stud_rec.BEN2_OTHER_DED;            
                      v_BEN2_OTHER_DED := null;   
                      v_BEN1_AB36 := l_stud_rec.BEN2_AB36;                
                      v_BEN2_AB36  := l_stud_rec.BEN1_AB36;  --must swap these            
                      v_BEN1_ADDR1 := l_stud_rec.BEN2_ADDR1;                 
                      v_BEN2_ADDR1  := null;               
                      v_BEN1_ADDR2 := l_stud_rec.BEN2_ADDR2;                
                      v_BEN2_ADDR2  := null;                
                      v_BEN1_ADDR3 := l_stud_rec.BEN2_ADDR3;             
                      v_BEN2_ADDR3    := null;             
                      v_BEN1_ADDR4  := l_stud_rec.BEN2_ADDR4;          
                      v_BEN2_ADDR4   := null;           
                      v_BEN1_SHARE_STUDENT  := l_stud_rec.BEN2_CONSENT_TO_SHARE_STUDENT;
                      v_BEN2_SHARE_STUDENT := null;
                      v_BEN1_FORENAMES   := l_stud_rec.BEN2_FORENAMES;          
                      v_BEN2_FORENAMES  := null;          
                      v_BEN1_HEI_CONSENT  := l_stud_rec.BEN2_HEI_CONSENT;          
                      v_BEN2_HEI_CONSENT  := null;         
                      v_BEN1_HOUSE_NO_NAME  := l_stud_rec.BEN2_HOUSE_NO_NAME;         
                      v_BEN2_HOUSE_NO_NAME := null;         
                      v_BEN1_MAINTENANCE_PAYMENT := l_stud_rec.BEN2_MAINTENANCE_PAYMENT;   
                      v_BEN2_MAINTENANCE_PAYMENT  := null; 
                      v_BEN1_NI_NO  := l_stud_rec.BEN2_NI_NO;                
                      v_BEN2_NI_NO := null;                
                      v_BEN1_OTHER_INC_DETAILS   := l_stud_rec.BEN2_OTHER_INC_DETAILS;  
                      v_BEN2_OTHER_INC_DETAILS   := null;  
                      v_BEN1_POSTCODE  := l_stud_rec.BEN2_POSTCODE;            
                      v_BEN2_POSTCODE  := null;          
                      v_BEN1_REL_TYPE  := l_stud_rec.BEN2_REL_TYPE;            
                      v_BEN2_REL_TYPE  := null;          
                      v_BEN1_SURNAME  := l_stud_rec.BEN2_SURNAME;             
                      v_BEN2_SURNAME  := null;           
                      v_BEN1_TITLE    := l_stud_rec.BEN2_TITLE;               
                      v_BEN2_TITLE  := null;
                      v_NO_INCOME_REAS_PERS_1 := l_stud_rec.NO_INCOME_REAS_PERS_2; 
                      v_NO_INCOME_REAS_PERS_2 := null;
                      v_BEN1_EMAIL := l_stud_rec.BEN2_EMAIL_ADDR;
                      v_BEN2_EMAIL := null;
              END IF;            

        
  
            

         

            BEGIN
               v_return_string := 'inserting into RAW_DATA in StEPS';

               --as part of the OLS201
               INSERT INTO EDM.RAW_DATA -- CHANGED HERE TO edm.RAW_DATA OLS2016
                                        (OBJECT_ID,                     --OLS2016--------------->1      1                      
                                         RAW_DATA_ID,                   --OLS2016--------------->2      2                
                                         BATCH_ID,  --get_eistream_record OLS2016--------------->3      3
                                         ENVELOPE_ID,--get_eistream_recordOLS2016--------------->4      4
                                         STUD_REF_NO,                   --OLS2016--------------->6      5
                                         SCOTTISH_CAND,                 --OLS2016--------------->7      6
                                         NI_NO,                         --OLS2016--------------->8      7
                                         TITLE,                         --OLS2016--------------->10     8
                                         SURNAME,                       --OLS2016--------------->11     9
                                         FORENAMES,                     --OLS2016--------------->12     10
                                         DOB,                           --OLS2016--------------->15     11
                                         DISTRICT_BIRTH_CERT_ISSUED,    --OLS2016--------------->17     12
                                         SEX,                           --OLS2016--------------->18     13
                                         MARITAL_STATUS,                --OLS2016--------------->19     14
                                         MARRIAGE_DATE,                 --OLS2016--------------->20     15
                                         HOME_HOUSE_NO_NAME,            --OLS2016--------------->21     16
                                         HOME_POST_CODE,                --OLS2016--------------->22     17
                                         HOME_ADDR_L1,                  --OLS2016--------------->23     18
                                         HOME_ADDR_L2,                  --OLS2016--------------->24     19
                                         HOME_ADDR_L3,                  --OLS2016--------------->25     20
                                         HOME_ADDR_L4,                  --OLS2016--------------->26     21
                                         HOME_TELE_NO,                  --OLS2016--------------->27     22  
                                         SORT_CODE,                     --OLS2016--------------->28     23         
                                         ACCOUNT_NO,                    --OLS2016--------------->30     24
                                         BIRTH_COUNTRY_CODE,            --OLS2016--------------->32     25
                                         NATION_COUNTRY_CODE,           --OLS2016--------------->34     26
                                         RESIDENCE_COUNTRY_CODE,        --OLS2016--------------->36     27
                                         INST_NAME,                     --OLS2016--------------->38     28
                                         INST_CODE,                     --OLS2016--------------->40     29
                                         CRSE_NAME,                     --OLS2016--------------->41     30
                                         CRSE_CODE,                     --OLS2016--------------->43     31
                                         CRSE_YEAR_NO,                  --OLS2016--------------->44     32
                                         FIRST_DEP_SURNAME,             --OLS2016--------------->45     33         
                                         FIRST_DEP_FORENAMES,           --OLS2016--------------->46     34
                                         FIRST_DEP_DOB,                 --OLS2016--------------->47     35
                                         FIRST_DEP_REL_TYPE,            --OLS2016--------------->49     36
                                         FIRST_DEP_INCOME_AMOUNT_1,     --OLS2016--------------->51     37                                     
                                         ADD_DEP_DETAILS,               --OLS2016--------------->96     38
                                         LPCG,                          --OLS2016--------------->97     39
                                         APP_FORM_SIG,                  --OLS2016--------------->112    40  
                                         MAX_LOAN_REQUESTED,            --OLS2016--------------->113    41
                                         LOAN_REQUEST,                  --OLS2016--------------->114    42
                                         CONT1_NAME,                    --OLS2016--------------->118    43
                                         CONT1_REL_CODE,                --OLS2016--------------->119    44
                                         CONT1_POSTCODE,                --OLS2016--------------->121    45
                                         CONT1_ADDR1,                   --OLS2016--------------->122    46
                                         CONT1_ADDR2,                   --OLS2016--------------->123    47
                                         CONT1_ADDR3,                   --OLS2016--------------->124    48
                                         CONT1_TEL_NO,                  --OLS2016--------------->126    49
                                         CONT2_NAME,                    --OLS2016--------------->129    50
                                         CONT2_POSTCODE,                --OLS2016--------------->131    51
                                         CONT2_ADDR1,                   --OLS2016--------------->132    52
                                         CONT2_ADDR2,                   --OLS2016--------------->133    53
                                         CONT2_ADDR3,                   --OLS2016--------------->134    54
                                         CONT2_TEL_NO,                  --OLS2016--------------->136    55
                                         TERM_HOUSE_NO_NAME,            --OLS2016--------------->138    56
                                         TERM_POST_CODE,                --OLS2016--------------->139    57
                                         TERM_ADDR_L1,                  --OLS2016--------------->140    58
                                         TERM_ADDR_L2,                  --OLS2016--------------->141    59
                                         TERM_ADDR_L3,                  --OLS2016--------------->142    60
                                         TERM_ADDR_L4,                  --OLS2016--------------->143    61
                                         SLC_CORRES_DEST,               --OLS2016--------------->144    62
                                         LOAN_SIGNATURE,                --OLS2016--------------->145    63
                                         LOAN_DECLARATION_DATE,         --OLS2016--------------->146    64
                                         BEN1_NI_NO,                    --OLS2016--------------->148    65
                                         BEN1_TITLE,                    --OLS2016--------------->150    66
                                         BEN1_SURNAME,                  --OLS2016--------------->151    67
                                         BEN1_FORENAMES,                --OLS2016--------------->152    68
                                         BEN1_REL_TYPE,                 --OLS2016--------------->153    69  
                                         BEN1_HOUSE_NO_NAME,            --OLS2016--------------->154    70
                                         BEN1_POSTCODE,                 --OLS2016--------------->155    71  
                                         BEN1_ADDR1,                    --OLS2016--------------->156    72
                                         BEN1_ADDR2,                    --OLS2016--------------->157    73  
                                         BEN1_ADDR3,                    --OLS2016--------------->158    74
                                         BEN1_ADDR4,                    --OLS2016--------------->159    75
                                         BEN2_NI_NO,                    --OLS2016--------------->161    76
                                         BEN2_TITLE,                    --OLS2016--------------->163    77
                                         BEN2_SURNAME,                  --OLS2016--------------->164    78
                                         BEN2_FORENAMES,                --OLS2016--------------->165    79
                                         BEN2_REL_TYPE,                 --OLS2016--------------->166    80
                                         BEN2_HOUSE_NO_NAME,            --OLS2016--------------->167    81
                                         BEN2_POSTCODE,                 --OLS2016--------------->168    82
                                         BEN2_ADDR1,                    --OLS2016--------------->169    83
                                         BEN2_ADDR2,                    --OLS2016--------------->170    84
                                         BEN2_ADDR3,                    --OLS2016--------------->171    85
                                         BEN2_ADDR4,                    --OLS2016--------------->172    86
                                         JA_CASE,                       --OLS2016--------------->174    87
                                         BEN1_PAYE,                     --OLS2016--------------->175    88
                                         BEN2_PAYE,                     --OLS2016--------------->177    89  
                                         BEN1_SELF_EMPLOYMENT,          --OLS2016--------------->179    90
                                         BEN2_SELF_EMPLOYMENT,          --OLS2016--------------->181    91
                                         BEN1_PROPERTY,                 --OLS2016--------------->183    92
                                         BEN2_PROPERTY,                 --OLS2016--------------->185    93
                                         BEN1_PENSIONS,                 --OLS2016--------------->187    94
                                         BEN2_PENSIONS,                 --OLS2016--------------->189    95
                                         BEN1_BENEFITS,                 --OLS2016--------------->191    96
                                         BEN2_BENEFITS,                 --OLS2016--------------->193    97
                                         BEN1_NAT_SAVINGS,              --OLS2016--------------->195    98
                                         BEN2_NAT_SAVINGS,              --OLS2016--------------->197    99
                                         BEN1_INTEREST,                 --OLS2016--------------->199    100
                                         BEN2_INTEREST,                 --OLS2016--------------->201    101
                                         BEN1_DIVIDEND,                 --OLS2016--------------->203    102
                                         BEN2_DIVIDEND,                 --OLS2016--------------->205    103
                                         BEN1_OTHER_INC,                --OLS2016--------------->207    104
                                         BEN2_OTHER_INC,                --OLS2016--------------->209    105
                                         BEN1_OTHER_DED,                --OLS2016--------------->219    106
                                         BEN2_OTHER_DED,                --OLS2016--------------->221    107
                                         BEN_DEC_SIG,                   --OLS2016--------------->230    108
                                         DATE_APPLIC_RECEIVED,          --  v_web_submitted----->239    109
                                         EMP_LOGIN,                     --  hardcode to 'WEB'--->240    110
                                         APP_FORM_SIG_DATE,             --  hardcode to sysdate->241    111                     
                                         MOBILE_TEL_NO,                 --OLS2016--------------->246    112
                                         EMAIL_ADDR,                    --OLS2016--------------->250    113
                                         WEB_USER_ID,                   --OLS2016--------------->251    114
                                         BANK_VALIDATE,                 --OLS2016--------------->252    115
                                         IN_EDUC_SINCE_LEAVE_SCHOOL,    --OLS2016--------------->262    116
                                         STUDY_ABROAD,                  --OLS2016--------------->266    117
                                         PLACEMENT_YEAR,                --OLS2016--------------->268    118
                                         EU_STUDENT,                    --OLS2016--------------->296    119
                                         NOS_YEARS_COURSE_TAKES,        --OLS2016--------------->297    120
                                         ORD_RES_SCOTLAND_WEB,          --OLS2016--------------->298    121
                                         ORD_RES_UK_WEB,                --OLS2016--------------->299    122
                                         MAX_FEE_LOAN,                  --OLS2016--------------->300    123
                                         FEE_LOAN_AMOUNT,               --OLS2016--------------->301    124     
                                         DEP_GRANT,                     --OLS2016--------------->303    125
                                         LPG,                           --OLS2016--------------->304    126
                                         SKILLS_DEV_DATA_SHARE,         --OLS2016--------------->312    127                    
                                         BEN1_WORKING_TAX_CREDIT,       --OLS2016--------------->320    128
                                         BEN1_MAINTENANCE_PAYMENT,      --OLS2016--------------->326    129
                                         BEN2_WORKING_TAX_CREDIT,       --OLS2016--------------->327    130 
                                         BEN2_MAINTENANCE_PAYMENT,      --OLS2016--------------->333    131
                                         STUD_INCOME,                   --OLS2016--------------->334    132
                                         TUITION_FEES,                  --OLS2016--------------->342    133
                                         BURSARY_ONLY,                  --OLS2016--------------->344    134        
                                         YSB,                           --OLS2016--------------->347    135
                                         INSCOT_YEAR,                   --OLS2016--------------->352    136
                                         CONSENT_FROM_STUDENT,          --OLS2016--------------->353    137
                                         STUD_INCOME_AMT1,              --OLS2016--------------->357    138
                                         STUD_INCOME_TYPE1,             --OLS2016--------------->358    139
                                         STUD_INCOME_AMT2,              --OLS2016--------------->359    140
                                         STUD_INCOME_TYPE2,             --OLS2016--------------->360    141
                                         STUD_INCOME_AMT3,              --OLS2016--------------->361    142    
                                         STUD_INCOME_TYPE3,             --OLS2016--------------->362    143
                                         STUD_INCOME_AMT4,              --OLS2016--------------->363    144
                                         STUD_INCOME_TYPE4,             --OLS2016--------------->364    145
                                         STUD_INCOME_AMT5,              --OLS2016--------------->365    146
                                         STUD_INCOME_TYPE5,             --OLS2016--------------->366    147
                                         STUD_INCOME_AMT6,              --OLS2016--------------->367    148
                                         STUD_INCOME_TYPE6,             --OLS2016--------------->368    149
                                         REASON_NO_INCOME_BEN1,         --OLS2016--------------->369    150
                                         REASON_NO_INCOME_BEN2,         --OLS2016--------------->370    151
                                         HEI_CONSENT,                   --OLS2016--------------->371    152
                                         CARE_LEAVER,                   --OLS2016--------------->372    153
                                         DUAL_NATIONALITY,              --OLS2016--------------->373    154
                                         --**********************************NEW FIELDS******************************
                                         BEN1_HEI_CONSENT,              --OLS2016--------------->374    155  --HEBS
                                         BEN2_HEI_CONSENT,              --OLS2016--------------->375    156  --HEBS
                                         BEN1_AB36,                     --OLS2016--------------->376    157
                                         BEN2_AB36,                     --OLS2016--------------->377    158
                                         ONLY_ONE_BEN,                  --OLS2016--------------->378    159
                                         PSAS_PT,                       --OLS2016--------------->380    160
                                         REASON_FOR_ONE_BEN_ID,         --OLS2016--------------->379    161       
                                         BEN1_OTHER_INC_DETAILS,        --OLS2016--------------->381    162
                                         BEN2_OTHER_INC_DETAILS,        --OLS2016--------------->382    163
                                         CONT1_CONSENT,                 --OLS2016--------------->383    164
                                         CONT2_CONSENT,                 --OLS2016--------------->384    165
                                         INTERRUPTION_FROM_STUDY,       --OLS2016--------------->385    166
                                         IS_INDEPENDENT,                --OLS2016--------------->386    167
                                         RESIDENCY_CATEGORY,            --OLS2016--------------->387    168
                                         BEN1_CONSENT_TO_SHARE_STUDENT, --OLS2016--------------->388    169   --SHARE INCOME
                                         BEN2_CONSENT_TO_SHARE_STUDENT, ---OLS2016--------------->389    170   --SHARE INCOME
                                         INDEPENDENT,                   --CR223 J.Penman 061217
                                         ORPHAN,                        --CR223 J.Penman 061217
                                         OVER_25,                       --CR223 J.Penman 061217  
                                         CARE_EXP_FOSTER,               --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_RES,                  --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_KINSHIP_LA,           --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_KINSHIP_NO_LA,        --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_HOME,                 --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_OTHER,                --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_OTHER_DETAILS,        --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_START_AGE,            --SFD2 CARE EXPERIENCED 12/12/2017
                                         CARE_EXP_END_AGE,              --SFD2 CARE EXPERIENCED 12/12/2017
                                         START_DATE_ABROAD,              --SFD2 ABROAD DATES CR160 J Penman 01/02/2018         
                                         END_DATE_ABROAD,               --SFD2 ABROAD DATES CR160 J Penman 01/02/2018
                                         PG_ED_PSYCH_GRANT,                --SFD3 PG EDUCATIONAL PSYCHOLOGY
                                         PG_ED_PSYCH_FEES,                --SFD3 PG EDUCATIONAL PSYCHOLOGY
                                         PG_ED_PSYCH_QEPS,                --SFD3 PG EDUCATIONAL PSYCHOLOGY
                                         PG_ED_PSYCH_DECLARATION,        --SFD3 PG EDUCATIONAL PSYCHOLOGY
                                         BEN1_EMAIL_ADDR,               --SFD3 GDPR
                                         BEN2_EMAIL_ADDR,                --SFD3GDPR
                                         ESTRANGED                       --COS 2020/2021 Estrangement
                                         
                                         
                                         )
                    VALUES (
                              UPPER(TO_CHAR (l_stud_rec.OBJECT_ID)), --    OBJECT_ID,                                  -->1        1
                              UPPER(TO_CHAR (v_raw_data_id)),      --    RAW_DATA_ID,                                  -->2        2
                              UPPER(TO_CHAR (v_batch_id)),            --    BATCH_ID,                                  -->3        3
                              UPPER(TO_CHAR (v_envelope_id)),      --    ENVELOPE_ID,                                  -->4        4
                              UPPER(TO_CHAR (l_stud_rec.STUD_REF_NO)), --    STUD_REF_NO,                              -->6        5
                              UPPER(TO_CHAR (v_scottish_cand)),  --    SCOTTISH_CAND,                                  -->7        6
                              UPPER(TO_CHAR (l_stud_rec.NI_NO)),         --    NI_NO,                                  -->8        7
                              UPPER(TO_CHAR (l_stud_rec.TITLE)),         --    TITLE,                                  -->10       8
                              UPPER(TO_CHAR (l_stud_rec.SURNAME)),     --    SURNAME,                                  -->11       9
                              UPPER(TO_CHAR (l_stud_rec.FORENAMES)), --    FORENAMES,                                  -->12       10
                              UPPER(TO_CHAR (v_dob)),                      --    DOB,                                  -->15       11    
                              UPPER(TO_CHAR (l_stud_rec.BIRTH_DISTRICT)), --    DISTRICT_BIRTH_CERT_ISSUED,            -->17       12
                              UPPER(TO_CHAR (l_stud_rec.SEX)),             --    SEX,                                  -->18       13
                              UPPER(TO_CHAR (l_stud_rec.MARITAL_STATUS)), --    MARITAL_STATUS,                        -->19       14
                              UPPER(TO_CHAR (v_marriage_date)),  --    MARRIAGE_DATE,                                  -->20       15
                              UPPER(TO_CHAR (l_stud_rec.HOME_HOUSE_NO_NAME)), --    HOME_HOUSE_NO_NAME,                -->21       16
                              UPPER(TO_CHAR (l_stud_rec.HOME_POST_CODE)), --    HOME_POST_CODE,                        -->22       17
                              UPPER(TO_CHAR (l_stud_rec.HOME_ADDR_L1)), --    HOME_ADDR_L1,                            -->23       18
                              UPPER(TO_CHAR (l_stud_rec.HOME_ADDR_L2)), --    HOME_ADDR_L2,                            -->24       19
                              UPPER(TO_CHAR (l_stud_rec.HOME_ADDR_L3)), --    HOME_ADDR_L3,                            -->25       20
                              UPPER(TO_CHAR (l_stud_rec.HOME_ADDR_L4)), --    HOME_ADDR_L4,                            -->26       21
                              UPPER(TO_CHAR (l_stud_rec.HOME_TELE_NO)), --    HOME_TELE_NO,                            -->27       22
                              UPPER(TO_CHAR (l_stud_rec.SORT_CODE)), --    SORT_CODE,                                  -->28       23          
                              UPPER(TO_CHAR (l_stud_rec.ACCOUNT_NO)), --    ACCOUNT_NO,                                -->29       24
                              UPPER(TO_CHAR (l_stud_rec.BIRTH_COUNTRY_CODE)), --    BIRTH_COUNTRY_CODE,                -->32       25
                              UPPER(TO_CHAR (l_stud_rec.NATION_COUNTRY_CODE)), --    NATION_COUNTRY_CODE,              -->34       26
                              UPPER(TO_CHAR (l_stud_rec.RESIDENCE_COUNTRY_CODE)), --    RESIDENCE_COUNTRY_CODE,        -->36       27
                              UPPER(TO_CHAR (l_stud_rec.INST_NAME)), --    INST_NAME,                                  -->38       28
                              UPPER(TO_CHAR (l_stud_rec.INST_CODE)), --    INST_CODE,                                  -->40       29
                              UPPER(TO_CHAR (l_stud_rec.CRSE_NAME)), --    CRSE_NAME,                                  -->41       30
                              UPPER(TO_CHAR (l_stud_rec.CRSE_CODE)), --    CRSE_CODE,                                  -->43       31
                              UPPER(TO_CHAR (l_stud_rec.CRSE_YEAR_NO)), --    CRSE_YEAR_NO,                            -->43       32
                              UPPER(TO_CHAR (l_stud_rec.DEP_SURNAME)), --    FIRST_DEP_SURNAME,                        -->45       33
                              UPPER(TO_CHAR (l_stud_rec.DEP_FORENAMES)), --    FIRST_DEP_FORENAMES,                    -->46       34
                              UPPER(TO_CHAR (v_dep_dob)),              --    FIRST_DEP_DOB,                            -->47       35                        
                              UPPER(TO_CHAR (l_stud_rec.DEP_REL_TYPE)), --    FIRST_DEP_REL_TYPE,                      -->49       36
                              UPPER(TO_CHAR (l_stud_rec.DEP_INCOME_AMOUNT_1)), --    FIRST_DEP_INCOME_AMOUNT_1         -->50       37
                              UPPER(TO_CHAR (v_add_dep)),      --    ADD_DEP_DETAILS,                                  -->96       38
                              UPPER(TO_CHAR (l_stud_rec.LPCG)),           --    LPCG,                                  -->97       39
                              'Y',                         --    APP_FORM_SIG,                                  -->112      40
                              UPPER(TO_CHAR (l_stud_rec.MAX_LOAN_REQUESTED)), --    MAX_LOAN_REQUESTED,                -->113      41
                              UPPER(TO_CHAR (l_stud_rec.LOAN_REQUEST)),--    LOAN_REQUEST        ,                     -->114      42
                              UPPER(TO_CHAR (l_stud_rec.CONT1_NAME)), --    CONT1_NAME,                                -->118      43
                              UPPER(TO_CHAR (l_stud_rec.CONT1_REL_CODE)), --    CONT1_REL_CODE,                        -->119      44
                              UPPER(TO_CHAR (l_stud_rec.CONT1_POSTCODE)), --    CONT1_POSTCODE,                        -->121      45
                              UPPER(TO_CHAR (l_stud_rec.CONT1_ADDR1)),--    CONT1_ADDR1,                               -->122      46
                              UPPER(TO_CHAR (l_stud_rec.CONT1_ADDR2)),--    CONT1_ADDR2,                               -->123      47
                              UPPER(TO_CHAR (l_stud_rec.CONT1_ADDR3)), --    CONT1_ADDR3,                              -->124      48
                              UPPER(TO_CHAR (l_stud_rec.CONT1_TEL_NO)), --    CONT1_TEL_NO,                            -->126      49
                              UPPER(TO_CHAR (l_stud_rec.CONT2_NAME)), --    CONT2_NAME,                                -->129      50
                              UPPER(TO_CHAR (l_stud_rec.CONT2_POSTCODE)), --    CONT2_POSTCODE,                        -->131      51          
                              UPPER(TO_CHAR (l_stud_rec.CONT2_ADDR1)), --    CONT2_ADDR1,                              -->132      52
                              UPPER(TO_CHAR (l_stud_rec.CONT2_ADDR2)), --    CONT2_ADDR2,                              -->133      53
                              UPPER(TO_CHAR (l_stud_rec.CONT2_ADDR3)), --    CONT2_ADDR3,                              -->134      54
                              UPPER(TO_CHAR (l_stud_rec.CONT2_TEL_NO)), --    CONT2_TEL_NO,                            -->136      55
                              UPPER(TO_CHAR (l_stud_rec.TERM_HOUSE_NO_NAME)), --    TERM_HOUSE_NO_NAME,                -->138      56       
                              UPPER(TO_CHAR (l_stud_rec.TERM_POST_CODE)), --    TERM_POST_CODE,                        -->139      57
                              UPPER(TO_CHAR (l_stud_rec.TERM_ADDR_L1)), --    TERM_ADDR_L1,                            -->140      58
                              UPPER(TO_CHAR (l_stud_rec.TERM_ADDR_L2)), --    TERM_ADDR_L2,                            -->141      59
                              UPPER(TO_CHAR (l_stud_rec.TERM_ADDR_L3)), --    TERM_ADDR_L3,                            -->142      60
                              UPPER(TO_CHAR (l_stud_rec.TERM_ADDR_L4)), --    TERM_ADDR_L4,                            -->143      61
                              UPPER(TO_CHAR (l_stud_rec.SLC_CORRES_DEST)), --    SLC_CORRES_DEST,                      -->144      62
                              UPPER(TO_CHAR (v_loan_signature)), --    LOAN_SIGNATURE,                                 -->145      63
                              UPPER(TO_CHAR (v_loan_dec_date)), --    LOAN_DECLARATION_DATE,                           -->146      64
                              UPPER(TO_CHAR (v_BEN1_NI_NO)), --    BEN1_NI_NO,                                         -->148      65
                              UPPER(TO_CHAR (v_BEN1_TITLE)), --    BEN1_TITLE,                                         -->150      66
                              UPPER(TO_CHAR (v_BEN1_SURNAME)), --    BEN1_SURNAME,                                     -->151      67
                              UPPER(TO_CHAR (v_BEN1_FORENAMES)), --    BEN1_FORENAMES,                                 -->152      68
                              UPPER(TO_CHAR (v_BEN1_REL_TYPE)), --    BEN1_REL_TYPE,                                   -->153      69
                              UPPER(TO_CHAR (v_BEN1_HOUSE_NO_NAME)), --    BEN1_HOUSE_NO_NAME,                         -->154      70
                              UPPER(TO_CHAR (v_BEN1_POSTCODE)),--    BEN1_POSTCODE,                                    -->155      71
                              UPPER(TO_CHAR (v_BEN1_ADDR1)),          --    BEN1_ADDR1,                                -->156      72
                              UPPER(TO_CHAR (v_BEN1_ADDR2)), --    BEN1_ADDR2,                                         -->157      73
                              UPPER(TO_CHAR (v_BEN1_ADDR3)), --    BEN1_ADDR3,                                         -->158      74
                              UPPER(TO_CHAR (v_BEN1_ADDR4)), --    BEN1_ADDR4,                                         -->159      75
                              UPPER(TO_CHAR (v_BEN2_NI_NO)), --    BEN2_NI_NO,                                         -->161      76
                              UPPER(TO_CHAR (v_BEN2_TITLE)), --    BEN2_TITLE,                                         -->163      77
                              UPPER(TO_CHAR (v_BEN2_SURNAME)), --    BEN2_SURNAME,                                     -->164      78
                              UPPER(TO_CHAR (v_BEN2_FORENAMES)), --    BEN2_FORENAMES,                                 -->165      79
                              UPPER(TO_CHAR (v_BEN2_REL_TYPE)), --    BEN2_REL_TYPE,                                   -->166      80
                              UPPER(TO_CHAR (v_BEN2_HOUSE_NO_NAME)), --    BEN2_HOUSE_NO_NAME,                         -->167      81
                              UPPER(TO_CHAR (v_BEN2_POSTCODE)), --    BEN2_POSTCODE,                                   -->168      82
                              UPPER(TO_CHAR (v_BEN2_ADDR1)), --    BEN2_ADDR1,                                         -->169      83
                              UPPER(TO_CHAR (v_BEN2_ADDR2)), --    BEN2_ADDR2,                                         -->170      84
                              UPPER(TO_CHAR (v_BEN2_ADDR3)), --    BEN2_ADDR3,                                         -->171      85
                              UPPER(TO_CHAR (v_BEN2_ADDR4)), --    BEN2_ADDR4,                                         -->172      86
                              UPPER(TO_CHAR (l_stud_rec.JA_CASE)),     --    JA_CASE,                                  -->174      87
                              UPPER(v_BEN1_PAYE),                    --    BEN1_PAYE,                                  -->175      88
                              UPPER(v_BEN2_PAYE),                   --    BEN2_PAYE,                                  -->176      89                        
                              UPPER(v_BEN1_SELF_EMPLOYMENT), --    BEN1_SELF_EMPLOYMENT,                               -->179      90
                              UPPER(v_BEN2_SELF_EMPLOYMENT), --    BEN2_SELF_EMPLOYMENT,                               -->181      91
                              UPPER(v_BEN1_PROPERTY),            --    BEN1_PROPERTY,                                  -->183      92
                              UPPER(v_BEN2_PROPERTY),            --    BEN2_PROPERTY,                                  -->185      93
                              UPPER(v_BEN1_PENSIONS),            --    BEN1_PENSIONS,                                  -->187      94
                              UPPER(v_BEN2_PENSIONS),            --    BEN2_PENSIONS,                                  -->189      95
                              UPPER(v_BEN1_BENEFITS),            --    BEN1_BENEFITS,                                  -->191      96
                              UPPER(v_BEN2_BENEFITS),            --    BEN2_BENEFITS,                                  -->193      97
                              UPPER(v_BEN1_NAT_SAVINGS),      --    BEN1_NAT_SAVINGS,                                  -->195      98
                              UPPER(v_BEN2_NAT_SAVINGS),      --    BEN2_NAT_SAVINGS,                                  -->197      99  
                              UPPER(v_BEN1_INTEREST),            --    BEN1_INTEREST,                                  -->199      100
                              UPPER(v_BEN2_INTEREST),            --    BEN2_INTEREST,                                  -->201      101
                              UPPER(v_BEN1_DIVIDEND),            --    BEN1_DIVIDEND,                                  -->203      102
                              UPPER(v_BEN2_DIVIDEND),            --    BEN2_DIVIDEND,                                  -->205      103
                              UPPER(v_BEN1_OTHER_INC),          --    BEN1_OTHER_INC,                                  -->207      104
                              UPPER(v_BEN2_OTHER_INC),          --    BEN2_OTHER_INC,                                  -->209      105
                              UPPER(v_BEN1_OTHER_DED),          --    BEN1_OTHER_DED,                                  -->219      106
                              UPPER(v_BEN2_OTHER_DED),          --    BEN2_OTHER_DED,                                  -->221      107
                              UPPER(TO_CHAR (v_ben_dec_sig)),      --    BEN_DEC_SIG,                                  -->230      108
                              UPPER(TO_CHAR (v_web_submitted)), --    DATE_APPLIC_RECEIVED,                            -->239      109
                              'WEB',                          --    EMP_LOGIN,                                  -->240      110
                              UPPER(TO_CHAR (v_web_submitted)), --    APP_FORM_SIG_DATE,                               -->241      111
                              UPPER(TO_CHAR (l_stud_rec.MOBILE_TEL_NO)), --    MOBILE_TEL_NO,                          -->246      112
                              TO_CHAR (l_stud_rec.EMAIL_ADDR), --    EMAIL_ADDR,                                -->250      113
                              TO_CHAR (l_stud_rec.USER_ID), --    WEB_USER_ID,                                  -->251      114
                              UPPER(TO_CHAR (l_stud_rec.BANK_VALIDATE)), --    BANK_VALIDATE                           -->252      115
                              UPPER(TO_CHAR (l_stud_rec.IN_EDUC_SINCE_LEAVE_SCHOOL)), --IN_EDUC_SINCE_LEAVE_SCHOOL     -->262      116
                              UPPER(TO_CHAR (l_stud_rec.STUDY_ABROAD)), --STUDY_ABROAD                                 -->266      117 
                              UPPER(TO_CHAR (l_stud_rec.PLACEMENT)),   --PLACEMENT_YEAR                                -->264      118 
                              UPPER(TO_CHAR (l_stud_rec.EU_STUDENT)),    --EU_STUDENT                                  -->296      119
                              UPPER(TO_CHAR (l_stud_rec.YEARS_TO_COMPLETE_COURSE)),  --NOS_YEARS_COURSE_TAKES          -->297      120
                              UPPER(TO_CHAR (l_stud_rec.ORD_RES_SCOTLAND)), --ORD_RES_SCOTLAND_WEB                     -->298      121
                              UPPER(TO_CHAR (l_stud_rec.ORD_RES_UK)),  --ORD_RES_UK_WEB                                -->299      122
                              UPPER(TO_CHAR (l_stud_rec.MAX_FEE_LOAN)), --MAX_FEE_LOAN                                 -->300      123
                              UPPER(TO_CHAR (l_stud_rec.FEE_LOAN_AMOUNT)),  --FEE_LOAN_AMOUNT                          -->301      124
                              UPPER(TO_CHAR (l_stud_rec.DEPENDANTS_GRANT)), --DEP_GRANT                                -->303      125
                              UPPER(TO_CHAR (l_stud_rec.LONE_PARENTS_GRANT)),      --LPG                               -->304      126
                              UPPER(TO_CHAR (l_stud_rec.SKILLS_DEV_DATA_SHARE)), --SKILLS_DEV_DATA_SHARE               -->312      127
                              UPPER(TO_CHAR (v_BEN1_WORKING_TAX_CREDIT)), --BEN1_WORKING_TAX_CREDIT                    -->320      128
                              UPPER(TO_CHAR (v_BEN1_MAINTENANCE_PAYMENT)), --BEN1_MAINTENANCE_PAYMENT         -->326      129                                        
                              UPPER(TO_CHAR (v_BEN2_WORKING_TAX_CREDIT)), --BEN2_WORKING_TAX_CREDIT                    -->327      130                                
                              UPPER(TO_CHAR (v_BEN2_MAINTENANCE_PAYMENT)),  --BEN2_MAINTENANCE_PAYMENT        -->333      131
                              UPPER(TO_CHAR (l_stud_rec.STUD_INCOME)), --STUD_INCOME                                   -->334      132
                              UPPER(TO_CHAR (l_stud_rec.TUITION_FEES)),    -- TUITION_FEES                             -->342      133
                              UPPER(TO_CHAR (l_stud_rec.BURSARY_ONLY)),    --BURSARY_ONLY                              -->344      134
                              UPPER(TO_CHAR (l_stud_rec.YSB)), --YSB                                                   -->347      135
                              UPPER(TO_CHAR (l_stud_rec.INSCOT_YEAR)), --INSCOT_YEAR                                   -->352      136                       
                              UPPER(TO_CHAR (l_stud_rec.CONSENT_FROM_STUDENT)), -- CONSENT_FROM_STUDENT                -->353      137                        
                              v_amount_1,  --STUD_INCOME_AMT1                                                   -->357      138
                              v_source_1,  --STUD_INCOME_TYPE1                                                  -->358      139
                              v_amount_2,  --STUD_INCOME_AMT2                                                   -->359      140
                              v_source_2,  --STUD_INCOME_TYPE2                                                  -->360      141
                              v_amount_3,  --STUD_INCOME_AMT3                                                   -->361      142
                              v_source_3,  --STUD_INCOME_TYPE3                                                  -->362      143
                              v_amount_4,  --STUD_INCOME_AMT4                                                   -->363      144
                              v_source_4,  --STUD_INCOME_TYPE4                                                  -->364      145
                              v_amount_5,  --STUD_INCOME_AMT5                                                   -->365      146
                              v_source_5,  --STUD_INCOME_TYPE5                                                  -->366      147
                              v_amount_6,  --STUD_INCOME_AMT6                                                   -->367      148
                              v_source_6,  --STUD_INCOME_TYPE6 ,                                                -->368      149
                              UPPER(TO_CHAR (v_NO_INCOME_REAS_PERS_1)), --REASON_NO_INCOME_BEN1                        -->369      150
                              UPPER(TO_CHAR (v_NO_INCOME_REAS_PERS_2)), --REASON_NO_INCOME_BEN2                        -->370      151         
                              UPPER(TO_CHAR (l_stud_rec.HEI_CONSENT)),           --HEI_CONSENT                         -->371      152
                              UPPER(TO_CHAR (l_stud_rec.CARE_LEAVER)),           --CARE_LEAVER                         -->372      153
                              UPPER(TO_CHAR (l_stud_rec.DUAL_NATIONALITY)),      --DUAL_NATIONALITY                    -->373      154    
                              UPPER(TO_CHAR (v_BEN1_HEI_CONSENT)),      --BEN1_HEI_CONSENT                             -->374      155
                              UPPER(TO_CHAR (v_BEN2_HEI_CONSENT)),      --BEN2_HEI_CONSENT                             -->375      156
                              UPPER(TO_CHAR (v_BEN1_AB36)),                      --BEN1_AB36                           -->376      157
                              UPPER(TO_CHAR (v_BEN2_AB36)),                      --BEN2_AB36                           -->377      158
                              UPPER(TO_CHAR (l_stud_rec.ONLY_ONE_BEN)),           --ONLY_ONE_BEN                       -->378      159
                              UPPER(TO_CHAR (v_psas_pt)),                         -- PSAS_PT                           -->379      160
                              UPPER(l_stud_rec.REASON_ONLY_ONE_BEN_CODE), --REASON_FOR_ONE_BEN_ID                      -->380      161
                              UPPER(TO_CHAR (v_BEN1_OTHER_INC_DETAILS)),--BEN1_OTHER_INC_DETAILS                       -->381      162
                              UPPER(TO_CHAR (v_BEN2_OTHER_INC_DETAILS)),--BEN2_OTHER_INC_DETAILS                       -->382      163
                              UPPER(TO_CHAR (l_stud_rec.CONT1_CONSENT)),         --CONT1_CONSENT                       -->383      164
                              UPPER(TO_CHAR (l_stud_rec.CONT2_CONSENT)),         --CONT2_CONSENT                       -->384      165
                              UPPER(TO_CHAR (l_stud_rec.INTERRUPTION_FROM_STUDY)),--INTERRUPTION_FROM_STUDY            -->385      166
                              UPPER(TO_CHAR (l_stud_rec.IS_INDEPENDENT)),        --IS_INDEPENDENT                      -->386      167
                              UPPER(TO_CHAR (l_stud_rec.RESIDENCY_CATEGORY)),      --RESIDENCY_CATEGORY                -->387      168
                              UPPER(TO_CHAR (v_BEN1_SHARE_STUDENT)),--BEN1_CONSENT_TO_SHARE_STUDENT                    -->388      169
                              UPPER(TO_CHAR (v_BEN2_SHARE_STUDENT)),--BEN2_CONSENT_TO_SHARE_STUDENT                     -->389      170
                              UPPER(TO_CHAR(l_stud_rec.INDEPENDENT)),          --CR223 J.Penman 061217 added 300118
                              UPPER(TO_CHAR(l_stud_rec.ORPHAN)),               --CR223 J.Penman 061217 added 300118
                              UPPER(TO_CHAR(l_stud_rec.OVER_25)),               --CR223 J.Penman 061217 added 300118
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_FOSTER)),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_RES)),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_KINSHIP_LA)),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_KINSHIP_NO_LA)),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_HOME)),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_OTHER)),
                              TO_CHAR (l_stud_rec.CARE_EXP_OTHER_DETAILS),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_START_AGE)),
                              UPPER(TO_CHAR (l_stud_rec.CARE_EXP_END_AGE)),
                              UPPER(TO_CHAR (l_stud_rec.START_DATE_ABROAD)), --CR160 J.Penman  added 0102118
                              UPPER(TO_CHAR (l_stud_rec.END_DATE_ABROAD)), --CR160 J.Penman  added 0102118
                              UPPER(TO_CHAR (l_stud_rec.PG_ED_PSYCH_GRANT)), --SFD3 PG EDUCATIONAL PSYCHOLOGY 
                              UPPER(TO_CHAR (l_stud_rec.PG_ED_PSYCH_FEES)), --SFD3 PG EDUCATIONAL PSYCHOLOGY 
                              UPPER(TO_CHAR (l_stud_rec.PG_ED_PSYCH_QEPS)), --SFD3 PG EDUCATIONAL PSYCHOLOGY 
                              UPPER(TO_CHAR (l_stud_rec.PG_ED_PSYCH_DECLARATION)), --SFD3 PG EDUCATIONAL PSYCHOLOGY
                              UPPER(v_BEN1_EMAIL), -- SFD3 GDPR 
                              UPPER(v_BEN2_EMAIL),  --SFD3 GDPR
                              UPPER(l_stud_rec.ESTRANGED_ON_APP) --COS 2020/2021 Estrangement             
                              );    
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no)
                     || ' '
                     || TO_CHAR (SQLCODE)
                     || ' '
                     || TO_CHAR (SQLERRM));
                  v_proc := FALSE;
            END;
   

         --
         -- Create EDM temp record
         IF v_proc
         THEN
            v_return_string :=
                  'inserting into EDM_TEMP table on '
               || v_db_name
               || ' '
               || 'database';
            v_proc :=
               create_edm_temp (l_stud_rec, v_err_mess, which_db_to_use);

            IF NOT v_proc
            THEN
               DBMS_OUTPUT.put_line (
                     'Error '
                  || v_err_mess
                  || ' while '
                  || v_return_string
                  || ' for student '
                  || TO_CHAR (l_stud_rec.stud_ref_no));
            END IF;
         END IF;

         -- Create EDM Complete record
         IF v_proc
         THEN
            v_return_string :=
                  'inserting into EDM_COMPLETE table on '
               || v_db_name
               || ' '
               || 'database';
            v_proc :=
               create_edm_complete (l_stud_rec,
                                    v_raw_data_id,
                                    v_batch_id,
                                    v_envelope_id,
                                    v_err_mess,
                                    which_db_to_use);

            --
            IF NOT v_proc
            THEN
               DBMS_OUTPUT.put_line (
                     'Error '
                  || v_err_mess
                  || ' while '
                  || v_return_string
                  || ' for student '
                  || TO_CHAR (l_stud_rec.stud_ref_no));
            END IF;
         END IF;

         -- Change application status and delete from CWA
         IF v_proc
         THEN
            BEGIN
               v_return_string := 'updating the application status';

               UPDATE APPLICATIONS_MADE@web
                  SET status = 'T'
                WHERE application_id = l_stud_rec.application_id;

               --
               v_return_string :=
                  'deleting from complete_web_applications table';

               --*******************************************************DELETE COMPLETE_WEB_APPLICATIONS ON WEB DATABASE****************************************************************************************
                    DELETE FROM COMPLETE_WEB_APPLICATIONS@web
                        WHERE application_id = l_stud_rec.application_id;
               --***********************************************************************************************************************************************************************************************
               
                --*******************************************************DELETE COMPLETE_WEB_APPLICATIONS ON WEB DATABASE****************************************************************************************
                     DELETE FROM COMPLETE_WEB_APP_DEP@web
                        WHERE application_id = l_stud_rec.application_id;
                --***********************************************************************************************************************************************************************************************  
     
            EXCEPTION
               WHEN OTHERS
               THEN
                  ROLLBACK;
                  DBMS_OUTPUT.put_line (
                        'Unhandled exception '
                     || TO_CHAR (SQLCODE)
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
                  v_proc := FALSE;
            END;
         END IF;

         --
         IF v_proc
         THEN
            v_return_string := 'commiting changes';
            DBMS_OUTPUT.put_line (
                  'Application for student '
               || TO_CHAR (l_stud_rec.stud_ref_no)
               || ' transferred to '
               || ' '
               || v_db_name);
            COMMIT;
         ELSE
            ROLLBACK;
            COMMIT;
            DBMS_OUTPUT.put_line (
                  'Application for student '
               || TO_CHAR (l_stud_rec.stud_ref_no)
               || ' was not transferred to '
               || ' '
               || v_db_name);
         END IF;

         --
         IF NOT v_proc
         THEN
            v_return_string := 'updating CWA to error';

            BEGIN
               UPDATE complete_web_applications@web
                  SET status = 'E'
                WHERE application_id = l_stud_rec.application_id;

               v_return_string := 'commiting changes';
               COMMIT;
               DBMS_OUTPUT.put_line (
                     'Application for student '
                  || TO_CHAR (l_stud_rec.stud_ref_no)
                  || ' updated CWA to in error '
                  || ' '
                  || v_db_name);
            EXCEPTION
               WHEN OTHERS
               THEN
                  ROLLBACK;
                  COMMIT;
                  DBMS_OUTPUT.put_line (
                        'Unhandled exception updatying CWA for error '
                     || TO_CHAR (SQLCODE)
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec.stud_ref_no));
                  v_proc := FALSE;
            END;
         END IF;
      ELSE
         RETURN ('OK');
      END IF;

      RETURN ('OK');
       EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         ROLLBACK;
         DBMS_OUTPUT.put_line (
               'NO DATA FOUND exception while '
            || v_return_string
            || ' for student '
            || TO_CHAR (l_stud_rec.stud_ref_no));
         COMMIT;
      WHEN TOO_MANY_ROWS
      THEN
         ROLLBACK;
         DBMS_OUTPUT.put_line (
               'TOO MANY ROWS exception while '
            || v_return_string
            || ' for student '
            || TO_CHAR (l_stud_rec.stud_ref_no));
         COMMIT;
      WHEN OTHERS
      THEN
         ROLLBACK;
         DBMS_OUTPUT.put_line (
               'Unhandled exception '
            || TO_CHAR (SQLCODE)
            || ' while '
            || v_return_string
            || ' for student '
            || TO_CHAR (l_stud_rec.stud_ref_no));
         COMMIT;
   --
   END application_data_copy_genric;
   
    --The following function is used for copying the application data from 
    --the DEPENDANT interface table on the web database to the DEPENDANT interface
    -- table on steps database
    
  FUNCTION copy_dep_app_data (
      STUD_REC_DEP      IN complete_web_app_dep@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2
   IS
        v_return_string     VARCHAR2 (1000);
        v_object_id         VARCHAR(44);
        l_stud_rec_DEP  complete_web_app_dep@web%ROWTYPE;
        v_proc              BOOLEAN;
        v_err_mess          VARCHAR2 (256);
        v_db_name           VARCHAR2(5);
        v_dep_dob           VARCHAR(9);
        v_err_mess_deps          VARCHAR2(100);
   BEGIN
      
      v_db_name := 'StEPS';
      l_stud_rec_DEP := STUD_REC_DEP;
      
       SELECT OBJECT_ID 
       INTO v_object_id
       FROM COMPLETE_WEB_APPLICATIONS@web
        WHERE APPLICATION_ID = l_stud_rec_DEP.application_id;

        v_err_mess_deps := 'Formatting the Dependants DOB';
        v_dep_dob := l_stud_rec_DEP.dob;
        v_proc := TRUE;
        
        IF l_stud_rec_DEP.dob IS NOT NULL
            THEN
               v_proc :=
                  reformat_date_for_rawdata (l_stud_rec_DEP.dob,
                                             v_dep_dob,
                                             v_err_mess);
        END IF;                                             

        BEGIN
      
                v_return_string := 'inserting into RAW_DATA_DEP in StEPS';
               
               INSERT INTO EDM.RAW_DATA_DEP
                   (OBJECT_ID,
                    STUD_REF_NO,
                    STUD_DEP_ID,
                    FORENAMES,
                    SURNAME,
                    DOB,
                    DEPENDANT_RELATIONSHIP_ID,
                    TOTAL_INCOME,
                    EMAIL_ADDR, 
                    POST_CODE,
                    HOUSE_NO_NAME,
                    ADDR_L1,
                    ADDR_L2, 
                    ADDR_L3, 
                    ADDR_L4, 
                    LPG
                    )
               VALUES (
                       UPPER(TO_CHAR (v_object_id)),                        
                       UPPER(TO_CHAR (l_stud_rec_DEP.STUD_REF_NO)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.STUD_DEP_ID)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.FORENAMES)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.SURNAME)),
                       --UPPER(TO_CHAR (l_stud_rec_DEP.DOB)),
                       v_dep_dob,
                       UPPER(TO_CHAR (l_stud_rec_DEP.DEPENDANT_RELATIONSHIP_ID)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.TOTAL_INCOME)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.EMAIL_ADDR)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.POST_CODE)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.HOUSE_NO_NAME)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.ADDR_L1)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.ADDR_L2)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.ADDR_L3)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.ADDR_L4)),
                       UPPER(TO_CHAR (l_stud_rec_DEP.LPG))
                       );                   
                
   
               EXCEPTION
               WHEN OTHERS
               THEN
                  v_proc := FALSE;
                  v_err_mess := TO_CHAR (SQLCODE) || ' ' || TO_CHAR (SQLERRM);
                  DBMS_OUTPUT.put_line (
                        'Error '
                     || v_err_mess
                     || ' while '
                     || v_return_string
                     || ' for student '
                     || TO_CHAR (l_stud_rec_DEP.stud_ref_no));
                     
                     

                     
          
         IF v_proc 
         THEN
         
            v_return_string := 'commiting changes';
            DBMS_OUTPUT.put_line (
                  'Dependant for student '
               || TO_CHAR (l_stud_rec_DEP.stud_ref_no)
               || ' transferred to '
               || ' '
               || v_db_name);
            COMMIT;
         ELSE
            ROLLBACK;
            COMMIT;
            DBMS_OUTPUT.put_line (
                  'Application for student '
               || TO_CHAR (l_stud_rec_DEP.stud_ref_no)
               || ' was not transferred to '
               || ' '
               || v_db_name);
         END IF;

                      
    END;
    

    
 
   
    
    RETURN ('OK');
    
  END copy_dep_app_data;                     
                       
                                           


   FUNCTION get_eistream_record (
      p_stud_ref_no   IN     STUD.stud_ref_no@web%TYPE,
      p_object_id     IN     complete_web_applications.object_id@web%TYPE,
      p_batch_id      IN OUT VARCHAR2,
      p_envelope_id   IN OUT VARCHAR2,
      p_err_mess      IN OUT VARCHAR2)
      RETURN BOOLEAN
   IS
   --
   --
   BEGIN
      --
      SELECT TO_CHAR (batchid), TO_CHAR (NVL (envelopeid, '1'))
        INTO p_batch_id, p_envelope_id
        FROM attributes@EDM_REF.world
       WHERE object_id = p_object_id;

      --
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_err_mess := TO_CHAR (SQLCODE);
         RETURN FALSE;
   END;                                               

   --
   -- get raw_data id
   FUNCTION get_raw_data_id (p_stud_ref_no        IN     STUD.stud_ref_no@web%TYPE,
                             p_raw_data_id        IN OUT VARCHAR2,
                             p_err_mess           IN OUT VARCHAR2,
                             p_which_db_to_use    IN     VARCHAR2,
                             p_application_type   IN     VARCHAR2)
      RETURN BOOLEAN
   IS
   --
   --
   BEGIN
      --

      SELECT TO_CHAR (RAW_DATA_ID_SEQ.NEXTVAL)
        INTO p_raw_data_id
        FROM DUAL;

      --
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_err_mess := TO_CHAR (SQLCODE);
         RETURN FALSE;
   END;                                                    --get raw_data id ;

   --

   FUNCTION create_edm_temp (
      p_stud_rec        IN OUT complete_web_applications@web%ROWTYPE,
      p_err_mess        IN OUT VARCHAR2,
      which_db_to_use   IN     VARCHAR2)
      RETURN BOOLEAN
   IS
      v_doc_type_code   VARCHAR2 (10);
      v_doc_type_name   VARCHAR2 (50);
      NO_DB_SUPPLIED    EXCEPTION;
   --
   --
   BEGIN
      --
      p_err_mess := ' Starting TRANSFORM create_edm_temp function';

      --
      IF NVL (which_db_to_use, 'Z') NOT IN ('G', 'S')
      THEN
         p_err_mess :=
            'WEB transform failed while creating an EDM TEMP record as it was not identified whether to use STEPS ';
         RAISE NO_DB_SUPPLIED;
      END IF;

      --
      -- JM RFC 244 change following section for document_type_code changes
      --
      IF which_db_to_use = 'S'
      THEN
         IF p_stud_rec.application_type = '3'
         THEN
            v_doc_type_code := 'SAS3_PDF';
            v_doc_type_name :=
                  p_stud_rec.application_type
               || p_stud_rec.stud_ref_no
               || '_'
               || p_stud_rec.session_code
               || ':1';
         ELSIF p_stud_rec.application_type = '7'
         THEN
            v_doc_type_code := 'SAS7_PDF';
            v_doc_type_name :=
                  p_stud_rec.application_type
               || p_stud_rec.stud_ref_no
               || '_'
               || p_stud_rec.session_code
               || ':1';
         ELSIF p_stud_rec.application_type = 'B'
         THEN
            v_doc_type_code := 'NMSB1_PDF';
            v_doc_type_name :=
                  p_stud_rec.application_type
               || p_stud_rec.stud_ref_no
               || '_'
               || p_stud_rec.session_code
               || ':1';
         ELSE
            p_err_mess :=
               ' unable to determine document type code - COMPLETE_WEB_APPLICATIONS application type incorrect ';
            RETURN FALSE;
         END IF;
      ELSE
         RAISE NO_DB_SUPPLIED;
      END IF;

      --
      --
      p_err_mess := ' WEB transform failed while creating an EDM TEMP record';

      --
      --

      INSERT INTO EDM.EDM_TEMP (OBJECT_ID,                  --changed OLS2016
                                        SESSION_CODE,
                                        DOCUMENT_TYPE_CODE,
                                        DOCUMENT_NAME,
                                        DOCUMENT_TYPE_COUNT,
                                        ATTACHMENT_TYPE_CODE,
                                        RESCAN_REQUEST_ID)
           VALUES (p_stud_rec.object_id,
                   p_stud_rec.session_code,
                   v_doc_type_code,
                   v_doc_type_name,
                   1,
                   'PDF',
                   NULL);


      --
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_err_mess := p_err_mess || TO_CHAR (SQLCODE);
         RETURN FALSE;
   END;                                                      --create_edm_temp

   FUNCTION create_edm_complete (
      p_stud_rec        IN OUT complete_web_applications@web%ROWTYPE,
      p_raw_data_id     IN OUT VARCHAR2,
      p_batch_id        IN OUT VARCHAR2,
      p_envelope_id     IN OUT VARCHAR2,
      p_err_mess        IN OUT VARCHAR2,
      which_db_to_use   IN     VARCHAR2)
      RETURN BOOLEAN
   IS
      v_batch_type_code   VARCHAR2 (2);
      NO_DB_SUPPLIED      EXCEPTION;
   --
   BEGIN
      --
      p_err_mess := ' Starting TRANSFORM create_edm_complete function';

      --
      IF NVL (which_db_to_use, 'Z') NOT IN ('G', 'S')
      THEN
         p_err_mess :=
            'WEB transform failed while creating an EDM COMPLETE record as it was not identified whether to use STEPS ';
         RAISE NO_DB_SUPPLIED;
      END IF;

      --
      IF p_stud_rec.application_type = '3'
      THEN
         v_batch_type_code := '31';
      ELSIF p_stud_rec.application_type = '7'
      THEN
         v_batch_type_code := '32';
      ELSIF p_stud_rec.application_type = 'B'
      THEN
         v_batch_type_code := '33';
      ELSE
         p_err_mess :=
            ' unable to determine batch type code - COMPLETE_WEB_APPLICATIONS application type incorrect ';
         RETURN FALSE;
      END IF;

      --
      p_err_mess :=
         ' WEB transform failed while creating an EDM COMPLETE record';


      INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,              --changed OLS2016
                                            RAW_DATA_ID,
                                            BATCH_TYPE_CODE,
                                            STUD_REF_NO,
                                            BATCH_ID,
                                            ENVELOPE_ID,
                                            SCAN_DATE,
                                            PROC_ERROR,
                                            URGENT)
           VALUES (p_stud_rec.object_id,
                   p_raw_data_id,
                   v_batch_type_code,
                   p_stud_rec.stud_ref_no,
                   p_batch_id,
                   p_envelope_id,
                   p_stud_rec.web_submitted,
                   'N',
                   'N');

      RETURN TRUE;
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         p_err_mess := p_err_mess || TO_CHAR (SQLCODE);
         RETURN FALSE;
   END;                                                  --create_edm_complete



   FUNCTION reformat_date_for_rawdata (
      p_date_in    IN OUT complete_web_applications.dob@web%TYPE,
      p_date       IN OUT VARCHAR2,
      p_err_mess   IN OUT VARCHAR2)
      RETURN BOOLEAN
   IS
   BEGIN
      p_date := TO_CHAR (p_date_in, 'DDMMYYYY');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_err_mess := p_err_mess || TO_CHAR (SQLCODE);
         RETURN FALSE;
   END;                                            --reformat_date_for_rawdata



   FUNCTION format_currency_rec (
      p_currency_rec IN complete_web_applications.ben2_paye@web%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      IF NVL (p_currency_rec, 0) = 0
      THEN
         RETURN NULL;
      ELSE
         RETURN LTRIM (RTRIM (TO_CHAR (p_currency_rec, '9999999D99')));
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;                                                

   --
   FUNCTION format_currency_rec1 (
      p_currency_rec IN complete_web_applications.ben2_paye@web%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      IF p_currency_rec = 0
      THEN
         RETURN '0';
      ELSIF p_currency_rec = NULL
      THEN
         RETURN NULL;
      ELSE
         RETURN LTRIM (RTRIM (TO_CHAR (p_currency_rec, '9999999D99')));
      END IF;
     
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;
   
 
                                                 
END Transform;
/