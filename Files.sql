SET SQL DIALECT 3;



/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/


CREATE GENERATOR GEN_FILES_ID;
CREATE GENERATOR IBE$LOG_TABLES_GEN;

CREATE TABLE FILES (
    ID           CODE_DOM NOT NULL /* CODE_DOM = INTEGER NOT NULL */,
    COMPL_ID     CODE_DOM /* CODE_DOM = INTEGER NOT NULL */,
    STATUS       INTEGER DEFAULT 0 NOT NULL,
    NAME         VARCHAR(161),
    SHEET1       VARCHAR(10),
    SHEET2       VARCHAR(10),
    FTYPE_ID     CODE_DOM /* CODE_DOM = INTEGER NOT NULL */,
    FDATA        BLOB SUB_TYPE 0 SEGMENT SIZE 500,
    DOCSTATE     INTEGER DEFAULT 1 NOT NULL,
    ADDTIME      TIMESTAMP NOT NULL,
    CREATETIME   TIMESTAMP NOT NULL,
    AUTHOR_ID    CODE_DOM /* CODE_DOM = INTEGER NOT NULL */,
    OPERATOR_ID  CODE_DOM /* CODE_DOM = INTEGER NOT NULL */,
    FKIND_ID     CODE_DOM DEFAULT 1 /* CODE_DOM = INTEGER NOT NULL */,
    FSIZE        BIGINT
);




/******************************************************************************/
/***                              Primary keys                              ***/
/******************************************************************************/

ALTER TABLE FILES ADD CONSTRAINT PK_FILES PRIMARY KEY (ID);


/******************************************************************************/
/***                              Foreign keys                              ***/
/******************************************************************************/

ALTER TABLE FILES ADD CONSTRAINT FK_FILES_AUTHOR FOREIGN KEY (AUTHOR_ID) REFERENCES PEOPLE (ID);
ALTER TABLE FILES ADD CONSTRAINT FK_FILES_COMPLECT FOREIGN KEY (COMPL_ID) REFERENCES COMPLECT (ID);
ALTER TABLE FILES ADD CONSTRAINT FK_FILES_FTYPE FOREIGN KEY (FTYPE_ID) REFERENCES EXTTYPE (ID);
ALTER TABLE FILES ADD CONSTRAINT FK_FILES_OPER FOREIGN KEY (OPERATOR_ID) REFERENCES PEOPLE (ID);


/******************************************************************************/
/***                                Indices                                 ***/
/******************************************************************************/

CREATE INDEX FILES_IDX1 ON FILES (NAME);


/******************************************************************************/
/***                                Triggers                                ***/
/******************************************************************************/



SET TERM ^ ;



/******************************************************************************/
/***                          Triggers for tables                           ***/
/******************************************************************************/



/* Trigger: FILES_BI */
CREATE OR ALTER TRIGGER FILES_BI FOR FILES
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_FILES_ID,1);
  IF (NEW.ADDTIME IS NULL) THEN
    NEW.ADDTIME = current_timestamp;
END
^


/* Trigger: IBE$FILES_AD */
CREATE OR ALTER TRIGGER IBE$FILES_AD FOR FILES
ACTIVE AFTER DELETE POSITION 32767
AS
DECLARE VARIABLE TID INTEGER;
BEGIN
  TID = GEN_ID(IBE$LOG_TABLES_GEN,1);

  INSERT INTO IBE$LOG_TABLES (ID, TABLE_NAME, OPERATION, DATE_TIME, USER_NAME)
    VALUES (:TID, 'FILES', 'D', 'NOW', USER);

  INSERT INTO IBE$LOG_KEYS (LOG_TABLES_ID, KEY_FIELD, KEY_VALUE)
    VALUES (:TID, 'ID', OLD.ID);


END
^


/* Trigger: IBE$FILES_AI */
CREATE OR ALTER TRIGGER IBE$FILES_AI FOR FILES
ACTIVE AFTER INSERT POSITION 32767
AS
DECLARE VARIABLE TID INTEGER;
BEGIN
  TID = GEN_ID(IBE$LOG_TABLES_GEN,1);

  INSERT INTO IBE$LOG_TABLES (ID, TABLE_NAME, OPERATION, DATE_TIME, USER_NAME)
    VALUES (:TID, 'FILES', 'I', 'NOW', USER);

  INSERT INTO IBE$LOG_KEYS (LOG_TABLES_ID, KEY_FIELD, KEY_VALUE)
    VALUES (:TID, 'ID', NEW.ID);


END
^


/* Trigger: IBE$FILES_AU */
CREATE OR ALTER TRIGGER IBE$FILES_AU FOR FILES
ACTIVE AFTER UPDATE POSITION 32767
AS
DECLARE VARIABLE TID INTEGER;
BEGIN
  TID = GEN_ID(IBE$LOG_TABLES_GEN,1);

  INSERT INTO IBE$LOG_TABLES (ID, TABLE_NAME, OPERATION, DATE_TIME, USER_NAME)
    VALUES (:TID, 'FILES', 'U', 'NOW', USER);

  INSERT INTO IBE$LOG_KEYS (LOG_TABLES_ID, KEY_FIELD, KEY_VALUE)
    VALUES (:TID, 'ID', OLD.ID);


END
^

SET TERM ; ^



/******************************************************************************/
/***                          Fields descriptions                           ***/
/******************************************************************************/

COMMENT ON COLUMN FILES.STATUS IS 
'-1 -Аннулирован
 0 -Действующий
 >0 - Код замены';

COMMENT ON COLUMN FILES.DOCSTATE IS 
'1-Рабочий
3-Рабочий+Отправка';

COMMENT ON COLUMN FILES.AUTHOR_ID IS 
'Автор документа';

COMMENT ON COLUMN FILES.FKIND_ID IS 
'Полученный, отправленный  заказчику';

COMMENT ON COLUMN FILES.FSIZE IS 
'Размер данных в байтах';



