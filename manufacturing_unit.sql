PRAGMA foreign_key=ON;
PRAGMA recursive_triggers = ON;

/**********************************************************************************************/
DROP TABLE IF EXISTS [production_unitId_Domain];
DROP TABLE IF EXISTS [productIdsDomain];
DROP TABLE IF EXISTS [operatorIdsDomain];
DROP TABLE IF EXISTS [product_unitIdDomain];
DROP TABLE IF EXISTS [production_unit_operatorIdDomain];
DROP TABLE IF EXISTS [lotNo_Domain];
DROP TABLE IF EXISTS [lotNo_limit];
DROP TABLE IF EXISTS [temp_aux_limit];
DROP TABLE IF EXISTS [retailShop];
DROP TABLE IF EXISTS [billInfo];
DROP TABLE IF EXISTS [orderDetails];
DROP TABLE IF EXISTS [temp_maybe_Claim_Details];
DROP TABLE IF EXISTS [claimDetails];
DROP TABLE IF EXISTS [temp_manufacturing_unitclaim_details];
DROP TABLE IF EXISTS [Black_listed_operators];
DROP TABLE IF EXISTS [track_opt_performancs];
DROP TABLE IF EXISTS [currentmin_fault_that_allowed];
DROP TABLE IF EXISTS [update_date_of_fault];	
/*----------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS [productIdsDomain]
(
	[productId] TEXT NOT NULL,
	CONSTRAINT [pkc_productIds] Primary Key([productId]) 
);
CREATE TABLE IF NOT EXISTS [production_unitIdDomain]
(
        [unit_Id] TEXT NOT NULL,
        CONSTRAINT [pkc_production_unitIdDomain] Primary Key(unit_Id)
);


CREATE TABLE IF NOT EXISTS [operatorIdsDomain]
(
	[operatorId] TEXT NOT NULL,
	CONSTRAINT [pkc_operatorsIds] Primary Key([operatorId])

);
/*-------------------------------------------After Insertion of new operator his/her performance is tracked-------------------------------*/
CREATE TRIGGER IF NOT EXISTS [t_optperfrm] AFTER INSERT ON [operatorIdsDomain]
 BEGIN
	INSERT INTO [track_opt_performancs] VALUES(NEW.operatorId,0);
 END;
/*----------------------------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS [product_unitId_Domain]
(
	[productID] TEXT NOT NULL,
	[unitID] TEXT NOT NULL,
		

	Foreign Key ([productID]) REFERENCES [productIdsDomain]([productId])
	ON DELETE RESTRICT ON UPDATE CASCADE,
	Foreign Key ([unitID]) REFERENCES [product_unitIdDomain]([unit_Id])
	ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT [pkc_product_unitId] Primary Key([productID],[unitID])
);
/*--Tables and triggers to allow the number of fault that can be considered to prevent them from direct blacklist--*/
CREATE TABLE IF NOT EXISTS [current_min_fault_that_allowed]
(
	minlimit INTEGER NOT NULL
	
);
CREATE TABLE IF NOT EXISTS [update_date_of_fault]
(
	lmtoffault INTEGER NOT NULL,
	lupDate DATE NOT NULL,
	CONSTRAINT [pkc_updatelimit] Primary Key([lmtoffault],[lupDate])
);
CREATE TRIGGER IF NOT EXISTS [t_currentlmt] AFTER INSERT ON [update_date_of_fault]
  WHEN NEW.lmtoffault>0
  BEGIN
	DELETE FROM [current_min_fault_that_allowed]; 
  	INSERT INTO [current_min_fault_that_allowed] ([minlimit]) VALUES(NEW.lmtoffault);
  END;
/*----------------------------------------------------------------------------------------------------------------------------------------*/ 
CREATE TABLE IF NOT EXISTS [production_unit_operatorIdDomain]
(
	[unit_ID] TEXT NOT NULL,
	[unit_operatorId] TEXT NOT NULL,
	
	Foreign Key ([unit_ID]) REFERENCES [production_UnitIdDomain]([unit_Id])
	ON DELETE RESTRICT ON UPDATE CASCADE,
	Foreign Key ([unit_operatorId]) REFERENCES [operatorIdsDomain]([operatorId])
	ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT [pkc_production_unit_operatorId] Primary Key([unit_ID],[unit_operatorId])
);
/*----------------------------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS [lotNo_Domain]
(
	[lotNos] INTEGER NOT NULL,
	CONSTRAINT [pkc_lotNo_Domain] Primary Key([lotNos])
);
CREATE TABLE IF NOT EXISTS [lotNo_limit]
(
	[lmtno_range] INTEGER NOT NULL,
	[updateDate] DATE NOT NULL,
	CONSTRAINT [pkc_lotNo_limit] Primary Key ([lmtno_range],[updateDate])
);
CREATE TABLE IF NOT EXISTS [temp_aux_limit]
(
	aux_limit INTEGER
);

CREATE TRIGGER IF NOT EXISTS [t_lotNo_limit] AFTER INSERT ON [lotNo_limit]
  WHEN NEW.lmtno_range > 0
  BEGIN
 
    INSERT INTO [temp_aux_limit] VALUES(NEW.lmtno_range);
    DELETE FROM [lotNo_Domain];
    INSERT INTO lotNo_Domain VALUES(1);

  END;

CREATE TRIGGER IF NOT EXISTS [t_aux_limit] AFTER INSERT ON [lotNo_Domain]
 WHEN 
  NEW.lotNos < (SELECT aux_limit FROM temp_aux_limit)
 BEGIN
  INSERT INTO lotNo_Domain VALUES(NEW.lotNos + 1);
  DELETE FROM [temp_aux_limit];
 END;
/*________________________________________________________________________________________________________________________________________*/
CREATE TABLE IF NOT EXISTS [manufact_productCode]
(
	[productId] TEXT NOT NULL,
	[unitId] TEXT NOT NULL,
	[operatorId] TEXT NOT NULL,
	[mfd_date] DATE NOT NULL,
	[lotNo] TEXT NOT NULL,  	

	Foreign Key ([productId],[unitId]) REFERENCES product_unitId_Domain([productID],[unitID]) 
	ON DELETE RESTRICT ON UPDATE CASCADE,
	Foreign Key ([operatorId],[unitId]) REFERENCES production_unit_operatorIdDomain([unit_operatorId],[unitID]) 
	ON DELETE RESTRICT ON UPDATE CASCADE,
	Foreign Key ([lotNo]) REFERENCES lotNo_Domain([lotNos])
	ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT pkc_procode Primary Key([productId],[unitId],[operatorId],[mfd_date],[lotNo])	 
);
/***************After insert on manufact_productcode product will be sent to it's retailShop************/
CREATE TRIGGER IF NOT EXISTS [trig_sell] AFTER INSERT ON [manufact_productCode]
   BEGIN
 	INSERT INTO [retailShop] VALUES( (NEW.[productId]||NEW.[unitId]||NEW.[operatorId]||NEW.[mfd_date]||NEW.[lotNo]),NEW.productId,'NOT SOLD');
   END;  
/*****************************************************************************************************/
CREATE TABLE IF NOT EXISTS [retailShop]
(
 	
	productcode TEXT NOT NULL,
	productId TEXT NOT NULL,
	status TEXT NOT NULL,
	CONSTRAINT pkc_retailshop Primary Key([productcode])
);
/********************************************Bill Info Table******************************************/
CREATE TABLE IF NOT EXISTS [billInfo]
(
	[billNo] TEXT NOT NULL,
	[bill_date] DATE NOT NULL,
	CONSTRAINT pkc_billInfo Primary Key ([billNo])
	
);
/****************************************************************************************************/
CREATE TABLE IF NOT EXISTS [orderDetails]
(
	billnos TEXT NOT NULL,
	productCode TEXT NOT NULL,
	CONSTRAINT pkc_ordDetails Primary Key([billnos],[productCode]),
	Foreign Key ([productCode]) REFERENCES [retailShop]([productcode])
	ON DELETE RESTRICT ON UPDATE CASCADE
	
);
/******After insert on product in ordertable status of product will be changed from NOT SOLD to SOLD**********/
CREATE TRIGGER IF NOT EXISTS [trig_ordDetalis]AFTER INSERT ON [orderDetails]
 BEGIN
	UPDATE retailShop
	SET status="SOLD" WHERE productcode = NEW.productCode;
 END;
/******************claims****************************/
CREATE TABLE IF NOT EXISTS [claimDetails]
(
	[claimId] TEXT NOT NULL,
	[pro_code] TEXT NOT NULL,
	[claimDate] DATE NOT NULL,
	[Status] TEXT NOT NULL,	
	CONSTRAINT [pkc_claimDetails] Primary Key([claimId]) 
);
CREATE TABLE IF NOT EXISTS [temp_maybe_claim_Details]
(
	[billno] TEXT,
	[productcode] TEXT,
	[claimDate] date 

);
/******After insert on maybe claim Details****************/
CREATE TRIGGER IF NOT EXISTS [trig_validbill] BEFORE INSERT ON [temp_maybe_claim_Details]
 BEGIN
	SELECT CASE 
  	WHEN NEW.[billno] NOT IN (SELECT [billNo] FROM [billInfo]) 
	THEN
	RAISE(ABORT,'THIS Bill No is Invalid')
	END;
END;
/*---------------------------------------------------------*/
CREATE TRIGGER IF NOT EXISTS [trig_validprocode] BEFORE INSERT ON [temp_maybe_claim_Details]
  BEGIN
	SELECT CASE
	WHEN
	NEW.[productcode] NOT IN (SELECT [productCode] FROM [orderDetails] WHERE [billnos]=NEW.[billno])
	THEN
	RAISE(ABORT,'This productCode is not placed at this billno')
	END;
END;

/*------------------------------------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER IF NOT EXISTS  [trig_claimDetails] AFTER INSERT ON [temp_maybe_claim_Details]
  BEGIN
	INSERT INTO claimDetails VALUES (NEW.billNo||NEW.productcode,NEW.productcode,NEW.claimDate,'In ProCess');
	DELETE FROM [temp_maybe_claim_Details];
  END;

/*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS [temp_manufacturing_unitclaim_details]
(
 	claimID TEXT,
	proCode TEXT,
	CONSTRAINT pkc_unitclaim Primary Key(claimId)	
);
/*------------------------------------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER IF NOT EXISTS [trig_mnc] AFTER INSERT ON [claimDetails]
  BEGIN
	INSERT INTO [temp_manufacturing_unitclaim_details] VALUES(NEW.claimId,NEW.pro_code);
  END;
/*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS [claimed_unit_operatorDetails]
( 
	claimId TEXT NOT NULL,	
	productId TEXT NOT NULL,
	procode TEXT NOT NULL,
	unitId TEXT NOT NULL,
	operatorId NOT NULL
	
);
/*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE TRIGGER IF NOT EXISTS [t_mnctoclaim] AFTER INSERT ON [temp_manufacturing_unitclaim_details] 
  BEGIN
	INSERT INTO [claimed_unit_operatorDetails] SELECT NEW.claimId,productID,Pro_Code,unitID,operatorID from v_claimInfo WHERE Pro_Code = 	    NEW.proCode;
	DELETE FROM [temp_manufacturing_unitclaim_details];
END;
/*-----------------------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS [track_opt_performancs]
(
	[operatorId] TEXT NOT NULL,
	[no_faulty_product]  INTEGER NOT NULL
);
CREATE TRIGGER IF NOT EXISTS t_temp AFTER INSERT ON [claimed_unit_operatorDetails]
  BEGIN
	UPDATE [track_opt_performancs] SET [no_faulty_product]=(SELECT no_faulty_product FROM [track_opt_performancs] WHERE [operatorId]=NEW.operatorId)+1 WHERE [operatorId]=NEW.[operatorId];
	UPDATE claimDetails SET Status='ProcessComplete' WHERE claimId=NEW.claimId;
  END;
/*----------------------------------------------------------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS [Black_listed_operators]
(	
	b_operatorId TEXT NOT NULL,
	CONSTRAINT [pkc_black_listed_operators] Primary Key([b_operatorId])
);
CREATE TRIGGER IF NOT EXISTS [t_tracktoblacklist] AFTER UPDATE ON [track_opt_performancs]
 WHEN NEW.[no_faulty_product]> (SELECT [minlimit] FROM [current_min_fault_that_allowed])
 BEGIN
 	INSERT INTO [Black_listed_operators] VALUES(NEW.operatorId);
 END;
/*-----------------------------------------------View For Product Code--------------------------------------------------------------------*/
CREATE VIEW IF NOT EXISTS v_claimInfo AS SELECT productID,unitID,operatorID,mfd_date,lotNo,(productID||unitID||operatorID||mfd_date||lotNo) as Pro_Code  FROM manufact_productCode; 
/*----------------------------------------------------------------------------------------------------------------------------------------*/

CREATE TRIGGER IF NOT EXISTS [t_blacklistopre] AFTER INSERT ON [Black_listed_operators]
 BEGIN
  DELETE FROM operatorIdsDomain WHERE operatorId = NEW.b_operatorId;
  DELETE FROM production_unit_operatorIdDomain WHERE unit_operatorId = NEW.b_operatorId;
END;



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










