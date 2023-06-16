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

CREATE TABLE IF NOT EXISTS `fashionCo`.`Employee` (
  `employee_id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(125) NOT NULL,
  `manager_id` VARCHAR(100) NULL,
  `gender` ENUM('male', 'female') NOT NULL,
  `email` VARCHAR(125) NOT NULL,
  `honor_degree` INT NOT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `fk_Employee_Employee1`
    FOREIGN KEY (`manager_id`)
    REFERENCES `fashionCo`.`Employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Employee_Roles` (
  `er_id` VARCHAR(100) NOT NULL,
  `role_name` VARCHAR(125) NOT NULL,
  PRIMARY KEY (`er_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Employee_has_Employee_Roles` (
  `employee_id` VARCHAR(100) NOT NULL,
  `er_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`employee_id`, `er_id`),
  CONSTRAINT `fk_Employee_has_Employee_Roles_Employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `fashionCo`.`Employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_has_Employee_Roles_Employee_Roles1`
    FOREIGN KEY (`er_id`)
    REFERENCES `fashionCo`.`Employee_Roles` (`er_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Tenured_Employee` (
  `employee_id` VARCHAR(100) NOT NULL,
  `name` VARCHAR(125) NOT NULL,
  `tenured_pay` INT NOT NULL DEFAULT 2000000 CHECK (`tenured_pay` > 0),
  `gender` ENUM('male', 'female') NULL,
  `email` VARCHAR(125) NULL,
  `honor_degree` INT NOT NULL,
  `manager_id` VARCHAR(256) NULL,
    CONSTRAINT `fk_Tenured_Employee_Employee1`
    FOREIGN KEY (`manager_id`)
    REFERENCES `fashionCo`.`Tenured_Employee` (`employee_id`)
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
  CONSTRAINT `fk_Rookie_Employee_Employee1`
  FOREIGN KEY (`manager_id`)
  REFERENCES `fashionCo`.`Rookie_Employee` (`employee_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
  PRIMARY KEY (`employee_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Social_Media_Teamer` (
  `employee_id` VARCHAR(100) NOT NULL,
  `social_media_worker_type` VARCHAR(45) NOT NULL,
  `retired_id` VARCHAR(100) NULL,
  PRIMARY KEY (`employee_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Engineer_Teamer` (
  `employee_id` VARCHAR(100) NOT NULL,
  `engineer_type` VARCHAR(45) NOT NULL,
  `retired_id` VARCHAR(100) NULL,
  PRIMARY KEY (`employee_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Sales_Teamer` (
  `employee_id` VARCHAR(100) NOT NULL,
  `sales_type` VARCHAR(45) NOT NULL,
  `retired_id` VARCHAR(100) NULL,
  PRIMARY KEY (`employee_id`))
;

CREATE TABLE IF NOT EXISTS `fashionCo`.`Retired_Employee` (
  `retired_id` VARCHAR(100) NOT NULL,
  `retired_employee_name` VARCHAR(125) NOT NULL,
  `retired_date` BIGINT NULL,
  `retired_description` VARCHAR(125) NULL,
  PRIMARY KEY (`retired_id`))
;


-- -----------------------------------------------------
-- create views 
-- -----------------------------------------------------
create view `fashionCo`.`Product_Total_Sales` as
select p.product_name, sum(p.product_price * op.order_quantity) as total_product_sales
from `Order_has_Product` as op, `Product` as p 
where op.product_id= p.product_id
group by p.product_name
order by total_product_sales desc
;

create view `fashionCo`.`Best_Seller_Of_Different_Gender` as
select g.product_name, g.gender
from (
	select p.product_name, m.gender, rank() over(partition by m.gender order by (p.product_price * op.order_quantity) desc) as 'rn'
    from `Order_has_Product` as op, `Product` as p, `Member` as m
    where op.product_id = p.product_id and op.member_id = m.member_id
) g
where g.rn = 1;


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
INSERT INTO `Employee` (`employee_id`, `name`, `gender`, `email`, `honor_degree`) VALUES ('e231830d-9ddf-40ec-b0db-fe07521e822b', 'Jane', 'female', 'jane@gmail.com', 3);
INSERT INTO `Employee`  VALUES ('26182057-8558-416a-84dd-0115751ac88a', 'Mary', 'e231830d-9ddf-40ec-b0db-fe07521e822b', 'female', 'mary@gmail.com', 1);
INSERT INTO `Employee`  VALUES ('d02388db-8aae-404d-82cb-6ec7d6bc3c7e', 'Henry', 'e231830d-9ddf-40ec-b0db-fe07521e822b', 'male', 'henry@gmail.com', 2);
INSERT INTO `Employee_Roles`  VALUES ('3574ea71-4c60-4854-9687-b1ca0daddbe3', 'staff');
INSERT INTO `Employee_Roles`  VALUES ('e2bdd684-ec31-4c48-aefb-d11b2597e428', 'COO');
INSERT INTO `Employee_Roles`  VALUES ('dd51213c-9036-4254-a1bc-f052eb17ae1f', 'CEO');
INSERT INTO `Employee_Roles`  VALUES ('30331362-dd70-494e-9bf0-7fa528ebc966', 'Board Member');
INSERT INTO `Employee_has_Employee_Roles`  VALUES ('26182057-8558-416a-84dd-0115751ac88a', '3574ea71-4c60-4854-9687-b1ca0daddbe3');
INSERT INTO `Employee_has_Employee_Roles`  VALUES ('d02388db-8aae-404d-82cb-6ec7d6bc3c7e', '3574ea71-4c60-4854-9687-b1ca0daddbe3');
INSERT INTO `Employee_has_Employee_Roles`  VALUES ('e231830d-9ddf-40ec-b0db-fe07521e822b', 'dd51213c-9036-4254-a1bc-f052eb17ae1f');
INSERT INTO `Employee_has_Employee_Roles`  VALUES ('e231830d-9ddf-40ec-b0db-fe07521e822b', '30331362-dd70-494e-9bf0-7fa528ebc966');
INSERT INTO `Tenured_Employee` (`employee_id`, `name`, `tenured_pay`, `gender`, `email`, `honor_degree`) VALUES ('27ecbb9e-7710-4f63-ba3d-29b851d143b4', 'John', 100000, 'male', 'john@gmail.com', 6);
INSERT INTO `Tenured_Employee` (`employee_id`, `name`, `tenured_pay`, `gender`, `email`, `honor_degree`) VALUES ('d36022e2-01c4-48be-8652-e22cb4534734', 'Frank', 10000, 'male', 'frank@gmail.com', 5);
INSERT INTO `Tenured_Employee`  VALUES ('d26f16e9-6912-430c-a4cc-accd88f028d5', 'PJ', 10000, 'female', 'pj@gmail.com', 5, '27ecbb9e-7710-4f63-ba3d-29b851d143b4');
INSERT INTO `Rookie_Employee` (`employee_id`, `name`, `rookie_pay`, `gender`, `email`, `honor_degree`) VALUES ('1a605da8-a1b8-4681-aeab-862d81e71eb4', 'Brandon', 50000, 'male', 'brandon@gmail.com', 1);
INSERT INTO `Rookie_Employee` (`employee_id`, `name`, `rookie_pay`, `gender`, `email`, `honor_degree`) VALUES ('3f2cbed9-68ca-4ff0-8867-54b83f8640c8', 'Linda', 50000, 'female', 'linda@gmail.com', 1);
INSERT INTO `Rookie_Employee` (`employee_id`, `name`, `rookie_pay`, `gender`, `email`, `honor_degree`) VALUES ('c837689b-3086-440c-830a-d65b625aa9f1', 'Jasper', 50000, 'male', 'jasper@gmail.com', 1);
INSERT INTO `Social_Media_Teamer`  VALUES ('b06ea31e-4c36-4591-8930-3216f8630e5f', 'Facebook', 'd37ea9d9-867f-4514-98fc-1c66442f0dd4');
INSERT INTO `Social_Media_Teamer` (`employee_id`, `social_media_worker_type`) VALUES ('daff8e02-7ab4-4a28-862e-fae5e9f5aa58', 'Twitter');
INSERT INTO `Social_Media_Teamer` (`employee_id`, `social_media_worker_type`) VALUES ('40bb345a-5a9f-4cc4-9299-653e8d7fe0d8', 'Instagram');
INSERT INTO `Engineer_Teamer`  VALUES ('dedc9bf7-f8fb-4eb7-8f73-5a4016a11986', 'Backend', '433e877a-eb2f-40ed-9aa6-43c17429117e');
INSERT INTO `Engineer_Teamer` (`employee_id`, `engineer_type`) VALUES ('066c220f-42d8-4cda-980c-1e05dbdfc3d8', 'Frontend');
INSERT INTO `Engineer_Teamer` (`employee_id`, `engineer_type`) VALUES ('ad5c7fb7-dadc-4282-a3f0-aad3ff68c54e', 'Data');
INSERT INTO `Sales_Teamer` VALUES ('c2c687e1-8b81-4d81-970e-c42f78a55ed0', 'Product Sales', 'a6f8dbdc-3752-4313-b3fa-4340416901b4');
INSERT INTO `Sales_Teamer` (`employee_id`, `sales_type`) VALUES ('5f5731cc-f407-4591-a246-58e5562f3ccb', 'Platform Sales');
INSERT INTO `Sales_Teamer` (`employee_id`, `sales_type`) VALUES ('3436b041-ae2a-4bd3-88e1-d2134f11852a', 'General Sales');
INSERT INTO `Retired_Employee` VALUES ('a6f8dbdc-3752-4313-b3fa-4340416901b4', 'Stella', 1680594750633, 'family disease');
INSERT INTO `Retired_Employee` VALUES ('d37ea9d9-867f-4514-98fc-1c66442f0dd4', 'Cindy', 1680594802630, 'family disease');
INSERT INTO `Retired_Employee` VALUES ('433e877a-eb2f-40ed-9aa6-43c17429117e', 'Verity', 1680594828927, 'family disease');


-- -----------------------------------------------------
-- select from all tables and views
-- -----------------------------------------------------
select * from `Collection`;
select * from `Employee`;
select * from `Employee_has_Employee_Roles`;
select * from `Employee_Roles`;
select * from `Engineer_Teamer`;
select * from `Member`;
select * from `Product`;
select * from `Order`;
select * from `Order_has_Product`;
select * from `Payment`;
select * from `Product_Images`;
select * from `Retired_Employee`;
select * from `Rookie_Employee`;
select * from `Sales_Teamer`;
select * from `Social_Media_Teamer`;
select * from `Tenured_Employee`;
select * from `Product_Total_Sales`;
select * from `Best_Seller_Of_Different_Gender`;
;


-- -----------------------------------------------------
-- drop database
-- -----------------------------------------------------
DROP DATABASE fashionCo;


















