/* Formatted on 30/06/2015 08:48:59 (QP5 v5.215.12089.38647) */
DELETE FROM std_letters sl
      WHERE sl.doc_name IN
               ('MGR02', 'MGR03', 'MGR04', 'MGR07', 'MGR08', 'MGR10');

COMMIT; 
