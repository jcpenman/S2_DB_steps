-- Database links for ILA500 schema
--
-- MODIFICATION HISTORY 
-- Ref.     Date            Author                          Desc.
--          07/10/2008    S Durkin (Sopra UK)     Initial Version
--
-- Configuration Management: 
-- $HeadURL:  $ 
-- $Author: $ 
-- $Date:  $ 
-- $Revision:  $ 

DROP DATABASE LINK ILA200;

CREATE DATABASE LINK ILA200
 CONNECT TO ILA
 IDENTIFIED BY "t3sting"
 USING 'ILAINSIT';
 
Drop database link SAASEDMT;

create database link "SAASEDMT"
connect to EIW
identified by "EIW"
using 'gv26eda:1521/EISNSU1'; 