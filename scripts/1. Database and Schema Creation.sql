USE master ;
GO

CREATE DATABASE DataWareHouse ;

-- Drop and recreate the 'DataWareHouse' database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name ='DataWareHouse')
BEGIN
	ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE ;
	DROP DATABASE DataWareHouse ;
END;
GO

USE DataWareHouse ;
GO   


-- Create Schemas
CREATE SCHEMA bronze ;
GO

CREATE SCHEMA silver ;
GO

CREATE SCHEMA gold ;