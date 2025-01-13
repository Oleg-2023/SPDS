create or alter procedure FINDMARKS (
    PROJOBJ_MARK varchar(50),
    PROJECT_MARK varchar(50),
    PROJNODE_MARK varchar(50),
    COMPLECT_MARK varchar(50),
    FILENAME varchar(50))
returns (
    GENPROJ_ID integer,
    PROJOBJ_ID integer,
    PO_MARK varchar(123),
    PROJECT_ID integer,
    PR_MARK varchar(123),
    PROJNODE_ID integer,
    PN_MARK varchar(96),
    COMPLECT_ID integer,
    COMPL_MARK varchar(131),
    FILE_ID integer,
    FNAME varchar(200))
as
declare variable CHECK_OBJ integer;
declare variable CHECK_PROJ integer;
declare variable CHECK_NODE integer;
declare variable CHECK_COMPL integer;
declare variable CHECK_FILES integer;
begin
  /* Procedure Text */
  /* ≈сли значение входных параметров начинаетс€ с '%' ищетс€ вхождение параметра во всей строке */
  /* ѕо умолчанию ищетс€ совпадение по началу строки */
  /* '%'-добавл€ем в конец каждого  параметра */
  /**/
  CHECK_FILES=IIF(filename is null,  0, 1);
  CHECK_COMPL=IIF((CHECK_FILES=0)and(complect_mark is null),  0, 1);
  CHECK_NODE=IIF((CHECK_COMPL=0)and(projnode_mark is null),  0, 1);
  CHECK_PROJ=IIF((CHECK_NODE=0)and(project_mark is null),  0, 1);
  CHECK_OBJ=IIF((CHECK_PROJ=0)and(PROJOBJ_MARK is null),  0, 1);
  /**/
  GENPROJ_ID=NULL;
  PROJOBJ_ID=NULL; PO_MARK=NULL;
  PROJECT_ID=NULL; PR_MARK=NULL;
  PROJNODE_ID=NULL; PN_MARK=NULL;
  COMPLECT_ID=NULL; COMPL_MARK=NULL;
  file_id=NULL; FNAME=NULL;
 /* Ќедолжно быть никогда */
  if (check_obj=0) then begin
    SUSPEND;
    EXIT;
  end
  /**/
  for select PO.genproj_id as GENPROJ_ID, /*¬сегда выбираем*/
      IIF(:CHECK_OBJ=0, NULL,  PO.id), IIF(:CHECK_OBJ=0, NULL,  PO.obj_name)
    from CONTRAGENT G, PROJOBJVIEW PO
    where (G.PROJECTOR = 1) and
       (PO.GENPROJ_ID = G.ID) and((:projobj_mark is null)or(UPPER(TRIM(PO.obj_name)) like UPPER(TRIM(:projobj_mark))||'%'))
    order by
      g.id, po.mark
    into
      :GENPROJ_ID, :PROJOBJ_ID, :PO_MARK
  do
    if (CHECK_PROJ=0) then
      SUSPEND;
    else
      for select P.id, P.proj_name
        from PROJECTVIEW P
        WHERE (P.PROJOBJ_ID = :PROJOBJ_ID) and
              ((:project_mark is null)or(UPPER(TRIM(P.proj_name)) like UPPER(TRIM(:project_mark))||'%'))
        order by
          p."NO"
        into
          :PROJECT_ID, :PR_MARK
      DO
        if (CHECK_NODE=0) then
          SUSPEND;
        else
          for select PN.id, PN.nodename
            from PROJNODEVIEW PN
            WHERE (PN.PROJ_ID = :PROJECT_ID) and
               ((:projnode_mark is null)or(UPPER(TRIM(PN.nodename)) like UPPER(TRIM(:projnode_mark))||'%'))
            order by
              pn.nodemark, pn.mark
            into
              :PROJNODE_ID, :PN_MARK
         DO
           if (CHECK_COMPL=0) then
             SUSPEND;
           else
             for select  C.id, C.compname
                from COMPLECTVIEW C
                WHERE  (C.PROJNODE_ID = :PROJNODE_ID)and
                  ((:complect_mark is null)or(UPPER(TRIM(C.compname)) like UPPER(TRIM(:complect_mark))||'%'))
                order by
                  C.compkind, c.mark
                into
                  :COMPLECT_ID, :COMPL_MARK
             DO
               if (CHECK_FILES=0) then
                 SUSPEND;
               else
                 for select f.id, f.sheetsandname
                   from FILESVIEW F
                   WHERE  (F.compl_id = :complect_id)and
                    ((:filename is null)or(UPPER(TRIM(f.sheetsandname)) like UPPER(TRIM(:filename))||'%'))
                   order by
                     f.sheetsandname
                   into
                     :file_id,  :FNAME
                 DO
                   SUSPEND;
end