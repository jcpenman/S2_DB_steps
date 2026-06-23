/* Formatted on 2010/08/02 15:03 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE sgas.pk_steps_ui_maintainnominee
AS
   PROCEDURE getnominee (
      nominee_id_in        IN              VARCHAR2,
      forename_out         OUT NOCOPY      VARCHAR2,
      surname_out          OUT NOCOPY      VARCHAR2,
      company_name_out     OUT NOCOPY      VARCHAR2,
      payee_name_out       OUT NOCOPY      VARCHAR2,
      house_no_name_out    OUT NOCOPY      VARCHAR2,
      addr_l1_out          OUT NOCOPY      VARCHAR2,
      addr_l2_out          OUT NOCOPY      VARCHAR2,
      addr_l3_out          OUT NOCOPY      VARCHAR2,
      addr_l4_out          OUT NOCOPY      VARCHAR2,
      post_code_out        OUT NOCOPY      VARCHAR2,
      telephone_no_out     OUT NOCOPY      VARCHAR2,
      account_no_out       OUT NOCOPY      VARCHAR2,
      sort_code_out        OUT NOCOPY      VARCHAR2,
      payment_method_out   OUT NOCOPY      VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE setnominee (
      nominee_id_in        IN              VARCHAR2,
      forename_in          IN              VARCHAR2,
      surname_in           IN              VARCHAR2,
      company_name_in      IN              VARCHAR2,
      payee_name_in        IN              VARCHAR2,
      house_no_name_in     IN              VARCHAR2,
      addr_l1_in           IN              VARCHAR2,
      addr_l2_in           IN              VARCHAR2,
      addr_l3_in           IN              VARCHAR2,
      addr_l4_in           IN              VARCHAR2,
      post_code_in         IN              VARCHAR2,
      telephone_no_in      IN              VARCHAR2,
      account_no_in        IN              VARCHAR2,
      sort_code_in         IN              VARCHAR2,
      payment_method_in    IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2
   );

   PROCEDURE insertnominee (
      forename_in         IN              VARCHAR2,
      surname_in          IN              VARCHAR2,
      company_name_in     IN              VARCHAR2,
      payee_name_in       IN              VARCHAR2,
      house_no_name_in    IN              VARCHAR2,
      addr_l1_in          IN              VARCHAR2,
      addr_l2_in          IN              VARCHAR2,
      addr_l3_in          IN              VARCHAR2,
      addr_l4_in          IN              VARCHAR2,
      post_code_in        IN              VARCHAR2,
      telephone_no_in     IN              VARCHAR2,
      account_no_in       IN              VARCHAR2,
      sort_code_in        IN              VARCHAR2,
      payment_method_in   IN              VARCHAR2,
      employee_in         IN              VARCHAR2,
      error_boolean       OUT NOCOPY      VARCHAR2,
      ERROR_TEXT          OUT NOCOPY      VARCHAR2
   );
END pk_steps_ui_maintainnominee;
/