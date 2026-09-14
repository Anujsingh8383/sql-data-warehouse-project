/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================

Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.
===============================================================================
*/


CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        -- A transaction ensures that all tables load successfully,
        -- or none of the partial Silver-layer changes are retained.
        BEGIN TRANSACTION;

        PRINT '=============================================';
        PRINT 'Loading Silver Layer';
        PRINT '=============================================';

        -- ============================================================
        -- Load CRM Customer Information
        -- ============================================================

        SET @start_time = GETDATE();
        PRINT ' > Truncating Table: silver.crm_cst_info';
        TRUNCATE TABLE silver.crm_cst_info;

        PRINT ' > Inserting Data Into: silver.crm_cst_info';

        INSERT INTO silver.crm_cst_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_material_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            COALESCE(cst_id, 0) AS cst_id,
            COALESCE(NULLIF(TRIM(cst_key), ''), 'N/A') AS cst_key,
            COALESCE(NULLIF(TRIM(cst_firstname), ''), 'N/A') AS cst_firstname,
            COALESCE(NULLIF(TRIM(cst_lastname), ''), 'N/A') AS cst_lastname,

            -- Convert marital-status codes into full descriptions
            CASE TRIM(cst_material_status)
                WHEN 'S' THEN 'SINGLE'
                WHEN 'M' THEN 'MARRIED'
                ELSE COALESCE(NULLIF(TRIM(cst_material_status), ''), 'N/A')
            END AS cst_material_status,

            -- Convert gender codes into full descriptions
            CASE TRIM(cst_gndr)
                WHEN 'F' THEN 'FEMALE'
                WHEN 'M' THEN 'MALE'
                ELSE COALESCE(NULLIF(TRIM(cst_gndr), ''), 'N/A')
            END AS cst_gndr,

            cst_create_date
        FROM (
            -- Keep only the most recent record for each customer ID
            SELECT *,
                   ROW_NUMBER() OVER (
                       PARTITION BY cst_id
                       ORDER BY cst_create_date DESC
                   ) AS flag_last
            FROM bronze.crm_cst_info
        ) AS source_data
        WHERE flag_last = 1;

        SET @end_time = GETDATE();
        PRINT ' >> Customer load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        -- ============================================================
        -- Load CRM Product Information
        -- ============================================================

        SET @start_time = GETDATE();
        PRINT ' > Truncating Table: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT ' > Inserting Data Into: silver.crm_prd_info';

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,

            -- Extract category ID and product key from the source key
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,

            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,

            -- Convert product-line codes into descriptive values
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'MOUNTAIN'
                WHEN 'R' THEN 'ROAD'
                WHEN 'S' THEN 'OTHER SALES'
                WHEN 'T' THEN 'TOURING'
                ELSE 'N/A'
            END AS prd_line,

            CAST(prd_start_dt AS DATE) AS prd_start_dt,

            -- Set end date to one day before the next product start date
            DATEADD(
                DAY,
                -1,
                CAST(
                    LEAD(prd_start_dt) OVER (
                        PARTITION BY prd_key
                        ORDER BY prd_start_dt
                    ) AS DATE
                )
            ) AS prd_end_dt
        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT ' >> Product load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        -- ============================================================
        -- Load CRM Sales Information
        -- ============================================================

        SET @start_time = GETDATE();
        PRINT ' > Truncating Table: silver.crm_sls_info';
        TRUNCATE TABLE silver.crm_sls_info;

        PRINT ' > Inserting Data Into: silver.crm_sls_info';

        INSERT INTO silver.crm_sls_info (
            sls_ord_num,
            sls_prd_key,
            sls_cst_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cst_id,

            -- Convert valid YYYYMMDD values to DATE
            TRY_CONVERT(DATE, CONVERT(CHAR(8), NULLIF(sls_order_dt, 0)), 112),
            TRY_CONVERT(DATE, CONVERT(CHAR(8), NULLIF(sls_ship_dt, 0)), 112),
            TRY_CONVERT(DATE, CONVERT(CHAR(8), NULLIF(sls_due_dt, 0)), 112),

            -- Recalculate invalid sales amounts
            CASE
                WHEN sls_sales IS NULL
                  OR sls_sales <= 0
                  OR sls_sales <> sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,

            sls_quantity,

            -- Calculate a missing or invalid unit price
            CASE
                WHEN sls_price IS NULL OR sls_price <= 0
                THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price
        FROM bronze.crm_sls_info;

        SET @end_time = GETDATE();
        PRINT ' >> Sales load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        -- ============================================================
        -- Load ERP Customer Information
        -- ============================================================

        SET @start_time = GETDATE();
        PRINT ' > Truncating Table: silver.erp_CUST_AZ12';
        TRUNCATE TABLE silver.erp_CUST_AZ12;

        PRINT ' > Inserting Data Into: silver.erp_CUST_AZ12';

        INSERT INTO silver.erp_CUST_AZ12 (
            cid,
            bdate,
            gen
        )
        SELECT
            -- Remove the NAS prefix from customer IDs
            CASE
                WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
                ELSE TRIM(cid)
            END AS cid,

            -- Future birth dates are invalid
            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,

            -- Standardize gender values
            CASE
                WHEN UPPER(TRIM(REPLACE(gen, CHAR(13), ''))) IN ('M', 'MALE')
                    THEN 'Male'
                WHEN UPPER(TRIM(REPLACE(gen, CHAR(13), ''))) IN ('F', 'FEMALE')
                    THEN 'Female'
                ELSE 'N/A'
            END AS gen
        FROM bronze.erp_CUST_AZ12;

        SET @end_time = GETDATE();
        PRINT ' >> ERP customer load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        -- ============================================================
        -- Load ERP Location Information
        -- ============================================================

        SET @start_time = GETDATE();
        PRINT ' > Truncating Table: silver.erp_LOC_A101';
        TRUNCATE TABLE silver.erp_LOC_A101;

        PRINT ' > Inserting Data Into: silver.erp_LOC_A101';

        ;WITH cleaned_location AS (
            SELECT
                -- Remove hyphens and surrounding spaces from customer IDs
                REPLACE(TRIM(cid), '-', '') AS cid,

                -- Remove line breaks and extra spaces from country names
                TRIM(
                    REPLACE(
                        REPLACE(cntry, CHAR(13), ''),
                        CHAR(10), ''
                    )
                ) AS country
            FROM bronze.erp_LOC_A101
        )
        INSERT INTO silver.erp_LOC_A101 (
            cid,
            cntry
        )
        SELECT
            cid,
            CASE
                WHEN country IS NULL OR country = '' THEN 'N/A'
                WHEN UPPER(country) IN ('US', 'USA') THEN 'United States'
                WHEN UPPER(country) = 'DE' THEN 'Germany'
                ELSE country
            END AS cntry
        FROM cleaned_location;

        SET @end_time = GETDATE();
        PRINT ' >> Location load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        -- ============================================================
        -- Load ERP Product Category Information
        -- ============================================================

        SET @start_time = GETDATE();
        PRINT ' > Truncating Table: silver.erp_PX_CAT_g1v2';
        TRUNCATE TABLE silver.erp_PX_CAT_g1v2;

        PRINT ' > Inserting Data Into: silver.erp_PX_CAT_g1v2';

        INSERT INTO silver.erp_PX_CAT_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_PX_CAT_g1v2;

        SET @end_time = GETDATE();
        PRINT ' >> Product category load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        COMMIT TRANSACTION;

        SET @batch_end_time = GETDATE();

        PRINT '=============================================';
        PRINT 'Loading Silver Layer completed successfully.';
        PRINT 'Total load duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
            + ' seconds';
        PRINT '=============================================';
    END TRY

    BEGIN CATCH
        -- Undo all changes if any table fails to load
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT '=============================================';
        PRINT 'ERROR occurred during Silver layer loading.';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=============================================';

        THROW;
    END CATCH
END;
GO

-- Run this separately after creating the procedure:
-- EXEC silver.load_silver;
