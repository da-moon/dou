
/* Database initialization script. Variables:              ******/
/* <sm_db_name> - Name of the Server Manager tablespace   ******/
/* <sm_db_user> - The Server Manager database user        ******/
/* <sm_db_pass> - The Server Manager password for db user ******/
/* <infodba_user> - Infodba user name                     ******/
/* <infodba_pass> - Infodba password                      ******/

REM Adaptation from Tc13.0.0.0_lnx64/tc/db_scripts/oracle/oracle_create_servermanager.sql.template
prompt Creating Server Manager database
CREATE tablespace ${sm_db_name} datafile size 10M autoextend on maxsize 200M;
CREATE user {sm_db_user} identified by "{sm_db_pass}" default tablespace ${sm_db_name} temporary tablespace TEMP quota 200M on ${sm_db_name};
GRANT connect to {sm_db_user};
GRANT create table to {sm_db_user};
CREATE TABLESPACE "IDATA" LOGGING  DATAFILE  SIZE 500M AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED;
CREATE TABLESPACE "ILOG" LOGGING  DATAFILE   SIZE 50M AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED;
CREATE TABLESPACE "INDX" LOGGING  DATAFILE   SIZE 50M AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED;

REM Adaptation from Tc13.0.0.0_lnx64/tc/db_scripts/oracle/create_user.sql
prompt Creating infodba account and granting privileges.
GRANT Connect, Create table, Create tablespace, Create procedure, Create view, create sequence, Select_catalog_role, alter user, alter session, Create trigger to {infodba_user} identified by "{infodba_pass}";
prompt Setting default tablespaces for the infodba account.
ALTER user {infodba_user} default tablespace idata temporary tablespace temp;
ALTER USER {infodba_user} QUOTA UNLIMITED ON "IDATA" QUOTA UNLIMITED ON "ILOG" QUOTA UNLIMITED ON "INDX";
EXIT;
