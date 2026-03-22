# SPDS
## Краткий обзор системы передачи и хранения проектно-сметной документации
## Общий вид. Рабочее место администратора.
![image](./images/Admin.jpg)
![image](./images/Admin_doc_transfer.jpg)
## Общий вид. Рабочее место пользователя.
![image](./images/Client.jpg)
## Технологический стек:  
__SQL Firebid__: SQL система управления базами данных, клон Interbase, DDL(Data Definition Language) аналогичен Postgres.   
__Code Gear Delphi 2007__: гибкость, широкий функционал для обработки данных. Возможность использовать разнообразные библиотеки.      

Схема базы данных и связи таблиц приведены в файле [__spds-structure.pdf__](files/spds-structure.pdf)
Примеры определения таблиц: [__complect__](./files/complect.sql), [__files__](files/files.sql)  
Примеры определения хранимых процедур: [__findmarks.sp__](files/findmarks.sp), [__MOVEOPERCOMPLECT.sp__](files/moveopercomplect.sp)  
