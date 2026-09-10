/* 
============================================================= 
Bronze Layer- Data Warehouse
=============================================================
Purpose: Create the Bronze layer tables.
Description: The Bronze layer stores raw data as received from the \
source systems without applying business transformations. 
Source Systems: - CRM - ERP 
============================================================= */

IF OBJECT ID ('bronze.crm_cust_info','u') IS NOT NULL
  DROP TABLE bronze.crm._cust_info;

GO

  
CREATE TABLE bronze.crm_cst_info(
	cst_id INT,
	CST_Key NVARCHAR(50),
	CST_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	CST_gndr NVARCHAR(50),
	cst_create_date DATE
)



CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_Key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dT DATE
)


CREATE TABLE bronze.crm_sls_info(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cst_id INT,
	sls_order_dt INT,
	sls_ship_dt INT, 
	sls_due_dt INT,
    sls_sales INT,
	sls_quantity INT,
	sls_price INT
)


CREATE TABLE bronze.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50),
)



 
CREATE TABLE bronze.erp_LOC_A101(
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50),
)


CREATE TABLE bronze.erp_PX_CAT_g1v2(
	ID NVARCHAR (50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
)


