-- -----------------------------------------------------
-- create and use database: fashionCo
-- -----------------------------------------------------
CREATE SCHEMA `fashionCo`;
USE `fashionCo` ;


-- -----------------------------------------------------
-- info
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fashionCo`.`Self` (
  `std_id` VARCHAR(125) NOT NULL,
  `std_name` VARCHAR(125) NOT NULL,
  `std_department` VARCHAR(125) NOT NULL,
  `std_year` ENUM('1y_b','2y_b','3y_b','4y_b','1y_m', '2y_m', '3y_m','4y_m', '1y_d', '2y_d','3y_d','4y_d','5y_d','6y_d', '7y_d','defer','dropout') NOT NULL,
  PRIMARY KEY (`std_id`))
;

INSERT INTO `Self` VALUES ('R10725059', '謝佳穎', '資訊管理研究所', '2y_m');
SELECT DATABASE();
SELECT * FROM self;


-- -----------------------------------------------------
-- create table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fashionCo`.`Member` (
  `member_id` VARCHAR(100) NOT NULL,
  `age` INT NULL CHECK (`age` > 0),
  `name` VARCHAR(256) NOT NULL,
  `address_house` VARCHAR(45) NULL,
  `address_number` VARCHAR(45) NULL,
  `address_street` VARCHAR(45) NULL,
  `address_city` VARCHAR(45) NULL,
  `address_zipno` INT NULL,
  `phone_number` VARCHAR(45) NULL,
  `picture` VARCHAR(256) NULL,
  `email` VARCHAR(256) NOT NULL,
  `password` VARCHAR(512) NOT NULL,
  `gender` ENUM('male', 'female') NULL,
  `loggin_time` BIGINT NOT NULL,
  `loggout_time` BIGINT NOT NULL,
  `loggin_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`member_id`))
;


CREATE TABLE IF NOT EXISTS `fashionCo`.`Product` (
  `product_id` VARCHAR(100) NOT NULL,
  `product_name` VARCHAR(125) NOT NULL,
  `product_category` VARCHAR(45) NOT NULL,
  `product_price` INT NOT NULL CHECK (`product_price` > 0),
  `description` VARCHAR(512) NULL,
  `place` VARCHAR(125) NULL,
  `inventory_quantity` INT NOT NULL DEFAULT 0,
  `sold_quantity` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`product_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Product_Images` (
  `pi_id` VARCHAR(100) NOT NULL,
  `pi_content` VARCHAR(256) NOT NULL,
  `product_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`pi_id`, `product_id`),
  CONSTRAINT `fk_Product_Images_Product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `fashionCo`.`Product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Collection` (
  `collection_id` VARCHAR(100) NOT NULL,
  `member_id` VARCHAR(100) NOT NULL,
  `product_id`VARCHAR(100) NOT NULL,
  PRIMARY KEY (`collection_id`, `member_id`),
  CONSTRAINT `fk_Collection_Member`
    FOREIGN KEY (`member_id`)
    REFERENCES `fashionCo`.`Member` (`member_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Collection_Product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `fashionCo`.`Product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Order` (
  `order_id` VARCHAR(100) NOT NULL,
  `order_time` BIGINT NULL,
  `total_amount` INT NOT NULL DEFAULT 0 CHECK (`total_amount` > 0),
  `member_id` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`order_id`, `member_id`),
  CONSTRAINT `fk_Order_Member1`
    FOREIGN KEY (`member_id`)
    REFERENCES `fashionCo`.`Member` (`member_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Order_has_Product` (
  `order_id` VARCHAR(100) NOT NULL,
  `member_id` VARCHAR(100) NOT NULL,
  `product_id` VARCHAR(100) NOT NULL,
  `order_quantity` INT NOT NULL CHECK (`order_quantity` > 0),
  PRIMARY KEY (`order_id`, `member_id`, `product_id`),
  CONSTRAINT `fk_Order_has_Product_Order1`
    FOREIGN KEY (`order_id` , `member_id`)
    REFERENCES `fashionCo`.`Order` (`order_id` , `member_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Order_has_Product_Product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `fashionCo`.`Product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Payment` (
  `payment_id` VARCHAR(100) NOT NULL,
  `payment_time` BIGINT NULL,
  `payment_status` VARCHAR(45) NOT NULL,
  `currency` VARCHAR(45) NULL DEFAULT 'NTD',
  `card_number` VARCHAR(256) NOT NULL,
  `bank_transaction_info` VARCHAR(512) NOT NULL,
  `order_id` VARCHAR(256) NOT NULL,
  `member_id` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`payment_id`, `order_id`, `member_id`),
  CONSTRAINT `fk_Payment_Order1`
    FOREIGN KEY (`order_id` , `member_id`)
    REFERENCES `fashionCo`.`Order` (`order_id` , `member_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Retired_Employee` (
  `retired_id` VARCHAR(100) NOT NULL,
  `retired_date` BIGINT NULL,
  PRIMARY KEY (`retired_id`))
;


CREATE TABLE IF NOT EXISTS `fashionCo`.`Tenured_Employee` (
  `employee_id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(125) NOT NULL,
  `tenured_pay` INT NOT NULL DEFAULT 2000000 CHECK (`tenured_pay` > 0),
  `gender` ENUM('male', 'female') NULL,
  `email` VARCHAR(125) NULL,
  `honor_degree` INT NOT NULL,
  `manager_id` VARCHAR(256) NULL,
  `is_sales_teamer` INT NOT NULL CHECK (`is_sales_teamer` = 1 or `is_sales_teamer` = 0),
  `sales_type` VARCHAR(125) NULL,
  `is_engineer_teamer` INT NOT NULL CHECK (`is_engineer_teamer` = 1 or `is_engineer_teamer` = 0),
  `engineer_type` VARCHAR(125) NULL,
  `retired_id` VARCHAR(100) NULL,
  `address_city` VARCHAR(100) NULL,
  CONSTRAINT `fk_Tenured_Employee_Employee1`
    FOREIGN KEY (`manager_id`)
    REFERENCES `fashionCo`.`Tenured_Employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Retired_Employee1`
	FOREIGN KEY (`retired_id`)
	REFERENCES `fashionCo`.`Retired_Employee` (`retired_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  PRIMARY KEY (`employee_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Rookie_Employee` (
  `employee_id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(125) NOT NULL,
  `rookie_pay` INT NOT NULL DEFAULT 400000 CHECK (`rookie_pay` > 0),
  `gender`ENUM('male', 'female') NULL,
  `email` VARCHAR(125) NULL,
  `honor_degree` INT NOT NULL,
  `manager_id` VARCHAR(256) NULL,
  `is_sales_teamer` INT NOT NULL CHECK (`is_sales_teamer` = 1 or `is_sales_teamer` = 0),
  `sales_type` VARCHAR(125) NULL,
  `is_engineer_teamer` INT NOT NULL CHECK (`is_engineer_teamer` = 1 or `is_engineer_teamer` = 0),
  `engineer_type` VARCHAR(125) NULL,
  `retired_id` VARCHAR(100) NULL,
  `address_city` VARCHAR(100) NULL,
  CONSTRAINT `fk_Rookie_Employee_Employee1`
	FOREIGN KEY (`manager_id`)
	REFERENCES `fashionCo`.`Tenured_Employee` (`employee_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `fk_Retired_Employee2`
	FOREIGN KEY (`retired_id`)
	REFERENCES `fashionCo`.`Retired_Employee` (`retired_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  PRIMARY KEY (`employee_id`))
;





-- -----------------------------------------------------
-- insert
-- -----------------------------------------------------
INSERT INTO `Member` (`member_id`, `age`, `name`, `address_house`, `address_number`, `address_street`, `address_city`, `address_zipno`, `phone_number`, `picture`, `email`, `password`, `gender`, `loggin_time`, `loggout_time`, `loggin_type`) VALUES ('a4d10183-1ee6-4e92-ad47-52f6723fae4f', 27, 'Elaine', '三樓', '4號', '羅斯福路', '台北市', '100', '0912345678', 'https://imgur/pic.jpg', 'elaine@gmail.com', '$2y$10$Hh.GcPN5xWLl1UScaJFveObEj2pbCjynj.SWT5WpQpJ1W7PV7AT8e', 'female', 1680585424311, 1680585425311, 'nature');
INSERT INTO `Member` (`member_id`, `age`, `name`, `address_number`, `address_street`, `address_city`, `address_zipno`, `phone_number`, `picture`, `email`, `password`, `gender`, `loggin_time`, `loggout_time`, `loggin_type`) VALUES ('f540c893-66c0-442e-b1c8-8774825bca0b', 67, 'Sammy', '120號', '市民大道', '台北市', '100', '0987654321', 'https://imgur/pic2.jpg', 'sammy@gmail.com', '$2y$10$t144sVOqyoP6qvslKsVnYOgiYaQje0d6qQC1QX0AfQqtg2cxemKPq', 'female', 1680585558720, 1680585658720, 'facebook');
INSERT INTO `Member` (`member_id`, `age`, `name`, `address_house`, `address_street`, `address_city`, `address_zipno`, `phone_number`, `picture`, `email`, `password`, `gender`, `loggin_time`, `loggout_time`, `loggin_type`) VALUES ('0b4bd96f-5ffe-441c-9dff-a4badf4ef4cd', 17, 'James', '十樓', '四維路', '新北市', '220', '0911111111', 'https://imgur/pic3.jpg', 'james@gmail.com', '$2y$04$I1xWetN./bRu07z9lEN/xOP5WOWnrZpNNWKImh6t4TrZF/cNaM0y2', 'male', 1680585676806, 1680585686806, 'google');
INSERT INTO `Product`  VALUES ('58069fb7-68a2-40f0-ba84-295a7bdfecee', 'Jeans', 'Women', 1500, 'New Jeans', 'Taiwan', 200, 5);
INSERT INTO `Product`  VALUES ('44ecfa69-946d-4536-86d4-1beeffbb09b7', 'Cardigan', 'Men', 2500, 'Warm cardigan', 'Korea', 200, 1);
INSERT INTO `Product`  VALUES ('25036b89-3d13-49d0-a6fb-5b4520986e31', 'TShirt', 'Children', 1000, 'Cute Disney TShirt', 'Japan', 200, 10);
INSERT INTO `Product`  VALUES ('77cdaee5-2619-4f95-bb24-2f14fd650717', 'Jacket', 'Women', 5000, 'Cool jacket', 'USA', 200, 0);
INSERT INTO `Product_Images` VALUES ('bc0cebeb-fcf4-42f4-ab85-12c7777309e6', 'https://imgur/1.jpg', '25036b89-3d13-49d0-a6fb-5b4520986e31');
INSERT INTO `Product_Images` VALUES ('afb0db5e-fe00-46c4-ba07-afdcae073aa3', 'https://imgur/2.jpg', '25036b89-3d13-49d0-a6fb-5b4520986e31');
INSERT INTO `Product_Images` VALUES ('3ecfbb2c-1f46-4afa-904e-32f810c772d7', 'https://imgur/3.jpg', '44ecfa69-946d-4536-86d4-1beeffbb09b7');
INSERT INTO `Product_Images` VALUES ('3448f766-7d11-40dd-9e23-216c4ec672ed', 'https://imgur/4.jpg', '44ecfa69-946d-4536-86d4-1beeffbb09b7');
INSERT INTO `Product_Images` VALUES ('2112f1ce-1f4e-41d7-881e-250a844120d2', 'https://imgur/5.jpg', '58069fb7-68a2-40f0-ba84-295a7bdfecee');
INSERT INTO `Product_Images` VALUES ('ec336407-7ac0-4592-a5f8-302bfb1df1c9', 'https://imgur/6.jpg', '58069fb7-68a2-40f0-ba84-295a7bdfecee');
INSERT INTO `Collection`  VALUES ('30c62c7d-2eca-4376-b7a1-b2be4f365efc', '0b4bd96f-5ffe-441c-9dff-a4badf4ef4cd', '77cdaee5-2619-4f95-bb24-2f14fd650717');
INSERT INTO `Collection`  VALUES ('32144c8c-81aa-4f2d-9105-ddd40b126f39', 'a4d10183-1ee6-4e92-ad47-52f6723fae4f', '77cdaee5-2619-4f95-bb24-2f14fd650717');
INSERT INTO `Collection`  VALUES ('72f0637c-a8a0-4321-bcc6-1148a0f0bc26', 'f540c893-66c0-442e-b1c8-8774825bca0b', '77cdaee5-2619-4f95-bb24-2f14fd650717');
INSERT INTO `Order`  VALUES ('c123fa4b-2d44-4498-9cd7-ee21297b37ff', 1680589065980, 1500, 'a4d10183-1ee6-4e92-ad47-52f6723fae4f');
INSERT INTO `Order`  VALUES ('7e9c80a2-7e55-4b9e-8c9d-59f7b3d7640a', 1680589134096, 3500, '0b4bd96f-5ffe-441c-9dff-a4badf4ef4cd');
INSERT INTO `Order`  VALUES ('536ea2eb-c4d8-4196-ab15-d7241eea14b9', 1680589204391, 3000, 'f540c893-66c0-442e-b1c8-8774825bca0b');
INSERT INTO `Order_has_Product` VALUES ('536ea2eb-c4d8-4196-ab15-d7241eea14b9', 'f540c893-66c0-442e-b1c8-8774825bca0b', '58069fb7-68a2-40f0-ba84-295a7bdfecee', 2);
INSERT INTO `Order_has_Product` VALUES ('7e9c80a2-7e55-4b9e-8c9d-59f7b3d7640a', '0b4bd96f-5ffe-441c-9dff-a4badf4ef4cd', '25036b89-3d13-49d0-a6fb-5b4520986e31', 1);
INSERT INTO `Order_has_Product` VALUES ('7e9c80a2-7e55-4b9e-8c9d-59f7b3d7640a', '0b4bd96f-5ffe-441c-9dff-a4badf4ef4cd', '44ecfa69-946d-4536-86d4-1beeffbb09b7', 1);
INSERT INTO `Order_has_Product` VALUES ('c123fa4b-2d44-4498-9cd7-ee21297b37ff', 'a4d10183-1ee6-4e92-ad47-52f6723fae4f', '58069fb7-68a2-40f0-ba84-295a7bdfecee', 1);
INSERT INTO `Payment` VALUES ('1a9b470c-3d49-401c-9a4e-7ed035dcf576', 1680589909303, 'complete', DEFAULT,'5105105105105100', '{\"country_code\": \"Taiwan\", \"card_identifier\": \"dee921560b074be7a860a6b44a80c21b\", \"transaction_method\": \"FRICTIONLESS\"}', '536ea2eb-c4d8-4196-ab15-d7241eea14b9', 'f540c893-66c0-442e-b1c8-8774825bca0b');
INSERT INTO `Payment` VALUES ('6423eb79-46c6-4d59-b205-7ad51e6380d8', 1680590245590, 'complete', DEFAULT,'4111111111111111', '{\"country_code\": \"Taiwan\", \"card_identifier\": \"dee921560b074be7a860a6b44a80c21b\", \"transaction_method\": \"FRICTIONLESS\"}', '7e9c80a2-7e55-4b9e-8c9d-59f7b3d7640a', '0b4bd96f-5ffe-441c-9dff-a4badf4ef4cd');
INSERT INTO `Payment` VALUES ('8331fd91-1f63-4a2c-9b8f-e757831a6634', 1680590307346, 'complete', DEFAULT,'4012888888881881', '{\"country_code\": \"Taiwan\", \"card_identifier\": \"dee921560b074be7a860a6b44a80c21b\", \"transaction_method\": \"FRICTIONLESS\"}', 'c123fa4b-2d44-4498-9cd7-ee21297b37ff', 'a4d10183-1ee6-4e92-ad47-52f6723fae4f');
INSERT INTO `fashionCo`.`Retired_Employee` (`retired_id`, `retired_date`) VALUES ('2a91613a-fde3-4652-aeff-59b4e797b9c5', '1682395150');
INSERT INTO `fashionCo`.`Tenured_Employee` (`employee_id`, `name`, `tenured_pay`, `gender`, `email`, `honor_degree`, `is_sales_teamer`, `sales_type`, `is_engineer_teamer`, `engineer_type`, `address_city`) VALUES ('6c2479af-9f8b-49ef-a9a5-9df6f57a781e', 'John', '1000000', 'male', 'joohn@gmail.com', '3', '1', 'front sales', '1', 'tech lead', '台北市');
INSERT INTO `fashionCo`.`Tenured_Employee` (`employee_id`, `name`, `tenured_pay`, `gender`, `email`, `honor_degree`, `is_sales_teamer`, `sales_type`, `is_engineer_teamer`, `address_city`) VALUES ('077006c2-bb71-4221-ba1f-f9d613c85c96', 'Yvonne', '900000', 'female', 'yy@gmail.com', '3', '1', 'middle sales', '0', '台北市');
INSERT INTO `fashionCo`.`Tenured_Employee` (`employee_id`, `name`, `tenured_pay`, `gender`, `email`, `honor_degree`, `is_sales_teamer`, `is_engineer_teamer`, `engineer_type`, `address_city`) VALUES ('8f114ae5-60cf-4f57-9caa-dab93d9ba57b', 'Ken', '1300000', 'male', 'ken@gmail.com', '3', '0', '1', 'frontend engineer', '新北市');
INSERT INTO `fashionCo`.`Tenured_Employee` (`employee_id`, `name`, `tenured_pay`, `gender`, `email`, `honor_degree`, `manager_id`, `is_sales_teamer`, `sales_type`, `is_engineer_teamer`, `retired_id`, `address_city`) VALUES ('a08bc25d-74eb-481a-a3da-ce7644d3abb8', 'Wang', '2500000', 'male', 'w@gmail.com', '3', '077006c2-bb71-4221-ba1f-f9d613c85c96', '1', 'back sales', '0', '2a91613a-fde3-4652-aeff-59b4e797b9c5', '台北市');
INSERT INTO `fashionCo`.`Rookie_Employee` (`employee_id`, `name`, `rookie_pay`, `gender`, `email`, `honor_degree`, `manager_id`, `is_sales_teamer`, `is_engineer_teamer`, `engineer_type`, `address_city`) VALUES ('b2b2dc84-d4cc-4c84-8fa8-4bd0520dd6e1', 'Elaine', '700000', 'female', 'ee@gmail.com', '1', '6c2479af-9f8b-49ef-a9a5-9df6f57a781e', '0', '1', 'backend engineer', '新竹市');
INSERT INTO `fashionCo`.`Rookie_Employee` (`employee_id`, `name`, `rookie_pay`, `gender`, `email`, `honor_degree`, `manager_id`, `is_sales_teamer`, `is_engineer_teamer`, `engineer_type`, `address_city`) VALUES ('c06b06f6-7523-404f-bd62-36cfe2ccd525', 'Sammy', '700000', 'male', 'sam@gmail.com', '1', '8f114ae5-60cf-4f57-9caa-dab93d9ba57b', '0', '1', 'frontend engineer', '台北市');
INSERT INTO `fashionCo`.`Rookie_Employee` (`employee_id`, `name`, `rookie_pay`, `gender`, `email`, `honor_degree`, `manager_id`, `is_sales_teamer`, `sales_type`, `is_engineer_teamer`, `engineer_type`, `address_city`) VALUES ('7f69c853-edb5-49c9-93f3-02a1544ef961', 'Brandon', '700000', 'male', 'bb@gmail.com', '1', '6c2479af-9f8b-49ef-a9a5-9df6f57a781e', '1', 'front sales', '1', 'backend engineer', '台北市');




-- -----------------------------------------------------
-- homework 3 commands
-- -----------------------------------------------------

/* basic select */
select *
from `Order` as o, `Product` as p, `Order_has_Product` as op
where o.order_id = op.order_id and op.product_id = p.product_id
and p.sold_quantity >=10 or p.sold_quantity <5 
and p.place not in ("Korea", "South Korea");

/* basic projection */
select m.name, m.age
from `Member` as m;

/* basic rename */
select p.description as "product description"
from `Product` as p;

/* union */
select t.employee_id, t.name, t.is_sales_teamer, t.is_engineer_teamer, t.tenured_pay as pay, 'tenured' as title
from `Tenured_Employee` as t
union
select r.employee_id, r.name, r.is_sales_teamer, r.is_engineer_teamer, r.rookie_pay as pay, 'rookie' as title
from `Rookie_Employee` as r;

/* equijoin */
select * 
from `Member` as m
join `Order` as o
on m.member_id = o.member_id;

/* natural join */
select * 
from `Member` as m
natural join `Order` as o;

/* theta join */
select * 
from `Member` as m
join `Order` as o
on o.total_amount > 1500;

/* three table join */
select *
from `Order` as o, `Product` as p, `Order_has_Product` as op
where o.order_id = op.order_id and op.product_id = p.product_id;

/* aggregate */
select g.title, count(*) as "total employee", max(g.pay) as "max pay", min(g.pay) as "min pay"
from (
select t.employee_id, t.name, t.is_sales_teamer, t.is_engineer_teamer, t.tenured_pay as pay, 'tenured' as title
from `Tenured_Employee` as t
union
select r.employee_id, r.name, r.is_sales_teamer, r.is_engineer_teamer, r.rookie_pay as pay, 'rookie' as title
from `Rookie_Employee` as r) as g
group by g.title
;

/* aggregate 2 */
select p.product_name, sum(p.product_price * op.order_quantity) as total_product_sales, avg(p.product_price * op.order_quantity) as avg_product_sales
from `Order_has_Product` as op, `Product` as p 
where op.product_id= p.product_id
group by p.product_name
having total_product_sales > 1000
order by total_product_sales desc
;

/* in */
select * 
from `Member` as m
where m.address_city in ('台北市', '新竹市');

/* in 2 */
select * 
from `Order` as o
where o.member_id not in 
(
	select m.member_id
    from `Member` as m
    where m.age < 20
);

/* correlated nested query */
select * 
from `Rookie_Employee` as r
where r.address_city in 
(select address_city
from `Tenured_employee` as t
where t.gender = r.gender);

/* correlated nested query 2 */
select * 
from `Rookie_Employee` as r
where exists
(select * 
from `Tenured_employee` as t
where r.address_city = t.address_city 
and r.gender = t.gender
);

/* bonus 1 */
select t1.employee_id, t1.name as "employee name", t2.employee_id, t2.name as "employee's subordinate"
from `Tenured_Employee` as t1
left outer join `Tenured_employee` as t2
on t2.manager_id = t1.employee_id;

/* bonus 2 */
select * 
from `Rookie_Employee` as r
where not exists
(select * 
from `Tenured_employee` as t
where r.address_city = t.address_city 
and r.gender = t.gender
);


-- -----------------------------------------------------
-- drop database
-- -----------------------------------------------------
DROP DATABASE fashionCo;


