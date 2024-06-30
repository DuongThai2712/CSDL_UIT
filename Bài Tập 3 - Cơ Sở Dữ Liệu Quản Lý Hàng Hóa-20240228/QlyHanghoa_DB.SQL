Create database PartShipmentDB
go
use PartShipmentDB
go
Create table Nhacungcap 
(
maNCC		varchar(5),
tenNCC	varchar(20), 
trangthai 	numeric(2),
thanhpho	varchar(30),
Constraint PKNcc primary key (maNCC)
)


create table Phutung 
(
 maPT		varchar(5),
 tenPT	varchar(10),
 mausac	varchar(10),
 khoiluong	float,
 thanhpho	 varchar(30),
 Constraint PKPt Primary Key (maPT) 
)


Create table Vanchuyen 
(
maNCC		varchar(5) ,
maPT		varchar(5),
soluong	numeric(5), 
Constraint PKVc primary key (maNCC,maPT),
Constraint FKShip1 foreign key (maNCC) references Nhacungcap (maNCC),
Constraint FKShip2 foreign key (maPT) references Phutung (maPT)
)


insert into Nhacungcap values ('S1','Smith','20','London')
insert into Nhacungcap values ('S2','Jones','10','Paris')
insert into Nhacungcap values ('S3','Blake','30','Paris')
insert into Nhacungcap values ('S4','Clark','20','London')
insert into Nhacungcap values ('S5','Adams','30','Athens')


Insert  into Phutung values  ( 'P1' , 'Nut' , 'Red' , 12.0 , 'London')
Insert  into Phutung values  ( 'P2' , 'Bolt' , 'Green', 17.0 , 'Paris')
Insert  into Phutung values  ( 'P3' , 'Screw' , 'Blue', 17.0 , 'Oslo')
Insert  into Phutung values  ( 'P4' , 'Screw' , 'Red' , 14.0 , 'London')
Insert  into Phutung values  ( 'P5' , 'Cam' , 'Blue' , 12.0 , 'Paris')
Insert  into Phutung values  ( 'P6' , 'Cog' , 'Red' , 19.0 , 'London')



Insert into Vanchuyen values ('S1','P1',300)
Insert into Vanchuyen values ('S1','P2',200)
Insert into Vanchuyen values ('S1','P3',400)
Insert into Vanchuyen values ('S1','P4',200)
Insert into Vanchuyen values ('S1','P5',100)
Insert into Vanchuyen values ('S1','P6',100)
Insert into Vanchuyen values ('S2','P1',300)
Insert into Vanchuyen values ('S2','P2',400)
Insert into Vanchuyen values ('S3','P2',200)
Insert into Vanchuyen values ('S4','P2',200)
Insert into Vanchuyen values ('S4','P4',300)
Insert into Vanchuyen values ('S4','P5',400)

select * from Vanchuyen
select * from Nhacungcap 
select * from Vanchuyen 

