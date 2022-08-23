
Create Database if not exists E_commerce ;
use E_commerce;

CREATE TABLE IF NOT EXISTS supplier(
SUPP_ID int primary key,
SUPP_NAME varchar(50) NOT NULL,
SUPP_CITY varchar(50),
SUPP_PHONE varchar(10) NOT NULL);

CREATE TABLE IF NOT EXISTS customer(
CUS_ID INT NOT NULL,
CUS_NAME VARCHAR(20) NOT NULL,
CUS_PHONE VARCHAR(10) NOT NULL,
CUS_CITY varchar(30) NOT NULL,
CUS_GENDER CHAR,
PRIMARY KEY (CUS_ID));

CREATE TABLE IF NOT EXISTS category (
CAT_ID INT NOT NULL,
CAT_NAME VARCHAR(20) NOT NULL,
PRIMARY KEY (CAT_ID)
);
CREATE TABLE IF NOT EXISTS product (
PRO_ID INT NOT NULL,
PRO_NAME VARCHAR(20) NOT NULL DEFAULT "Dummy",
PRO_DESC VARCHAR(60),
CAT_ID INT NOT NULL,
PRIMARY KEY (PRO_ID),
FOREIGN KEY (CAT_ID) REFERENCES CATEGORY (CAT_ID)
);
CREATE TABLE IF NOT EXISTS supplier_pricing (
PRICING_ID INT NOT NULL,
PRO_ID INT NOT NULL,
SUPP_ID INT NOT NULL,
SUPP_PRICE INT DEFAULT 0,
PRIMARY KEY (PRICING_ID),
FOREIGN KEY (PRO_ID) REFERENCES PRODUCT (PRO_ID),
FOREIGN KEY (SUPP_ID) REFERENCES SUPPLIER(SUPP_ID)
);
CREATE TABLE IF NOT EXISTS `order` (
ORD_ID INT NOT NULL,
ORD_AMOUNT INT NOT NULL,
ORD_DATE DATE,
CUS_ID INT NOT NULL,
PRICING_ID INT NOT NULL,
PRIMARY KEY (ORD_ID),
FOREIGN KEY (CUS_ID) REFERENCES CUSTOMER(CUS_ID),
FOREIGN KEY (PRICING_ID) REFERENCES SUPPLIER_PRICING(PRICING_ID)
);
CREATE TABLE IF NOT EXISTS rating (
RAT_ID INT NOT NULL,
ORD_ID INT NOT NULL,
RAT_RATSTARS INT NOT NULL,
PRIMARY KEY (RAT_ID),
FOREIGN KEY (ORD_ID) REFERENCES `order`(ORD_ID)
);
INSERT INTO SUPPLIER VALUES(1,"Rajesh Retails","Delhi",'1234567890');
INSERT INTO SUPPLIER VALUES(2,"Appario Ltd.","Mumbai",'2589631470');
INSERT INTO SUPPLIER VALUES(3,"Knome products","Banglore",'9785462315');
INSERT INTO SUPPLIER VALUES(4,"Bansal Retails","Kochi",'8975463285');
INSERT INTO SUPPLIER VALUES(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO CUSTOMER VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO CUSTOMER VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO CUSTOMER VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO CUSTOMER VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO CUSTOMER VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');


INSERT INTO PRODUCT VALUES(1,"GTA V","Windows 7 and above with i5 processor and 8GB RAM",2);
INSERT INTO PRODUCT VALUES(2,"TSHIRT","SIZE-L with Black, Blue and White variations",5);
INSERT INTO PRODUCT VALUES(3,"ROG LAPTOP","Windows 10 with 15inch screen, i7 processor, 1TB SSD",4);
INSERT INTO PRODUCT VALUES(4,"OATS","Highly Nutritious from Nestle",3);
INSERT INTO PRODUCT VALUES(5,"HARRY POTTER","Best Collection of all time by J.K Rowling",1);
INSERT INTO PRODUCT VALUES(6,"MILK","1L Toned MIlk",3);
INSERT INTO PRODUCT VALUES(7,"Boat EarPhones","1.5Meter long Dolby Atmos",4);
INSERT INTO PRODUCT VALUES(8,"Jeans","Stretchable Denim Jeans with various sizes and color",5);
INSERT INTO PRODUCT VALUES(9,"Project IGI","compatible with windows 7 and above",2);
INSERT INTO PRODUCT VALUES(10,"Hoodie","Black GUCCI for 13 yrs and above",5);
INSERT INTO PRODUCT VALUES(11,"Rich Dad Poor Dad","Written by RObert Kiyosaki",1);
INSERT INTO PRODUCT VALUES(12,"Train Your Brain","By Shireen Stephen",1);

INSERT INTO SUPPLIER_PRICING VALUES(1,1,2,1500);
INSERT INTO SUPPLIER_PRICING VALUES(2,3,5,30000);
INSERT INTO SUPPLIER_PRICING VALUES(3,5,1,3000);
INSERT INTO SUPPLIER_PRICING VALUES(4,2,3,2500);
INSERT INTO SUPPLIER_PRICING VALUES(5,4,1,1000);
INSERT INTO SUPPLIER_PRICING VALUES(6,12,2,780);



INSERT INTO RATING VALUES(1,101,4);
INSERT INTO RATING VALUES(2,102,3);
INSERT INTO RATING VALUES(3,103,1);
INSERT INTO RATING VALUES(4,104,2);
INSERT INTO RATING VALUES(5,105,4);
INSERT INTO RATING VALUES(6,106,3);
INSERT INTO RATING VALUES(7,107,4);
INSERT INTO RATING VALUES(8,108,4);
INSERT INTO RATING VALUES(9,109,3);
INSERT INTO RATING VALUES(10,110,5);
INSERT INTO RATING VALUES(11,111,3);
INSERT INTO RATING VALUES(12,112,4);
INSERT INTO RATING VALUES(13,113,2);
INSERT INTO RATING VALUES(14,114,1);
INSERT INTO RATING VALUES(15,115,1);
INSERT INTO RATING VALUES(16,116,0);

-- 3)	Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

SELECT count(customer.CUS_ID) as customer_count, customer.CUS_GENDER FROM customer as customer 
inner join (SELECT CUS_ID, sum(ORD_AMOUNT) as OD_AMOUNT  FROM orders group by CUS_ID having sum(ORD_AMOUNT)>3000)
 as od on od.CUS_ID = customer.CUS_ID group by customer.CUS_GENDER;


-- 4)	Display all the orders along with product name ordered by a customer having Customer_Id=2

select pro.pro_name,ord.* from orders ord
inner join  supplier_pricing sp on ord.pricing_id = sp.pricing_id
inner join product pro on sp.pro_id  = pro.pro_id
where ord.cus_id=2;

-- 5)	Display the Supplier details who can supply more than one product.

SELECT sp.SUPP_ID, sp.SUPP_NAME, sp.SUPP_CITY, sp.SUPP_PHONE, sd.ProductSelling FROM supplier as sp 
inner join (SELECT SUPP_ID, count(PRO_ID) as ProductSelling FROM supplier_pricing group by SUPP_ID having count(PRO_ID)>1)
 as sd on sd.SUPP_ID = sp.SUPP_ID;

-- 6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product

SELECT cat.CAT_ID, cat.CAT_NAME, min(pc.SUPP_PRICE) as minPrice, pc.PRO_NAME FROM category as cat 
inner join (SELECT p.PRO_ID,p.PRO_NAME,p.CAT_ID , sp.SUPP_PRICE FROM product as p
inner join (SELECT PRO_ID, SUPP_PRICE FROM supplier_pricing) as sp on sp.PRO_ID = p.PRO_ID) as pc on pc.CAT_ID = cat.CAT_ID group by cat.CAT_ID order by cat.CAT_ID;

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.

SELECT pd.PRO_ID, pd.PRO_NAME, od.PRICING_ID, od.ORD_DATE FROM orders as od 
inner join (SELECT p.PRO_ID,p.PRO_NAME,psp.PRICING_ID FROM product as p 
inner join (SELECT PRO_ID, PRICING_ID FROM supplier_pricing) as psp on psp.PRO_ID = p.PRO_ID) as pd on pd.PRICING_ID = od.PRICING_ID where od.ORD_DATE > '2021-10-05';
;

-- 8)	Display customer name and gender whose names start or end with character 'A'.
SELECT * FROM customer where CUS_NAME like '%A%';
SELECT * FROM customer where CUS_NAME like '%A' OR CUS_NAME like 'A%';


-- 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service.
 -- For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” 
-- else print “Poor Service”.

call `service_types`;





