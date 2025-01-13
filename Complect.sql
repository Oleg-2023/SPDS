SET SQL DIALECT 3;



/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/


CREATE GENERATOR GEN_COMPLECT_ID;
CREATE GENERATOR IBE$LOG_TABLES_GEN;

CREATE TABLE COMPLECT (
    ID           CODE_DOM NOT NULL /* CODE_DOM = INTEGER NOT NULL */,
    PROJNODE_ID  CODE_DOM /* CODE_DOM = INTEGER NOT NULL */,
    COMPKIND_ID  CODE_DOM /* CODE_DOM = INTEGER NOT NULL */,
    STATUS       INTEGER DEFAULT 0 NOT NULL,
    MARK         VARCHAR(120),
    NAME         VARCHAR(240),
    REMARKS      BLOB SUB_TYPE 1 SEGMENT SIZE 80
);




/******************************************************************************/
/***                              Primary keys                              ***/
/******************************************************************************/

ALTER TABLE COMPLECT ADD CONSTRAINT PK_COMPLECT PRIMARY KEY (ID);


/******************************************************************************/
/***                              Foreign keys                              ***/
/******************************************************************************/

ALTER TABLE COMPLECT ADD CONSTRAINT FK_COMPLECT_CN FOREIGN KEY (COMPKIND_ID) REFERENCES COMPKIND (ID);
ALTER TABLE COMPLECT ADD CONSTRAINT FK_COMPLECT_PN FOREIGN KEY (PROJNODE_ID) REFERENCES PROJNODE (ID);


/******************************************************************************/
/***                                Indices                                 ***/
/******************************************************************************/

CREATE INDEX COMPLECT_IDX1 ON COMPLECT (MARK);


/******************************************************************************/
/***                                Triggers                                ***/
/******************************************************************************/



SET TERM ^ ;



/******************************************************************************/
/***                          Triggers for tables                           ***/
/******************************************************************************/



/* Trigger: COMPLECT_BI */
CREATE OR ALTER TRIGGER COMPLECT_BI FOR COMPLECT
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_COMPLECT_ID,1);
END
^


/* Trigger: IBE$COMPLECT_AD */
CREATE OR ALTER TRIGGER IBE$COMPLECT_AD FOR COMPLECT
ACTIVE AFTER DELETE POSITION 32767
AS
DECLARE VARIABLE TID INTEGER;
BEGIN
  TID = GEN_ID(IBE$LOG_TABLES_GEN,1);

  INSERT INTO IBE$LOG_TABLES (ID, TABLE_NAME, OPERATION, DATE_TIME, USER_NAME)
    VALUES (:TID, 'COMPLECT', 'D', 'NOW', USER);

  INSERT INTO IBE$LOG_KEYS (LOG_TABLES_ID, KEY_FIELD, KEY_VALUE)
    VALUES (:TID, 'ID', OLD.ID);


END
^


/* Trigger: IBE$COMPLECT_AI */
CREATE OR ALTER TRIGGER IBE$COMPLECT_AI FOR COMPLECT
ACTIVE AFTER INSERT POSITION 32767
AS
DECLARE VARIABLE TID INTEGER;
BEGIN
  TID = GEN_ID(IBE$LOG_TABLES_GEN,1);

  INSERT INTO IBE$LOG_TABLES (ID, TABLE_NAME, OPERATION, DATE_TIME, USER_NAME)
    VALUES (:TID, 'COMPLECT', 'I', 'NOW', USER);

  INSERT INTO IBE$LOG_KEYS (LOG_TABLES_ID, KEY_FIELD, KEY_VALUE)
    VALUES (:TID, 'ID', NEW.ID);


END
^


/* Trigger: IBE$COMPLECT_AU */
CREATE OR ALTER TRIGGER IBE$COMPLECT_AU FOR COMPLECT
ACTIVE AFTER UPDATE POSITION 32767
AS
DECLARE VARIABLE TID INTEGER;
BEGIN
  TID = GEN_ID(IBE$LOG_TABLES_GEN,1);

  INSERT INTO IBE$LOG_TABLES (ID, TABLE_NAME, OPERATION, DATE_TIME, USER_NAME)
    VALUES (:TID, 'COMPLECT', 'U', 'NOW', USER);

  INSERT INTO IBE$LOG_KEYS (LOG_TABLES_ID, KEY_FIELD, KEY_VALUE)
    VALUES (:TID, 'ID', OLD.ID);


END
^

SET TERM ; ^



/******************************************************************************/
/***                          Fields descriptions                           ***/
/******************************************************************************/

COMMENT ON COLUMN COMPLECT.STATUS IS 
'-1 -Аннулирован
 0 -Действующий
 >0 - Код замены';



