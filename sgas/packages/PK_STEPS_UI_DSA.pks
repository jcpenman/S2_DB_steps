CREATE OR REPLACE PACKAGE SGAS.pk_steps_ui_dsa
AS
/******************************************************************************
   NAME:       pk_steps_ui_DSA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008      PADDY GRACE           Created this package.
   1.1        13/10/2009     ABIRAMI CHIDAMBARAM   Code Population
******************************************************************************/
   TYPE personaldetails_cursor IS REF CURSOR;

   TYPE allowancesummary_cursor IS REF CURSOR;

   TYPE allowancedetails_cursor IS REF CURSOR;

   TYPE allowancerecord_cursor IS REF CURSOR;

   TYPE allowancepayment_cursor IS REF CURSOR;

   TYPE paymentdetails_cursor IS REF CURSOR;

   TYPE nomineesselected_cursor IS REF CURSOR;

   TYPE countduplicates_cursor IS REF CURSOR;

   PROCEDURE insertdefaultdsaapplication (
      stud_ref_no_in          IN              VARCHAR2,
      session_code_in         IN              VARCHAR2,
      last_updated_by_in      IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2,
      row_count               OUT             NUMBER,
      dsaapplication_id_out   OUT             VARCHAR2
   );

   PROCEDURE getpersonaldetails (
      stud_ref_no_in    IN              NUMBER,
      session_code_in   IN              NUMBER,
      io_cursor         IN OUT          personaldetails_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setpersonaldetails (
      dsa_app_id_in                  IN       VARCHAR2,
      disability_type_id_in          IN       VARCHAR2,
      date_application_received_in   IN       DATE,
      priortiy_app_in                IN       VARCHAR2,
      referred_flag_in               IN       VARCHAR2,
      date_ref_access_centre_in      IN       DATE,
      dsa_referral_reason_id_in      IN       VARCHAR2,
      assessment_centre_id_in        IN       VARCHAR2,
      rejected_in                    IN       VARCHAR2,
      dsa_rejection_reason_id_in     IN       VARCHAR2,
      consent_ticked_in              IN       VARCHAR2,
      other_information_in           IN       VARCHAR2,
      dsa_student_type_id_in         IN       VARCHAR2,
      part_time_course_in            IN       VARCHAR2,
      needs_assessor_in              IN       VARCHAR2,
      date_assess_rep_received_in    IN       DATE,
      date_assess_rep_processed_in   IN       DATE,
      assessor_hourly_rate_in        IN       VARCHAR2,
      processing_days_in             IN       VARCHAR2,
      assess_fee_amount_in           IN       VARCHAR2,
      more_info_req_in               IN       VARCHAR2,
      exceptional_case_in            IN       VARCHAR2,
      dsa_app_status_in                 IN       VARCHAR2,
      is_online_in                      IN       VARCHAR2,      
      dis_hearing_impairment_in      IN       VARCHAR2,          
      dis_learning_difficulty_in     IN       VARCHAR2,      
      dis_long_standing_illness_in     IN       VARCHAR2,      
      dis_mental_health_cond_in          IN       VARCHAR2,      
      dis_phys_impairment_in          IN       VARCHAR2,      
      dis_soc_or_comms_impairment_in IN       VARCHAR2,      
      dis_visual_impairment_in          IN       VARCHAR2,      
      dis_not_listed_in                  IN       VARCHAR2,      
      dis_other_disability_in         IN       VARCHAR2,      
      extension_end_date_in             IN          DATE, 
      user_in                        IN       VARCHAR2,
      error_boolean                  OUT      VARCHAR2,
      ERROR_TEXT                     OUT      VARCHAR2,
      row_count_da                   OUT      VARCHAR2
   );

   PROCEDURE getallowancesummary (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          allowancesummary_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getallowancedetails (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          allowancedetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertallowancedetails (
      application_id_in                  IN       NUMBER,
      stud_session_id_in                 IN       NUMBER,
      stud_crse_year_id_in               IN       NUMBER,
      category_id_in                     IN       NUMBER,
      max_amt_in                         IN       NUMBER,
      overridetype_in                    IN       VARCHAR2,
      overridedsa_in                     IN       VARCHAR2,
      user_in                            IN       VARCHAR2,
      nmph_hours_in                      IN         NUMBER,
      nmph_hourly_rate_in                 IN         NUMBER,
      nmph_weeks_in                         IN         NUMBER,
      nmph_recommended_provider_in         IN          VARCHAR2,
      travel_journeys_in                IN         NUMBER,
      travel_costs_in                    IN         NUMBER,
      travel_weeks_in                    IN         NUMBER,
      travel_recommended_provider_in    IN          VARCHAR2,
      travel_provider_id_in                IN         NUMBER,   
      nmph_type_of_support_in              IN          VARCHAR2,      
      error_boolean                      OUT      VARCHAR2,
      ERROR_TEXT                         OUT      VARCHAR2,
      row_count                          OUT      VARCHAR2
   );

   PROCEDURE countduplicatecategories (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   countduplicates_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE showallowancerecord (
      stud_crse_year_id_in   IN              NUMBER,
      type_id_in             IN              VARCHAR2,
      io_cursor              IN OUT          allowancerecord_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setallowancedetails (
      dsa_all_id_in                   IN       NUMBER,
      category_in                     IN       VARCHAR2,
      max_amt_in                      IN       NUMBER,
      user_in                         IN       VARCHAR2,
      --nmph_hours_in                  IN         NUMBER,
      --nmph_hourly_rate_in             IN         NUMBER,
      --nmph_weeks_in                     IN         NUMBER,
      --nmph_recommended_provider_in     IN          VARCHAR2,           
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2,
      row_count_da                    OUT      VARCHAR2
   );

   PROCEDURE deleteallowancedetails (
      id_in           IN              NUMBER,
      employee_in     IN              VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2,
      row_count       OUT             VARCHAR2
   );

   PROCEDURE getstudnominees (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          nomineesselected_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertstudnominee (
      stud_ref_no_in       IN              VARCHAR2,
      nominee_id_in        IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   );

   PROCEDURE getpaymentdetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          paymentdetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   );

   PROCEDURE getallowancepayments (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   allowancepayment_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

   PROCEDURE processreceipt (
      stud_award_type_in               IN       VARCHAR2,
      stud_award_type_description_in   IN       VARCHAR2,
      stud_crse_year_id_in             IN       VARCHAR2,
      dsa_allowance_id_in              IN       VARCHAR2,
      nominee_id_in                    IN       VARCHAR2,
      payee_type_in                    IN       VARCHAR2,
      payee_id_in                      IN       VARCHAR2,
      amount_in                        IN       VARCHAR2,
      reference_in                     IN       VARCHAR2,
      amount_rate_in                   IN       VARCHAR2,
      period_in                        IN       VARCHAR2,
      travel_element_in                IN       VARCHAR2,
      due_date_in                      IN       DATE,
      invoice_ref_in                   IN       VARCHAR2,
      notes_in                         IN       VARCHAR2,
      receipt_required_in              IN       VARCHAR2,
      receipt_received_in              IN       VARCHAR2,
      receipt_amount_in                IN       VARCHAR2,
      period_start_date_in             IN       DATE,
      period_end_date_in               IN       DATE,
      payment_type_in                  IN       VARCHAR2,
      employee_in                      IN       VARCHAR2,
      error_boolean                    OUT      VARCHAR2,
      ERROR_TEXT                       OUT      VARCHAR2
   );

   PROCEDURE getstuddsaotherlimits (
      stud_award_type_scheme_in   IN              VARCHAR2,
      session_code_in             IN              VARCHAR2,
      disab_basic_max_out         OUT NOCOPY      VARCHAR2,
      disab_equip_max_out         OUT NOCOPY      VARCHAR2,
      disab_non_med_max_out       OUT NOCOPY      VARCHAR2,
      disab_trav_max_out          OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   );

   PROCEDURE removeallocatednominee (
      stud_ref_no_in  IN       VARCHAR2,
      nom_id_in       IN       NUMBER,
      user_in         IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   );

   PROCEDURE getparttimedetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      dsa_stud_type_id_out   OUT      VARCHAR2,
      part_time_course_out   OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );
   
   PROCEDURE isneedsassessreportrequired (
      stud_crse_year_id_in   IN       VARCHAR2,
      is_required_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );

 PROCEDURE haspaymentbeenmade(
      id_in                  IN       VARCHAR2,
      payment_made           OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   );
 PROCEDURE updateallowancedetails (
      dsa_all_id_in                   IN        NUMBER,
      category_id_in                  IN      VARCHAR2,
      max_amt_in                      IN      NUMBER,
      user_in                         IN      VARCHAR2,
      nmph_hours_in                 IN      NUMBER,
      nmph_hourly_rate_in           IN      NUMBER,
      nmph_weeks_in                 IN      NUMBER,
      nmph_recommended_provider_in  IN      VARCHAR2,           
      travel_journeys_in                IN         NUMBER,
      travel_costs_in                    IN         NUMBER,
      travel_weeks_in                    IN         NUMBER,
      travel_recommended_provider_in    IN          VARCHAR2,
      travel_provider_id_in                IN         NUMBER,
      nmph_type_of_support_in          IN      VARCHAR2,
      error_boolean                   OUT     VARCHAR2,
      ERROR_TEXT                      OUT     VARCHAR2,
      row_count_da                    OUT     VARCHAR2
   );   
 PROCEDURE getdasallowancedetails (
      dsa_id_in               IN       NUMBER,
      available_amount_out    OUT      VARCHAR2,
      max_amount_out          OUT      VARCHAR2,
      paid_amount_out         OUT      VARCHAR2, 
      travel_amount_out       OUT      VARCHAR2,
      stud_session_id_out     OUT      VARCHAR2,
      stud_crse_year_id_out   OUT      VARCHAR2,  
      payment_due_date_out    OUT      VARCHAR2,
      date_paid_out           OUT      VARCHAR2,
      dsa_application_id_out  OUT      VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2            
   );   
  PROCEDURE getPayment(
      dsp_id_in               IN       VARCHAR2,
      paid_amount_out         OUT      VARCHAR2,
      amount_out              OUT      VARCHAR2,
      reference_out           OUT      VARCHAR2, 
      travel_amount           OUT      VARCHAR2,
      invoice_ref             OUT      VARCHAR2, 
      due_date                OUT      VARCHAR2,
      receipt_amount          OUT      VARCHAR2, 
      receipt_required        OUT      VARCHAR2,      
      receipt_received        OUT      VARCHAR2,
      nominee_id              OUT      VARCHAR2,
      nominee_type            OUT      VARCHAR2,
      category_out            OUT      VARCHAR2,
      payment_status          OUT      VARCHAR2,
      allowance_id            OUT      VARCHAR2,      
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2             
  );   
  PROCEDURE updatePayment(
      dsp_id_in               IN       VARCHAR2,
      amount_in               IN       VARCHAR2,
      reference_in            IN       VARCHAR2, 
      travel_amount_in        IN       VARCHAR2,
      invoice_ref_in          IN       VARCHAR2, 
      due_date                IN       VARCHAR2,
      receipt_amount_in       IN       VARCHAR2, 
      receipt_required_in     IN       VARCHAR2,      
      receipt_received_in     IN       VARCHAR2,
      user_in                 IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2         
  );
  PROCEDURE deletePayment(
       dsap_id_in             IN       VARCHAR2,
       user_in                IN       VARCHAR2,
       error_boolean          OUT      VARCHAR2,
       ERROR_TEXT             OUT      VARCHAR2         
  );
  
  PROCEDURE getDSACorrespondenceTask(
       stud_ref_no            IN       VARCHAR2,
       noOfTasks              OUT      VARCHAR2,
       error_boolean          OUT      VARCHAR2,
       ERROR_TEXT             OUT      VARCHAR2         
  );
  
  PROCEDURE updateDsaAppStatus (          
      stud_ref_no_in            IN      NUMBER,
      session_code_in           IN      NUMBER,            
      dsa_app_status_id_in      IN      NUMBER,
      user_in                    IN      VARCHAR2,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  );  
    
  PROCEDURE getCourseEndDateByDsaAppId (          
      dsa_app_id_in             IN      NUMBER,
      course_end_date           OUT     DATE,
	  course_end_date_plus_six  OUT     DATE,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  );  
  
END pk_steps_ui_dsa;
/
