SET TERM ^ ;

create or alter procedure MOVEOPERCOMPLECT (
    COMPLECT_ID integer,
    OPERCOMPLECT_ID integer,
    DOCOUTREESTR_ID integer)
returns (
    RES integer)
as
declare variable OPERFILE_ID integer;
declare variable NAME1 varchar(240);
declare variable NAME varchar(128);
declare variable SHEET1 varchar(10);
declare variable SHEET2 varchar(10);
declare variable FTYPE varchar(6);
declare variable FDATA blob sub_type 0 segment size 500;
declare variable OPERTIME timestamp;
declare variable CREATETIME timestamp;
declare variable AUTHOR_ID integer;
declare variable OPERATOR_ID integer;
declare variable FILES_ID integer;
declare variable OUTFILES_ID integer;
declare variable FSIZE bigint;
begin
  /* Procedure Text */
  RES=0;
  /* Перенести Название комплекта */
  SELECT CAST(name AS VARCHAR(240)) from opercomplect WHERE id=:OPERCOMPLECT_ID INTO :name1;
  if (not(name1 is NULL)and(TRIM(name1)<>'')) then
    UPDATE complect c SET c.name=:name1 WHERE (c.id=:COMPLECT_ID);
  /**/
  /*Вставляем все оперативные файлы в таблицу файлы*/
  FOR SELECT o.id, o.name, o.sheet1, o.sheet2, o.ftype, o.fdata, o.opertime, o.createtime, o.author_id, o.operator_id, o.fsize
      from operfile o
      where (o.opercomplect_id=:opercomplect_id)
      into :operfile_id, :name, :sheet1, :sheet2, :ftype, :fdata, :opertime, :createtime, :author_id, :operator_id, :fsize
  DO  BEGIN
    files_id=GEN_ID(gen_files_id,1);
    insert into "FILES"
       values (:files_id, :complect_id,0, :name, :sheet1, :sheet2, (select exttype_id from getftype(:ftype)), :fdata, 1, :opertime, :createtime,
                :author_id, :operator_id, 1, :fsize);
    --Вставляем все оперативные файлы отправки в таблицу отправок
     FOR SELECT o.name, o.ftype, o.fdata, o.createtime, o.opertime,  o.operator_id, o.fsize
        from operoutfiles o
        where (o.operfile_id=:operfile_id)
        into :name, :ftype, :fdata, :createtime, :opertime, :operator_id, :fsize
        DO BEGIN
          outfiles_id=GEN_ID(gen_outfiles_id,1);
          insert into "OUTFILES"
             values (:outfiles_id, :files_id, :name, (select exttype_id from getftype(:ftype)), :fdata, :opertime, :createtime,
                :author_id, :operator_id, 1, :DOCOUTREESTR_ID, :FSIZE);

        END
    --Удаляем все оперативные файлы отправки для текущего оперфайла
    DELETE FROM OPEROUTFILES WHERE operfile_id=:operfile_id;
  END
  --Удаляем все оперативные файлы для оперкомплекта
  DELETE FROM OPERFILE WHERE OPERCOMPLECT_ID=:OPERCOMPLECT_ID;
  DELETE FROM OPERCOMPLECT WHERE ID=:OPERCOMPLECT_ID;
  RES=1;
  suspend;
end^

SET TERM ; ^

