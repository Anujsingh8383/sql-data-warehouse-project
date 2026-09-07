/*
===============================================
Create Database and Schemas
===============================================
Script Purpose:
This script initializes a fresh instance of the 'DataWarehouse' database. 
If an existing database with the same name is found, it will be dropped 
and recreated to ensure a clean environment. The script also provisions 
three schemas — 'bronze', 'silver', and 'gold' — to support a layered 
data architecture for staging, transformation, and analytics.

WARNING:
Executing this script will permanently remove any existing 'DataWarehouse' 
database and its contents. Ensure backups are taken before proceeding.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DataWarehouse;
END;
GO

-- Create the "DataWarehouse" database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
go

-- Create Schemas

