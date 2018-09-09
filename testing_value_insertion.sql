/*--------------------------------------------------Inserting Values-----------------------------------------------------*/
INSERT INTO [production_unitIdDomain] ([unit_Id]) VALUES('U1');
INSERT INTO [production_unitIdDomain] ([unit_Id]) VALUES('U2');
INSERT INTO [production_unitIdDomain] ([unit_Id]) VALUES('U3');
INSERT INTO [production_unitIdDomain] ([unit_Id]) VALUES('U4');
INSERT INTO [production_unitIdDomain] ([unit_Id]) VALUES('U5');
/*-----------------------------------------------------------------------------------------------------------------------*/

INSERT INTO [productIdsDomain] ([productId]) VALUES('P1');
INSERT INTO [productIdsDomain] ([productId]) VALUES('P2');
INSERT INTO [productIdsDomain] ([productId]) VALUES('P3');
INSERT INTO [productIdsDomain] ([productId]) VALUES('P4');
INSERT INTO [productIdsDomain] ([productId]) VALUES('P5');
/*-----------------------------------------------------------------------------------------------------------------------*/

INSERT INTO [operatorIdsDomain] ([operatorId]) VALUES('O1');
INSERT INTO [operatorIdsDomain] ([operatorId]) VALUES('O2');
INSERT INTO [operatorIdsDomain] ([operatorId]) VALUES('O3');
INSERT INTO [operatorIdsDomain] ([operatorId]) VALUES('O4');
INSERT INTO [operatorIdsDomain] ([operatorId]) VALUES('O5');
/*-----------------------------------------------------------------------------------------------------------------------*/
 
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P1','U1');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P1','U2');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P2','U1');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P2','U2');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P2','U4');

INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P3','U1');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P3','U2');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P3','U3');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P3','U4');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P3','U5');

INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P4','U2');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P4','U3');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P5','U4');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P5','U5');
INSERT INTO [product_unitId_Domain] ([productID],[unitID]) VALUES('P5','U1');

/*-------------------------------------------------------------------------------------------------------------------------*/
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U1','O1');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U1','O2');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U2','O1');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U2','O5');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U2','O2');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U3','O3');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U3','O4');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U3','O2');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U5','O1');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U5','O2');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U5','O3');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U4','O2');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U4','O3');
INSERT INTO [production_unit_operatorIdDomain] ([unit_ID],[unit_operatorId]) VALUES('U4','O1');
/*-------------------------------------------------Insert Into Lotno limit---------------------------------------------------*/
INSERT INTO [lotNo_limit] ([lmtno_range],[updateDate]) VALUES (10,date('now')); 

/*---------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P1','U1','O1','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P1','U1','O1','2017-09-12',2);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P1','U1','O1','2017-09-12',3);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P2','U1','O1','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P1','U2','O1','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P1','U2','O2','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P2','U1','O2','2017-09-12',6);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P4','U3','O2','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P4','U3','O2','2017-09-12',2);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P5','U4','O3','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P4','U2','O1','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P3','U1','O1','2017-09-12',1);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P2','U1','O1','2017-09-12',2);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P1','U1','O2','2017-09-12',2);

INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P3','U1','O2','2017-09-12',9);
INSERT INTO [manufact_productCode] ([productId],[unitId],[operatorId],[mfd_date],[lotNo]) VALUES('P2','U1','O1','2017-09-12',10);
/*----------------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO billInfo VALUES('ordNo1','2017/08/19');
INSERT INTO billInfo VALUES('ordNo2','2017/08/20');
INSERT INTO billInfo VALUES('ordNo3','2017/08/21');

/*----------------------------------------------------------------------------------------------------------------------------------------*/
INSERT INTO orderDetails VALUES('ordNo1','P1U1O12017-09-123');
INSERT INTO orderDetails VALUES('ordNo1','P2U1O12017-09-121');
INSERT INTO orderDetails VALUES('ordNo1','P1U2O12017-09-121');
INSERT INTO orderDetails VALUES('ordNo2','P5U4O32017-09-121');
INSERT INTO orderDetails VALUES('ordNo2','P4U2O12017-09-121');
INSERT INTO orderDetails VALUES('ordNo2','P2U1O22017-09-122');
INSERT INTO orderDetails VALUES('ordNo2','P1U1O22017-09-122');
INSERT INTO orderDetails VALUES('ordNo3','P3U1O22017-09-129');
INSERT INTO orderDetails VALUES('ordNo3','P2U1O12017-09-1210');
                                               
/*----------------------------------------------------------------------------------------------------------------------------------------*/
insert into [update_date_of_fault] values(2,'2017-09-13');
insert into temp_maybe_claim_Details values('ordNo1','P1U1O12017-09-123','2017-09-14');
insert into temp_maybe_claim_Details values('ordNo1','P2U1O12017-09-121','2017-09-14');
insert into temp_maybe_claim_Details values('ordNo2','P4U2O12017-09-121','2017-09-14');
