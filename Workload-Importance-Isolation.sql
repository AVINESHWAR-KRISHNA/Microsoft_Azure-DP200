-- WorkLoad

--Master


IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'PrimeUser')
BEGIN
CREATE LOGIN [PrimeUser] WITH PASSWORD = 'This!s@StrongPW';
END

-- AzureDB

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'PrimeUser')
BEGIN
CREATE USER [PrimeUser] FOR LOGIN [PrimeUser]
END
;

CREATE WORKLOAD CLASSIFIER [wgcPrimeUser]
WITH (WORKLOAD_GROUP = 'xlargerc'
      ,MEMBERNAME = 'PrimeUser'
      ,IMPORTANCE = HIGH);

SELECT * FROM sys.workload_management_workload_classifiers;

-- DROP WORKLOAD CLASSIFIER [wgcPrimeUser]
-- DROP USER [PrimeUser]
;

--------------------------------------------------------------------------------------------------------
-- Importance

-- Master

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ImportantUser')
BEGIN
CREATE LOGIN [ImportantUser] WITH PASSWORD='<This!s@StrongPW>'
END
;

-- AzureDB

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'ImportantUser')
BEGIN
CREATE USER [ImportantUser] FOR LOGIN [ImportantUser]
END
;


CREATE WORKLOAD CLASSIFIER wgcHighRole
  WITH (WORKLOAD_GROUP = 'staticrc20'
       ,MEMBERNAME = 'ImportantUser'
      ,IMPORTANCE = HIGH);

--------------------------------------------------------------------------------------------------------
-- Isolation

-- Master

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'IsoUser')
BEGIN
CREATE LOGIN [IsoUser] WITH PASSWORD='This!s@StrongPW'
END
;

-- AzureBD

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'IsoUser')
BEGIN
CREATE USER [IsoUser] FOR LOGIN [IsoUser]
END
;

CREATE WORKLOAD GROUP DataLoads
WITH ( MIN_PERCENTAGE_RESOURCE = 30   
      ,CAP_PERCENTAGE_RESOURCE = 80
      ,REQUEST_MIN_RESOURCE_GRANT_PERCENT = 5) 
;

CREATE WORKLOAD CLASSIFIER [wgcIsoUser]
WITH (WORKLOAD_GROUP = 'DataLoads'
      ,MEMBERNAME = 'IsoUser')
;
