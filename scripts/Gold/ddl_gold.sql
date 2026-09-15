/*=================================================================================================
    GOLD LAYER - DIMENSION AND FACT VIEWS
    -------------------------------------------------------------------------------------------------
    Purpose:
        The Gold layer contains business-ready views that are used for reporting and analytics.

        In this layer:
        - Customer data is transformed into a customer dimension.
        - Product data is transformed into a product dimension.
        - Sales data is combined with customer and product dimensions to create the sales fact.

    Source:
        Silver Layer

    Target:
        Gold Layer
=================================================================================================*/


/*=================================================================================================
    1. CUSTOMER DIMENSION
    -------------------------------------------------------------------------------------------------
    This view creates the Customer Dimension by combining customer information from the CRM
    system with additional customer details from the ERP system.

    The view contains:
        - Customer identification details
        - Customer name
        - Country
        - Marital status
        - Standardized gender
        - Birth date
        - Customer creation date

    A surrogate key (S_no) is generated using ROW_NUMBER() to uniquely identify each customer
    record within the Gold layer.
=================================================================================================*/

CREATE VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.cst_id) AS S_no,

    -- Customer identification
    c.cst_id AS customer_id,
    c.CST_Key AS customer_key,

    -- Customer personal information
    c.CST_firstname AS first_name,
    c.cst_lastname AS last_name,

    -- Customer location
    l.CNTRY AS country,

    -- Customer demographic information
    c.cst_material_status AS marital_status,

    -- Standardize gender information coming from different source systems
    CASE
        WHEN c.CST_GNDR != 'n/a'
            THEN c.CST_gndr
        ELSE COALESCE(o.gen, 'n/a')
    END AS gender,

    o.BDATE AS birth_date,

    -- Customer record creation date
    c.cst_create_date AS create_date

FROM silver.crm_cst_info c

-- Get additional customer information from the ERP customer table
LEFT JOIN silver.erp_CUST_AZ12 o
    ON c.cst_key = o.CID

-- Get country/location information
LEFT JOIN silver.erp_LOC_A101 l
    ON o.cid = l.cid;


/*=================================================================================================
    2. PRODUCT DIMENSION
    -------------------------------------------------------------------------------------------------
    This view creates the Product Dimension by combining product information from the CRM system
    with product category information from the ERP system.

    The product dimension provides a single business-friendly view of products, including:
        - Product identification
        - Product name
        - Category and sub-category
        - Maintenance information
        - Product cost
        - Product line
        - Product validity dates

    A surrogate product key is generated using ROW_NUMBER().
=================================================================================================*/

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY p.prd_start_dt, p.prd_Key
    ) AS product_key,

    -- Product identification
    p.prd_id AS product_id,
    p.prd_Key AS product_number,

    -- Product information
    p.prd_nm AS product_name,
    p.cat_id AS category_id,

    -- Product category information
    c.CAT AS category,
    c.SUBCAT AS sub_category,
    c.MAINTENANCE AS maintenance,

    -- Product pricing and classification
    p.prd_cost AS product_cost,
    p.prd_line AS product_line,

    -- Product validity period
    p.prd_start_dt AS start_date,
    p.prd_end_dt AS end_date

FROM silver.crm_prd_info p

-- Add category and sub-category information from the ERP system
LEFT JOIN silver.erp_PX_CAT_g1v2 c
    ON p.cat_id = c.ID;


/*=================================================================================================
    3. SALES FACT
    -------------------------------------------------------------------------------------------------
    This view creates the central Sales Fact table for the Gold layer.

    It combines sales transactions with the Customer and Product dimensions.

    The fact view contains important measures and dates required for business reporting:
        - Order number
        - Customer
        - Product
        - Order date
        - Shipping date
        - Due date
        - Sales amount
        - Quantity
        - Price

    The Product Dimension is joined using the product number, while the Customer Dimension
    is joined using the customer ID.

    This structure follows a star-schema approach where the Sales Fact acts as the central
    transactional table and the Customer/Product dimensions provide descriptive information.
=================================================================================================*/

CREATE VIEW gold.fact_sales AS
SELECT

    -- Sales transaction identification
    sd.sls_ord_num AS order_number,

    -- Dimension keys
    pr.product_key,
    cs.customer_key,

    -- Source customer identifier
    sd.sls_cst_id AS customer_id,

    -- Important sales dates
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt AS due_date,

    -- Sales measures
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price

FROM silver.crm_sls_info sd

-- Connect sales transactions with the Product Dimension
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

-- Connect sales transactions with the Customer Dimension
LEFT JOIN gold.dim_customer cs
    ON sd.sls_cst_id = cs.customer_id;


/*=================================================================================================
    END OF GOLD LAYER DDL
    -------------------------------------------------------------------------------------------------
    The Gold layer is now ready to be used for reporting, dashboards, analytics, and
    downstream business intelligence requirements.
=================================================================================================*/
