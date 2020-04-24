SQL> set echo on;
SQL> @D:/views.sql
SQL> --*****************************************************
SQL> --CS 2258				     B.Senthil Kumar
SQL> --DBMS Lab 			     Asst. Prof
SQL> -- 			 Computer Science Department
SQL> -- 			  SSN College of Engineering
SQL> -- 				  senthil@ssn.edu.in
SQL> --*****************************************************
SQL> -- 	       AIRLINES DATASET
SQL> -- 		Version 1.0
SQL> -- 	       February 05, 2013
SQL> --*****************************************************
SQL> --Sources:
SQL> -- 	To create airlines database run the following
SQL> --      two script files which will create and populate
SQL> --      the databases.
SQL> --
SQL> --******************************************************
SQL> @D:/dbms/air_cre;
SP2-0310: unable to open file "D:/dbms/air_cre.sql"
SQL> @D:/dbms/air_pop;
SP2-0310: unable to open file "D:/dbms/air_pop.sql"
SQL> set echo on;
SQL> set linesize 200;
SQL> set pagesize 50;
SQL> 
SQL> REM : Dropping views....
SQL> 
SQL> drop view schedule_15;

View dropped.

SQL> drop view airtype;

View dropped.

SQL> drop view losangeles_route;

View dropped.

SQL> drop view losangeles_flight;

View dropped.

SQL> 
SQL> 
SQL> REM:------------------------------------------------------
> REM : 1
SQL> REM : Create a view Schedule_15 that display the flight number, route, airport(origin, destination)
SQL> REM : departure (date, time), arrival (date, time) of a flight on 15 apr 2005. Label the view column
SQL> REM : as flight, route, from_airport, to_airport, ddate, dtime, adate, atime respectively.
SQL> 
SQL> create view schedule_15(flight,route,from_airport,to_airport,ddate,dtime,adate,atime)
  2  as
  3  select
  4  	     f.flightNo,r.routeId,r.orig_airport,r.dest_airport,
  5  	     fl.departs,fl.dtime,fl.arrives,fl.atime
  6  from
  7  	     routes r,flights f,fl_schedule fl where f.rid = r.routeId
  8  	     and f.flightNo = fl.flno and fl.departs = '15-apr-2005';

View created.

SQL> 
SQL> select * from schedule_15;

FLIGHT  ROUTE  FROM_AIRPORT         TO_AIRPORT           DDATE          DTIME ADATE          ATIME                                                                                                      
------- ------ -------------------- -------------------- --------- ---------- --------- ----------                                                                                                      
JJ-2482 LW100  Los Angeles          Washington D.C.      15-APR-05       1230 15-APR-05       1540                                                                                                      
SQ-11   LT105  Los Angeles          Tokyo                15-APR-05       1230 16-APR-05       2055                                                                                                      
HA-1    LH106  Los Angeles          Honolulu             15-APR-05       1110 15-APR-05       1445                                                                                                      
A5-3246 CN151  Chicago              New York             15-APR-05       1810 15-APR-05       1900                                                                                                      
9E-3851 MD200  Madison              Detroit              15-APR-05       1035 15-APR-05       1140                                                                                                      
MQ-4477 DN250  Detroit              New York             15-APR-05       1510 15-APR-05       1600                                                                                                      
RP-5018 MC201  Madison              Chicago              15-APR-05       2100 15-APR-05       2155                                                                                                      
BA-178  NYL400 New York             London               15-APR-05       1140 16-APR-05       1020                                                                                                      

8 rows selected.

SQL> 
SQL> savepoint point1;

Savepoint created.

SQL> 
SQL> --Error updatings...
SQL> 	     update schedule_15 set flight='9E-3749' where route='MD200';
	update schedule_15 set flight='9E-3749' where route='MD200'
	                       *
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> 
SQL> REM : updating the values in views will also update the table....
SQL> 
SQL> 	     update schedule_15 set dtime = 1130 where flight = 'HA-1';

1 row updated.

SQL> --View table
SQL> 	     select * from schedule_15 where flight = 'HA-1';

FLIGHT  ROUTE  FROM_AIRPORT         TO_AIRPORT           DDATE          DTIME ADATE          ATIME                                                                                                      
------- ------ -------------------- -------------------- --------- ---------- --------- ----------                                                                                                      
HA-1    LH106  Los Angeles          Honolulu             15-APR-05       1130 15-APR-05       1445                                                                                                      

SQL> --Base table
SQL> 	     select flno,dtime from fl_schedule where flno = 'HA-1';

FLNO         DTIME                                                                                                                                                                                      
------- ----------                                                                                                                                                                                      
HA-1          1130                                                                                                                                                                                      

SQL> 
SQL> 	     update schedule_15 set adate = '16-APR-05' where flight = 'HA-1';

1 row updated.

SQL> --View table
SQL> 	     select * from schedule_15 where flight = 'HA-1';

FLIGHT  ROUTE  FROM_AIRPORT         TO_AIRPORT           DDATE          DTIME ADATE          ATIME                                                                                                      
------- ------ -------------------- -------------------- --------- ---------- --------- ----------                                                                                                      
HA-1    LH106  Los Angeles          Honolulu             15-APR-05       1130 16-APR-05       1445                                                                                                      

SQL> --Base table
SQL> 	     select flno,arrives from fl_schedule where flno = 'HA-1';

FLNO    ARRIVES                                                                                                                                                                                         
------- ---------                                                                                                                                                                                       
HA-1    16-APR-05                                                                                                                                                                                       

SQL> 
SQL> REM : deleting the values in views will also delete in the base table....
SQL> 	     delete from schedule_15 where flight = 'HA-1';

1 row deleted.

SQL> --View table
SQL> 	     select * from schedule_15 where flight = 'HA-1';

no rows selected

SQL> --Base table
SQL> 	     select * from fl_schedule where flno = 'HA-1';

no rows selected

SQL> 
SQL> REM : Insertion cannot be done in view tables...
SQL> insert into schedule_15 values('HA-1','LH106','Los Angeles','Honolulu','15-apr-05','1230','16-apr-05','2055');
insert into schedule_15 values('HA-1','LH106','Los Angeles','Honolulu','15-apr-05','1230','16-apr-05','2055')
*
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> 
SQL> rollback to point1;

Rollback complete.

SQL> 
SQL> REM:--------------------------------------------------------------------
> 
SQL> REM:2.
SQL> REM:Define a view Airtype that display the number of aircrafts for each of its type. Label the
SQL> REM:column as craft_type, total.
SQL> 
SQL> create view Airtype(craft_type,count)
  2  AS
  3  (select type,count(*)
  4  from aircraft
  5  group by type);

View created.

SQL> select * from Airtype;

CRAFT_TYPE      COUNT                                                                                                                                                                                   
---------- ----------                                                                                                                                                                                   
Boeing              6                                                                                                                                                                                   
Saab                1                                                                                                                                                                                   
Airbus              3                                                                                                                                                                                   
BAe                 1                                                                                                                                                                                   
Schweizer           1                                                                                                                                                                                   
Piper               1                                                                                                                                                                                   
Lockheed            1                                                                                                                                                                                   
Tupolev             1                                                                                                                                                                                   
Embraer             1                                                                                                                                                                                   

9 rows selected.

SQL> 
SQL> REM:update can not be done in this view...
SQL> 
SQL> update airtype set total = 18 where craft_type='Airbus';
update airtype set total = 18 where craft_type='Airbus'
                   *
ERROR at line 1:
ORA-00904: "TOTAL": invalid identifier 


SQL> 
SQL> REM : deleting can not happen in this view....
SQL> 	     delete from Airtype where craft_type='Airbus';
	delete from Airtype where craft_type='Airbus'
	            *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> 
SQL> REM : Insertion cannot be done in this view tables...
SQL> 	     insert into Airtype values('Indigo','7');
	insert into Airtype values('Indigo','7')
*
ERROR at line 1:
ORA-01733: virtual column not allowed here 


SQL> 
SQL> REM:-----------------------------------------------------------------
> REM : 3
SQL> REM : Create a view Losangeles_Route that display the information about Los Angeles route.
SQL> REM : Ensure that the view always contain/allows only information about the Los Angeles route.
SQL> 
SQL> create or replace view Losangeles_Route
  2  as select * from routes r
  3  where ((orig_airport='Los Angeles') or (dest_airport='Los Angeles'));

View created.

SQL> 
SQL> -- Displaying the Losangeles_Route view
SQL> select * from Losangeles_Route;

ROUTEI ORIG_AIRPORT         DEST_AIRPORT           DISTANCE                                                                                                                                             
------ -------------------- -------------------- ----------                                                                                                                                             
LW100  Los Angeles          Washington D.C.            2308                                                                                                                                             
LC101  Los Angeles          Chicago                    1804                                                                                                                                             
LD102  Los Angeles          Dallas                     1251                                                                                                                                             
LB103  Los Angeles          Boston                     2606                                                                                                                                             
LS104  Los Angeles          Sydney                     7487                                                                                                                                             
LT105  Los Angeles          Tokyo                      5478                                                                                                                                             
LH106  Los Angeles          Honolulu                   2551                                                                                                                                             
CL150  Chicago              Los Angeles                1749                                                                                                                                             
LNY107 Los Angeles          New York                   2510                                                                                                                                             

9 rows selected.

SQL> 
SQL> REM:Before updation BASE table
SQL> 
SQL> select * from routes r
  2  where ((orig_airport='Los Angeles') or (dest_airport='Los Angeles'));

ROUTEI ORIG_AIRPORT         DEST_AIRPORT           DISTANCE                                                                                                                                             
------ -------------------- -------------------- ----------                                                                                                                                             
LW100  Los Angeles          Washington D.C.            2308                                                                                                                                             
LC101  Los Angeles          Chicago                    1804                                                                                                                                             
LD102  Los Angeles          Dallas                     1251                                                                                                                                             
LB103  Los Angeles          Boston                     2606                                                                                                                                             
LS104  Los Angeles          Sydney                     7487                                                                                                                                             
LT105  Los Angeles          Tokyo                      5478                                                                                                                                             
LH106  Los Angeles          Honolulu                   2551                                                                                                                                             
CL150  Chicago              Los Angeles                1749                                                                                                                                             
LNY107 Los Angeles          New York                   2510                                                                                                                                             

9 rows selected.

SQL> 
SQL> REM:manipulating the Losangeles_Route view
SQL> savepoint up3;

Savepoint created.

SQL> 
SQL> REM:inserting can be done in this view....
SQL> insert into Losangeles_Route values('CL100','Chennai','Los Angeles',5451);

1 row created.

SQL> 
SQL> REM:update can be done in this view...
SQL> update Losangeles_Route set distance=1804 where routeid='LC101';

1 row updated.

SQL> 
SQL> REM:deletion can be done in this view....
SQL> delete from Losangeles_Route where orig_airport='Chennai';

1 row deleted.

SQL> 
SQL> 
SQL> -- Displaying the Losangeles_Route view after updation
SQL> select * from Losangeles_Route;

ROUTEI ORIG_AIRPORT         DEST_AIRPORT           DISTANCE                                                                                                                                             
------ -------------------- -------------------- ----------                                                                                                                                             
LW100  Los Angeles          Washington D.C.            2308                                                                                                                                             
LC101  Los Angeles          Chicago                    1804                                                                                                                                             
LD102  Los Angeles          Dallas                     1251                                                                                                                                             
LB103  Los Angeles          Boston                     2606                                                                                                                                             
LS104  Los Angeles          Sydney                     7487                                                                                                                                             
LT105  Los Angeles          Tokyo                      5478                                                                                                                                             
LH106  Los Angeles          Honolulu                   2551                                                                                                                                             
CL150  Chicago              Los Angeles                1749                                                                                                                                             
LNY107 Los Angeles          New York                   2510                                                                                                                                             

9 rows selected.

SQL> 
SQL> -- After updation BASE table
SQL> 
SQL> select * from routes r
  2  where ((orig_airport='Los Angeles') or (dest_airport='Los Angeles'));

ROUTEI ORIG_AIRPORT         DEST_AIRPORT           DISTANCE                                                                                                                                             
------ -------------------- -------------------- ----------                                                                                                                                             
LW100  Los Angeles          Washington D.C.            2308                                                                                                                                             
LC101  Los Angeles          Chicago                    1804                                                                                                                                             
LD102  Los Angeles          Dallas                     1251                                                                                                                                             
LB103  Los Angeles          Boston                     2606                                                                                                                                             
LS104  Los Angeles          Sydney                     7487                                                                                                                                             
LT105  Los Angeles          Tokyo                      5478                                                                                                                                             
LH106  Los Angeles          Honolulu                   2551                                                                                                                                             
CL150  Chicago              Los Angeles                1749                                                                                                                                             
LNY107 Los Angeles          New York                   2510                                                                                                                                             

9 rows selected.

SQL> 
SQL> 
SQL> REM:--------------------------------------------------------------------
> 
SQL> 
SQL> REM : 4
SQL> REM : Create a view named Losangeles_Flight on Schedule_15 (as defined in 1) that display flight,
SQL> REM : departure (date, time), arrival (date, time) of flight(s) from Los Angeles.
SQL> 
SQL> create view losangeles_flight
  2  as
  3  select flight,ddate,dtime,adate,atime from schedule_15
  4  where
  5   from_airport = 'Los Angeles';

View created.

SQL> 
SQL> select * from losangeles_flight;

FLIGHT  DDATE          DTIME ADATE          ATIME                                                                                                                                                       
------- --------- ---------- --------- ----------                                                                                                                                                       
JJ-2482 15-APR-05       1230 15-APR-05       1540                                                                                                                                                       
SQ-11   15-APR-05       1230 16-APR-05       2055                                                                                                                                                       
HA-1    15-APR-05       1110 15-APR-05       1445                                                                                                                                                       

SQL> savepoint point3;

Savepoint created.

SQL> 
SQL> 
SQL> REM : updating the values in views will also update the table...
SQL> 
SQL> 	     update losangeles_flight set atime = 1130 where flight = 'HA-1';

1 row updated.

SQL> --View table
SQL> 	     select * from losangeles_flight where flight = 'HA-1';

FLIGHT  DDATE          DTIME ADATE          ATIME                                                                                                                                                       
------- --------- ---------- --------- ----------                                                                                                                                                       
HA-1    15-APR-05       1110 15-APR-05       1130                                                                                                                                                       

SQL> --Base table
SQL> 	     select flight ,atime from schedule_15 where flight = 'HA-1';

FLIGHT       ATIME                                                                                                                                                                                      
------- ----------                                                                                                                                                                                      
HA-1          1130                                                                                                                                                                                      

SQL> 
SQL> 	     update losangeles_flight set adate = '16-APR-05' where flight = 'SQ-11';

1 row updated.

SQL> --View table
SQL> 	     select * from losangeles_flight where flight = 'SQ-11';

FLIGHT  DDATE          DTIME ADATE          ATIME                                                                                                                                                       
------- --------- ---------- --------- ----------                                                                                                                                                       
SQ-11   15-APR-05       1230 16-APR-05       2055                                                                                                                                                       

SQL> --Base table
SQL> 	     select flight ,adate from schedule_15 where flight = 'SQ-11';

FLIGHT  ADATE                                                                                                                                                                                           
------- ---------                                                                                                                                                                                       
SQ-11   16-APR-05                                                                                                                                                                                       

SQL> 
SQL> REM : deleting can be done in this view....
SQL> 	     delete from losangeles_flight where flight = 'SQ-11';

1 row deleted.

SQL> 
SQL> --View table
SQL> 	     select * from losangeles_flight where flight = 'SQ-11';

no rows selected

SQL> --Base table
SQL> 	     select * from fl_schedule
  2  where
  3  flno = 'SQ-11';

no rows selected

SQL> 
SQL> REM : Insertion can not be done in this view tables since a key is non preserved key...
SQL> insert into losangeles_flight values('SQ-11','15-APR-05','1130','16-APR-05','2055');
insert into losangeles_flight values('SQ-11','15-APR-05','1130','16-APR-05','2055')
*
ERROR at line 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table 


SQL> 
SQL> rollback to point3;

Rollback complete.

SQL> spool off;
