/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

===============================================================================
*/




--=================================================================================================
CREATE OR ALTER PROCEDURE  bronze.load_bronze AS
BEGIN
	DECLARE @Start_time DATETIME,@end_time DATETIME;
	BEGIN TRY
		PRINT '====================================';
		PRINT 'Loading Bronze Layer';
		PRINT '====================================';


		PRINT '====================================';
		PRINT 'Loading CRM Tables';
		PRINT '====================================';
	
	
		SET @Start_time=GETDATE();
		PRINT '<< Truncating Table:bronze.crm_cst_info';
		TRUNCATE TABLE bronze.crm_cst_info;


		PRINT '>> Inserting Data Into:bronze.crm_cst_info';
		BULK INSERT bronze.crm_cst_info
		from 'C:\SQL2025\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @End_time=GETDATE();
		
		PRINT '>>Load Duration: ' +CAST(DATEDIFF(SECOND,@Start_time,@end_time) AS NVARCHAR(20) ) +'SECONDS';
		PRINT '>>------------------';
		--===========================================
		SET @Start_time=GETDATE();
		PRINT '<< Truncating Table:bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;
		
		
		PRINT '>> Inserting Data Into:bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info


		from 'C:\SQL2025\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @End_time=GETDATE();
		PRINT '>>Load Duration: ' +CAST(DATEDIFF(SECOND,@Start_time,@end_time) AS NVARCHAR(20) ) +'SECONDS';
		PRINT '>>------------------';

		---==========================================================
		SET @Start_time=GETDATE();
		PRINT '<< Truncating Table:bronze.crm_sls_info'
		TRUNCATE TABLE bronze.crm_sls_info;
		
		
		
		PRINT '>> Inserting Data Into:bronze.crm_sls_info'
		BULK INSERT bronze.crm_sls_info

		from 'C:\SQL2025\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @End_time=GETDATE();
		PRINT '>>Load Duration: ' +CAST(DATEDIFF(SECOND,@Start_time,@end_time) AS NVARCHAR(20) ) +'SECONDS';
		PRINT '>>------------------';
	
		--======================================================================================================
		SET @Start_time=GETDATE();
		PRINT '===================================='
		PRINT 'Loading ERP Tables'
		PRINT '===================================='
	

		PRINT '<< Truncating Table:bronze.erp_CUST_AZ12'
		TRUNCATE TABLE bronze.erp_CUST_AZ12;


		PRINT '>> Inserting Data Into:bronze.erp_CUST_AZ12'
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\SQL2025\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.CSV'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @End_time=GETDATE();
		PRINT '>>Load Duration: ' +CAST(DATEDIFF(SECOND,@Start_time,@end_time) AS NVARCHAR(20) ) +'SECONDS';
		PRINT '>>------------------';


		--=========================================================================
		SET @Start_time=GETDATE();
		PRINT '<< Truncating Table:bronze.erp_LOC_A101'
		TRUNCATE TABLE bronze.erp_LOC_A101;
		
		
		
		
		PRINT '>> Inserting Data Into:bronze.erp_LOC_A101'
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\SQL2025\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.CSV'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @End_time=GETDATE();
		PRINT '>>Load Duration: ' +CAST(DATEDIFF(SECOND,@Start_time,@end_time) AS NVARCHAR(20) ) +'SECONDS';
		PRINT '>>------------------';



		--=========================================================================
		SET @Start_time=GETDATE();
		PRINT '<< Truncating Table:bronze.erp_PX_CAT_g1v2'
		TRUNCATE TABLE bronze.erp_PX_CAT_g1v2;
		
		
		
		PRINT '>> Inserting Data Into:bronze.erp_PX_CAT_g1v2'
		BULK INSERT bronze.erp_PX_CAT_g1v2
		FROM 'C:\SQL2025\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.CSV'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @End_time=GETDATE();
		PRINT '>>Load Duration: ' +CAST(DATEDIFF(SECOND,@Start_time,@end_time) AS NVARCHAR(20) ) +'SECONDS';
		PRINT '>>------------------';

	END TRY
	BEGIN CATCH
	PRINT '======================================================='
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'Error Message'+ ERROR_MESSAGE();
	PRINT 'Error Message'+ CAST(ERROR_NUMBER() AS NVARCHAR(20));
	PRINT 'Error Message'+ CAST(ERROR_STATE() AS NVARCHAR(20));

	PRINT'======================================================='
	END CATCH
END




