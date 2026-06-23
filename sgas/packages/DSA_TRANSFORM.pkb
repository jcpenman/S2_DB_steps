CREATE OR REPLACE PACKAGE BODY SGAS.DSA_TRANSFORM
/******************************************************************************
   NAME:       DSA_TRANSFORM
   PURPOSE:    Pre-Synchronise called by SHELL SCRIPT:
               synchronise_pre_batch_run_steps.sh

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/11/2023  RANJ             DSA ONLINE TRANSFER

******************************************************************************/

AS

    --------------------------------------------------------------------------------------------------------------
    -- Selects the DSA application data from the interface table on the web database and puts these into a cursor.
    -- Then loops around the data in the cursor and makes calls to function copy_dsa_app_data.
    --------------------------------------------------------------------------------------------------------------
	FUNCTION dsa_application_data_copy_steps
	   RETURN VARCHAR2
	IS
	   v_return_string   VARCHAR2 (1000) := NULL;
	   v_web_submitted   VARCHAR2 (20) := NULL;
	   v_retval          VARCHAR2 (1000) := NULL;

	   CURSOR c_dsa_apps
	   IS
		  SELECT *
			FROM COMPLETE_WEB_APP_DSA@WEB
		   WHERE DSA_APPLICATION_TYPE IN ('D') AND OBJECT_ID IS NOT NULL;

	BEGIN
	   DBMS_OUTPUT.put_line (
			 '*** DATA TRANSFER of DSA ONLINE students to StEPS STARTING AT '
		  || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
		  || ' ***');

	   v_return_string := 'opening cursor';
	   v_web_submitted := TO_DATE (SYSDATE, 'dd/mon/yyyy');

	   FOR stud_rec_dsa IN c_dsa_apps
	   LOOP
		  BEGIN
			 v_retval := copy_dsa_app_data (stud_rec_dsa, 'S');
		  END;
	   END LOOP;

	   DBMS_OUTPUT.put_line (
			 '*** DATA TRANSFER of DSA ONLINE students to StEPS ENDING AT '
		  || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
		  || ' ***');

	   RETURN 'OK';
	END dsa_application_data_copy_steps;


	
    -----------------------------------------------------------------------------------------------------------------------------------
    -- Copies the DSA data from the web database to the interface table on steps database.
    -- Only metadata is required to create a task which is all that's currently in scope for transfer (NOT the application data items).
	-----------------------------------------------------------------------------------------------------------------------------------
	FUNCTION copy_dsa_app_data (
	   stud_rec_dsa      IN complete_web_app_dsa@web%ROWTYPE,
	   which_db_to_use   IN VARCHAR2)
	   RETURN VARCHAR2
	IS
	   v_return_string   VARCHAR2 (1000);
	   v_object_id       VARCHAR (44);
	   l_stud_rec_dsa    complete_web_app_dsa@web%ROWTYPE;
	   v_proc            BOOLEAN;
	   v_err_mess        VARCHAR2 (256);
	   v_db_name         VARCHAR2 (5);
	   v_raw_data_id     VARCHAR2 (44);
	   v_batch_id        VARCHAR2 (16);
	   v_envelope_id     VARCHAR2 (16);
	   
	BEGIN
	   v_db_name := 'StEPS';
	   l_stud_rec_dsa := stud_rec_dsa;

	   SELECT OBJECT_ID
		 INTO v_object_id
		 FROM COMPLETE_WEB_APP_DSA@WEB
		WHERE DSA_APPLICATION_ID = l_stud_rec_dsa.DSA_APPLICATION_ID;

	   DBMS_OUTPUT.put_line ('Value of OBJECT ID is - ' || v_object_id);

	   v_proc := TRUE;
	   v_raw_data_id := NULL;
	   v_batch_id := NULL;
	   v_envelope_id := NULL;

	   BEGIN
		  v_return_string := '';

		  -- Create EDM Temp record
		  IF v_proc
		  THEN
			 DBMS_OUTPUT.put_line ('Inserting into EDM_TEMP ');

			 v_return_string :=
				   'Inserting into EDM_TEMP table on '
				|| v_db_name
				|| ' '
				|| 'database';

			 v_proc :=
				create_edm_temp_dsa (l_stud_rec_dsa, v_err_mess, which_db_to_use);

			 IF NOT v_proc
			 THEN
				DBMS_OUTPUT.put_line (
					  'Error '
				   || v_err_mess
				   || ' while '
				   || v_return_string
				   || ' for student '
				   || TO_CHAR (l_stud_rec_dsa.STUD_REF_NO));
			 END IF;
		  END IF;


		  -- Create EDM Complete record
		  IF v_proc
		  THEN
			 DBMS_OUTPUT.put_line ('Inserting into EDM_COMPLETE ');

			 v_return_string :=
				   'Inserting into EDM_COMPLETE table on '
				|| v_db_name
				|| ' '
				|| 'database';

			 v_proc :=
				create_edm_complete_dsa (l_stud_rec_dsa,
										 v_raw_data_id,
										 v_batch_id,
										 v_envelope_id,
										 v_err_mess,
										 which_db_to_use);

			 IF NOT v_proc
			 THEN
				DBMS_OUTPUT.put_line (
					  'Error '
				   || v_err_mess
				   || ' while '
				   || v_return_string
				   || ' for student '
				   || TO_CHAR (l_stud_rec_dsa.STUD_REF_NO));
			 END IF;
		  END IF;


		  -- Delete from COMPLETE_WEB_APP_DSA
		  IF v_proc
		  THEN
			 BEGIN
				/*
			   v_return_string := 'Updating the application status';

			   UPDATE DSA_APPLICATIONS_MADE@WEB
				  SET APPLICATION_STATUS = 'APPLICATION_SENT'
				WHERE APPLICATION_ID = l_stud_rec_dsa.DSA_APPLICATION_ID;
				*/

				v_return_string := 'Deleting from COMPLETE_WEB_APP_DSA table';

				DELETE FROM COMPLETE_WEB_APP_DSA@WEB
					  WHERE DSA_APPLICATION_ID =
							   l_stud_rec_dsa.DSA_APPLICATION_ID;
							   
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
					  || TO_CHAR (l_stud_rec_dsa.STUD_REF_NO));
				   v_proc := FALSE;
			 END;
		  END IF;
		  
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
				|| TO_CHAR (l_stud_rec_dsa.STUD_REF_NO));

			 IF v_proc
			 THEN
				v_return_string := 'commiting changes';
				DBMS_OUTPUT.put_line (
					  'Dependant for student '
				   || TO_CHAR (l_stud_rec_dsa.STUD_REF_NO)
				   || ' transferred to '
				   || ' '
				   || v_db_name);
				COMMIT;
			 ELSE
				ROLLBACK;
				COMMIT;
				DBMS_OUTPUT.put_line (
					  'Application for student '
				   || TO_CHAR (l_stud_rec_dsa.STUD_REF_NO)
				   || ' was not transferred to '
				   || ' '
				   || v_db_name);
			 END IF;
	   END;

	   RETURN 'OK';
	END copy_dsa_app_data;



    -----------------------------------------------------------------------------------------------------------------------------------
    -- Inserts into EDM_TEMP
	-----------------------------------------------------------------------------------------------------------------------------------
	FUNCTION create_edm_temp_dsa (
	   l_stud_rec_dsa    IN OUT complete_web_app_dsa@web%ROWTYPE,
	   p_err_mess        IN OUT VARCHAR2,
	   which_db_to_use   IN     VARCHAR2)
	   RETURN BOOLEAN
	IS
	   v_doc_type_code   VARCHAR2 (16);
	   v_doc_type_name   VARCHAR2 (50);
	   NO_DB_SUPPLIED    EXCEPTION;
	BEGIN
	   p_err_mess := ' Starting TRANSFORM create_edm_temp_dsa function';

	   IF which_db_to_use = 'S'
	   THEN
		  IF l_stud_rec_dsa.DSA_APPLICATION_TYPE IN ('D', 'd')
		  THEN
			 v_doc_type_code := 'DSA_ONLINE_APP';
			 v_doc_type_name :=
				   l_stud_rec_dsa.DSA_APPLICATION_TYPE
				|| l_stud_rec_dsa.STUD_REF_NO
				|| '_'
				|| l_stud_rec_dsa.session_code
				|| ':1';
		  ELSE
			 p_err_mess :=
				' Unable to determine document type code - COMPLETE_WEB_APP_DSA application type incorrect ';
			 RETURN FALSE;
		  END IF;
	   ELSE
		  RAISE NO_DB_SUPPLIED;
	   END IF;

	   p_err_mess := ' WEB transform failed while creating an EDM TEMP record';

	   IF l_stud_rec_dsa.DSA_APPLICATION_TYPE IN ('D', 'd')
	   THEN
		  INSERT INTO EDM.EDM_TEMP (OBJECT_ID,
									SESSION_CODE,
									DOCUMENT_TYPE_CODE,
									DOCUMENT_NAME,
									DOCUMENT_TYPE_COUNT,
									ATTACHMENT_TYPE_CODE,
									RESCAN_REQUEST_ID)
			   VALUES (l_stud_rec_dsa.OBJECT_ID,
					   l_stud_rec_dsa.SESSION_CODE,
					   v_doc_type_code,
					   v_doc_type_name,
					   1,
					   'PDF',
					   NULL);
	   END IF;

	   RETURN TRUE;
	EXCEPTION
	   WHEN OTHERS
	   THEN
		  p_err_mess := p_err_mess || TO_CHAR (SQLCODE);
		  RETURN FALSE;
	END;

	
    -----------------------------------------------------------------------------------------------------------------------------------
    -- Inserts into EDM_COMPLETE
	-----------------------------------------------------------------------------------------------------------------------------------
	FUNCTION create_edm_complete_dsa (
	   l_stud_rec_dsa    IN OUT complete_web_app_dsa@web%ROWTYPE,
	   p_raw_data_id     IN OUT VARCHAR2,
	   p_batch_id        IN OUT VARCHAR2,
	   p_envelope_id     IN OUT VARCHAR2,
	   p_err_mess        IN OUT VARCHAR2,
	   which_db_to_use   IN     VARCHAR2)
	   RETURN BOOLEAN
	IS
	   v_batch_type_code   VARCHAR2 (2);
	   NO_DB_SUPPLIED      EXCEPTION;
	BEGIN
	   p_err_mess := ' Starting TRANSFORM create_edm_complete function';

	   IF l_stud_rec_dsa.dsa_application_type IN ('D', 'd')
	   THEN
		  v_batch_type_code := '95';
	   ELSE
		  p_err_mess :=
			 ' Unable to determine batch type code - COMPLETE_WEB_APPS_DSA application type incorrect ';
		  RETURN FALSE;
	   END IF;

	   p_err_mess := ' WEB transform failed while creating an EDM COMPLETE record';

	   IF l_stud_rec_dsa.dsa_application_type IN ('D', 'd')
	   THEN
		  INSERT INTO EDM.EDM_COMPLETE (OBJECT_ID,
										RAW_DATA_ID,
										BATCH_TYPE_CODE,
										STUD_REF_NO,
										BATCH_ID,
										ENVELOPE_ID,
										SCAN_DATE,
										PROC_ERROR,
										URGENT,
										LEARNER_ID)
			   VALUES (l_stud_rec_dsa.OBJECT_ID,
					   p_raw_data_id,
					   v_batch_type_code,
					   l_stud_rec_dsa.STUD_REF_NO,
					   p_batch_id,
					   p_envelope_id,
					   l_stud_rec_dsa.WEB_SUBMITTED,
					   'N',
					   'N',
					   NULL);
	   END IF;

	   RETURN TRUE;
	EXCEPTION
	   WHEN OTHERS
	   THEN
		  p_err_mess := p_err_mess || TO_CHAR (SQLCODE);
		  RETURN FALSE;
	END;                                                  
   
END DSA_TRANSFORM;
/
