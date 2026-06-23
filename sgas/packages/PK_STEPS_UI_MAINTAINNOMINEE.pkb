CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_maintainnominee
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
   )
   AS
   BEGIN
      SELECT n.forename, n.surname, n.company_name, n.payee_name,
             n.house_no_name, n.addr_l1, n.addr_l2, n.addr_l3,
             n.addr_l4, n.post_code, n.telephone_no, n.account_no,
             n.sort_code, n.payment_method
        INTO forename_out, surname_out, company_name_out, payee_name_out,
             house_no_name_out, addr_l1_out, addr_l2_out, addr_l3_out,
             addr_l4_out, post_code_out, telephone_no_out, account_no_out,
             sort_code_out, payment_method_out
        FROM nominee n
       WHERE n.nominee_id = nominee_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getnominee;

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
   )
   AS
   BEGIN
      UPDATE nominee nom
         SET nom.forename = UPPER (forename_in),
             nom.surname = UPPER (surname_in),
             nom.company_name = UPPER (company_name_in),
             nom.payee_name = UPPER (payee_name_in),
             nom.house_no_name = UPPER (house_no_name_in),
             nom.addr_l1 = UPPER (addr_l1_in),
             nom.addr_l2 = UPPER (addr_l2_in),
             nom.addr_l3 = UPPER (addr_l3_in),
             nom.addr_l4 = UPPER (addr_l4_in),
             nom.post_code = UPPER (post_code_in),
             nom.telephone_no = UPPER (telephone_no_in),
             nom.account_no = UPPER (account_no_in),
             nom.sort_code = UPPER (sort_code_in),
             nom.payment_method = UPPER (payment_method_in),
             nom.last_updated_by = UPPER (last_updated_by_in),
             nom.last_updated_on = SYSDATE
       WHERE nom.nominee_id = nominee_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setnominee;

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
   )
   IS
   BEGIN
      INSERT INTO nominee
                  (forename, 
                   surname,
                   company_name, 
                   payee_name,
                   house_no_name, addr_l1,
                   addr_l2, addr_l3,
                   addr_l4, post_code,
                   telephone_no, account_no,
                   sort_code, payment_method,
                   last_updated_by, last_updated_on
                  )
           VALUES (UPPER (TRIM(BOTH ' ' FROM forename_in)), 
                   UPPER (TRIM(BOTH ' ' FROM surname_in)),
                   UPPER (TRIM(BOTH ' ' FROM company_name_in)), 
                   UPPER (payee_name_in),
                   UPPER (house_no_name_in), UPPER (addr_l1_in),
                   UPPER (addr_l2_in), UPPER (addr_l3_in),
                   UPPER (addr_l4_in), UPPER (post_code_in),
                   UPPER (telephone_no_in), UPPER (account_no_in),
                   UPPER (sort_code_in), UPPER (payment_method_in),
                   UPPER (employee_in), SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';         
         ERROR_TEXT :=  ' SQLCODE= ' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertnominee;
END pk_steps_ui_maintainnominee;
/
