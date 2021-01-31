

SET SQL_SAFE_UPDATES = 0;


drop database shop;
CREATE DATABASE shop;
use shop;


CREATE TABLE product(
     product_id CHAR(4) NOT NULL, 
     product_name VARCHAR(100) NOT NULL, 
     product_type VARCHAR(32) NOT NULL, 
     sale_price INTEGER, 
     purchase_price INTEGER, 
     regist_date DATE, 
     PRIMARY KEY(product_id)
 )  ;


-- 优点：相比drop``/``delete，truncate用来清除数据时，速度最快。

DROP TABLE product;

CREATE TABLE productins
(product_id    CHAR(4)      NOT NULL,
product_name   VARCHAR(100) NOT NULL,
product_type   VARCHAR(32)  NOT NULL,
sale_price     INTEGER      DEFAULT 0,
purchase_price INTEGER ,
regist_date    DATE ,
PRIMARY KEY (product_id)); 


-- 多行INSERT （ DB2、SQL、SQL Server、 PostgreSQL 和 MySQL多行插入）
INSERT INTO productins VALUES
('0002', '打孔器', '办公用品', 500, 320, '2009-09-11'),
('0003', '运动T恤', '衣服', 4000, 2800, NULL),
('0004', '菜刀', '厨房用具', 3000, 2800, '2009-09-20');  

select * from productins;



create table addressbook (
regist_no integer not null,
name varchar(128) not null,
address varchar(256) not null,
tel_no char(10),
mail_address char(20),
primary key (regist_no) );

alter table addressbook
add column postal_code  char(8) not null;

select * from addressbook;

delete from addressbook;
truncate addressbook;
drop table addressbook;


create table addressbook (
regist_no integer not null,
name varchar(128) not null,
address varchar(256) not null,
tel_no char(10),
mail_address char(20),
primary key (regist_no) );

