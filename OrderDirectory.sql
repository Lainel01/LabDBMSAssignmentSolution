create database if not exists Order_Directory;
use order_directory;

create table if not exists Supplier(
SUPP_ID int primary key not null,
SUPP_NAME varchar(50) null default null,
SUPP_CITY varchar(50) null default null,
SUPP_PHONE varchar(10) null default null
);

create table if not exists Customer(
CUS_ID int not null,
CUS_NAME varchar(50) null default null,
CUS_PHONE varchar(10) null default null,
CUS_CITY varchar(50) null default null,
CUS_GENDER char null default null,
primary key(CUS_ID) 
);

create table if not exists Category(
CAT_ID int primary key not null,
CAT_NAME varchar(50) null default null
);

create table if not exists Product(
PRO_ID int primary key not null,
PRO_NAME varchar (50) null default null,
PRO_DESC varchar(50) null default null,
CAT_ID int not null, 
foreign key (CAT_ID) references category(CAT_ID)
);

create table if not exists product_details(
PROD_ID int not null,
PRO_ID int not null,
SUPP_ID int not null,
PROD_PRICE int not null,
primary key (PROD_ID),
foreign key (PRO_ID) references product(PRO_ID),
foreign key (SUPP_ID) references supplier(SUPP_ID)
);

create table if not exists Order_Details(
ORD_ID int primary key not null,
ORD_AMOUNT int not null,
ORD_DATE date not null,
CUS_ID int not null,
PROD_ID int not null,
foreign key (CUS_ID) references customer(CUS_ID),
foreign key (PROD_ID) references product_details(PROD_ID)
);

create table if not exists Rating(
RAT_ID int primary key not null,
CUS_ID int not null,
SUPP_ID int not null,
RAT_RATSTARS int not null,
foreign key (CUS_ID) references customer(CUS_ID),
foreign key (SUPP_ID) references supplier(SUPP_ID)
);


insert into supplier values(1, "Rajesh Retails", "Delhi", '1234567890');
insert into supplier values(2, "Appario Ltd.", "Mumbai", '2589632470');
insert into supplier values(3, "Knome Products", "Bangalore", '9774763888');
insert into supplier values(4, "Bansal Retails", "Kochi", '8975736644');
insert into supplier values(5, "Mittal Ltd.", "Lucknow", '7894896453');

insert into customer values(1, "AAKASH", '9999999999', "DELHI", 'M');
insert into customer values(2, "AMAN", '9887363633', "NOIDA", 'M');
insert into customer values(3, "NEHA", '9999999999', "MUMBAI", 'F');
insert into customer values(4, "MEGHA", '9994562367', "KOLKATA", 'F');
insert into customer values(5, "PULKIT", '7895999999', "LUCKNOW", 'M');

insert into category values(1, "BOOKS");
insert into category values(2, "GAMES");
insert into category values(3, "GROCERIES");
insert into category values(4, "ELECTRONICS");
insert into category values(5, "CLOTHES");

insert into product values(1, "GTA V", "DFJDJFDJFDJFJF", 2);
insert into product values(2, "T-SHIRT", "DFDFJDFJDKFD", 5);
insert into product values(3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
insert into product values(4, "OATS", "REURENTBTOTH", 3);
insert into product values(5, "HARRY POTTER", "NBEMCTHTJTH", 1);

insert into product_details values(1,1,2,1500);
insert into product_details values(2,3,5,30000);
insert into product_details values(3,5,1,3000);
insert into product_details values(4,2,3,2500);
insert into product_details values(5,4,1,1000);

insert into order_details values(1,1500,"2021-10-12",3,5);
insert into order_details values(2,30500,"2021-09-16",5,2);
insert into order_details values(3,2000,"2021-10-05",1,1);
insert into order_details values(4,3500,"2021-08-16",4,3);
insert into order_details values(5,2000,"2021-10-06",2,1);

insert into rating values(1,2,2,4);
insert into rating values(2,3,4,3);
insert into rating values(3,5,1,5);
insert into rating values(4,1,3,2);
insert into rating values(5,4,5,4);

select count(customer.CUS_GENDER), customer.CUS_GENDER from customer
join order_details on customer.CUS_ID = order_details.CUS_ID 
where order_details.ORD_AMOUNT >=3000 group by customer.CUS_GENDER;

select order_details.*, product.PRO_NAME
from order_details, product_details, product
where order_details.CUS_ID=2
and order_details.PROD_ID = product_details.PRO_ID
and product_details.PRO_ID = product.PRO_ID;

select supplier.*
from supplier, product_details
where supplier.SUPP_ID in
(
select product_details.SUPP_ID
from product_details
group by product_details.SUPP_ID
having count(product_details.SUPP_ID)>1
)
group by supplier.SUPP_ID;

select category.*
from order_details
inner join product_details
on order_details.PROD_ID = product_details.PROD_ID
inner join product on product.PRO_ID = product_details.PRO_ID
inner join category on category.CAT_ID = product.CAT_ID
having min(order_details.ORD_AMOUNT);

select product.PRO_ID, product.PRO_NAME from product
join product_details on product.PRO_ID = product_details.PRO_ID
join order_details on product_details.PROD_ID = order_details.PROD_ID
where order_details.ORD_DATE > '2021-10-05';

select CUS_NAME, CUS_ID from customer where CUS_NAME like 'A%' or CUS_NAME like '%A';

DELIMITER &&
create procedure prc()
BEGIN
select supplier.SUPP_ID, supplier.SUPP_NAME, rating.RAT_RATSTARS,
case
when rating.ratstars > 4 then 'GENIUNE Supplier'
when rating.ratstars > 2 then 'AVERAGE Supplier'
else 'supplier should not be considered'
END as verdict from rating inner join supplier on supplier.SUPP_ID = rating.SUPP_ID;
END
&& DELIMITER ; 