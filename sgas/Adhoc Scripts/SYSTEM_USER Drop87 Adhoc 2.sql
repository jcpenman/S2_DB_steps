-- You need to be logged in as SYSTEM to create the oracle directory

create or replace directory ed8_dir as '/projects/sgas/temp/reports/'; 

grant read,write on directory ed8_dir to public;