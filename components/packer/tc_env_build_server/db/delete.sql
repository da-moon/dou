prompt Deleting previous data
DROP tablespace ${sm_db_name};
DROP user {sm_db_user};
DROP user {infodba_user};
DROP tablespace "IDATA";
DROP tablespace "ILOG";
DROP tablespace "INDX";

EXIT;

