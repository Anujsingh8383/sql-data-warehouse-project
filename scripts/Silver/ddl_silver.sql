/*
-- ============================================================
-- Create Silver Layer Tables
-- Warning: This script drops and recreates all Silver tables.
-- ============================================================

-- Create the Silver schema if it does not already exist
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC ('CREATE SCHEMA silver');
GO
*/
-- ============================================================
-- Customer Information
-- ============================================================

IF OBJECT_ID('silver.crm_cst_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cst_info;
GO

CREATE TABLE silver.crm_cst_info (
    cst_id                  INT,
    cst_key                 NVARCHAR(50),
    cst_firstname           NVARCHAR(50),
    cst_lastname            NVARCHAR(50),
    cst_material_status     NVARCHAR(50),
    cst_gndr                NVARCHAR(50),
    cst_create_date         DATE,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================
-- Product Information
-- ============================================================

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id                  INT,
    cat_id                  NVARCHAR(50),
    prd_key                 NVARCHAR(50),
    prd_nm                  NVARCHAR(50),
    prd_cost                INT,
    prd_line                NVARCHAR(50),
    prd_start_dt            DATE,
    prd_end_dt              DATE,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================
-- Sales Information
-- ============================================================

IF OBJECT_ID('silver.crm_sls_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_sls_info;
GO

CREATE TABLE silver.crm_sls_info (
    sls_ord_num             NVARCHAR(50),
    sls_prd_key             NVARCHAR(50),
    sls_cst_id              INT,
    sls_order_dt            DATE,
    sls_ship_dt             DATE,
    sls_due_dt              DATE,
    sls_sales               INT,
    sls_quantity            INT,
    sls_price               INT,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================
-- ERP Customer Data
-- ============================================================

IF OBJECT_ID('silver.erp_CUST_AZ12', 'U') IS NOT NULL
    DROP TABLE silver.erp_CUST_AZ12;
GO

CREATE TABLE silver.erp_CUST_AZ12 (
    cid                     NVARCHAR(50),
    bdate                   DATE,
    gen                     NVARCHAR(50),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================
-- ERP Location Data
-- ============================================================

IF OBJECT_ID('silver.erp_LOC_A101', 'U') IS NOT NULL
    DROP TABLE silver.erp_LOC_A101;
GO

CREATE TABLE silver.erp_LOC_A101 (
    cid                     NVARCHAR(50),
    cntry                   NVARCHAR(50),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================
-- ERP Product Category Data
-- ============================================================

IF OBJECT_ID('silver.erp_PX_CAT_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_PX_CAT_g1v2;
GO

CREATE TABLE silver.erp_PX_CAT_g1v2 (
    id                      NVARCHAR(50),
    cat                     NVARCHAR(50),
    subcat                  NVARCHAR(50),
    maintenance             NVARCHAR(50),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO
