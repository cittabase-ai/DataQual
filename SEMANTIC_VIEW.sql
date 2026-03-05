create or replace semantic view SALES.PUBLIC.VW_SALES_DEMO
	tables (
		SALES.PUBLIC.EMPLOYEE primary key (EMPLOYEE_ID),
		SALES.PUBLIC.SALES primary key (SALES_REP_ID) comment='This table stores sales data, including order information, customer and product details, sales performance metrics, and organizational hierarchy data, to track and analyze sales activities across different regions, departments, and sales channels.'
	)
	relationships (
		SALES_TO_EMPLOYEE as SALES(SALES_REP_ID) references EMPLOYEE(EMPLOYEE_ID)
	)
	facts (
		EMPLOYEE.AGE as AGE comment='Age should be between :min_age = 16 and :max_age = 80; flag >80 as critical.',
		EMPLOYEE.COMMISSION_RATE as COMMISSION_RATE comment='Commission rate must be between 0 and 0.5 (0–50%).',
		EMPLOYEE.EMPLOYEE_ID as EMPLOYEE_ID,
		EMPLOYEE.MANAGER_ID as MANAGER_ID comment='manager_id cannot equal employee_id.',
		EMPLOYEE.SALARY_BASE_AMT as SALARY_BASE_AMT comment=' Base salary must meet minimum threshold of 4000',
		SALES.DISCOUNT_AMT as DISCOUNT_AMT comment='The amount of discount applied to a sale, representing the reduction in the original price of a product or service.',
		SALES.QUANTITY as QUANTITY comment='The quantity of items sold in a transaction.

quantity must be ≥ 0.',
		SALES.SALES_ID as SALES_ID comment='Unique identifier for each sales transaction.',
		SALES.SALES_REP_ID as SALES_REP_ID comment='Unique identifier for the sales representative who made the sale.

SALES_REP_ID must be present for all sales rows.
SALES_REP_ID must exist in EMPLOYEE table as employee_id.
Rep must be employed/active on the order date.',
		SALES.TAX_AMT as TAX_AMT comment='The amount of tax paid on a sale.',
		SALES.TOTAL_AMOUNT as TOTAL_AMOUNT comment='The total amount of each sale, representing the overall value of the transaction.

TOTAL_AMOUNT must be present for all sales rows.

verify TOTAL_AMOUNT = quantity * unit_price - discount_amt + tax_amt. If not then, its an Data Quality error.',
		SALES.UNIT_PRICE as UNIT_PRICE comment='The price of a single unit of a product sold.

unit_price must be ≥ 0.'
	)
	dimensions (
		EMPLOYEE.BATCH_ID as BATCH_ID,
		EMPLOYEE.CATEGORY as CATEGORY,
		EMPLOYEE.DEPARTMENT_ID as DEPARTMENT_ID,
		EMPLOYEE.DEPARTMENT_NAME as DEPARTMENT_NAME,
		EMPLOYEE.EMPLOYEE_NK as EMPLOYEE_NK,
		EMPLOYEE.EMPLOYMENT_STATUS as EMPLOYMENT_STATUS comment='employment_status must be in (''Active'', ''Leave'', ''Terminated'').',
		EMPLOYEE.EMPLOYMENT_TYPE as EMPLOYMENT_TYPE comment='employment_type must be in (''Full-time'', ''Contract'').',
		EMPLOYEE.FIRST_NAME as FIRST_NAME,
		EMPLOYEE.IS_DELETED as IS_DELETED,
		EMPLOYEE.LAST_NAME as LAST_NAME,
		EMPLOYEE.LOCATION_CITY as LOCATION_CITY,
		EMPLOYEE.LOCATION_COUNTRY as LOCATION_COUNTRY,
		EMPLOYEE.LOCATION_STATE as LOCATION_STATE,
		EMPLOYEE.MARKET_AREA_CODE as MARKET_AREA_CODE,
		EMPLOYEE.MARKET_AREA_NAME as MARKET_AREA_NAME,
		EMPLOYEE.PHONE as PHONE,
		EMPLOYEE.RECORD_HASH as RECORD_HASH,
		EMPLOYEE.REGION_CODE as REGION_CODE,
		EMPLOYEE.REGION_NAME as REGION_NAME,
		EMPLOYEE.ROLE_TITLE as ROLE_TITLE,
		EMPLOYEE.SOURCE_SYSTEM as SOURCE_SYSTEM,
		EMPLOYEE.WORK_EMAIL as WORK_EMAIL comment='work_email must match standard email pattern.',
		EMPLOYEE.HIRE_DATE as HIRE_DATE comment='hire_date cannot be in the future.',
		EMPLOYEE.INGEST_TS as INGEST_TS,
		EMPLOYEE.TERMINATION_DATE as TERMINATION_DATE comment=' termination_date must be on/after hire_date if present.',
		SALES.BATCH_ID as BATCH_ID comment='Unique identifier for a batch of sales data loaded into the system, typically used for tracking and auditing purposes.',
		SALES.CURRENCY as CURRENCY comment='The currency in which the sale was made.',
		SALES.CUSTOMER_ID as CUSTOMER_ID comment='Unique identifier for the customer who made the purchase.',
		SALES.DEPARTMENT_ID as DEPARTMENT_ID comment='The department identifier for the sales team that made the sale.

department_id must be present.',
		SALES.DEPARTMENT_NAME as DEPARTMENT_NAME comment='The department within the organization where the sale was made.',
		SALES.IS_DELETED as IS_DELETED comment='Indicates whether a sales record has been deleted or is still active.',
		SALES.MARKET_AREA_CODE as MARKET_AREA_CODE comment='Geographic region where the sale was made, categorized by market area.',
		SALES.MARKET_AREA_NAME as MARKET_AREA_NAME comment='Geographic region where the sale was made, categorized by continent and sub-region.',
		SALES.ORDER_ID as ORDER_ID comment='Unique identifier for each sales order.',
		SALES.PRODUCT_ID as PRODUCT_ID comment='Unique identifier for the product being sold.',
		SALES.RECORD_HASH as RECORD_HASH comment='Unique identifier for each sales record, used for data integrity and tracking purposes.',
		SALES.REGION_CODE as REGION_CODE comment='Geographic region where the sale was made, categorized as either Latin America (LATAM), Asia-Pacific (APAC), or Not Available/Undefined (NA).

Sales region_code must match associated employee region_code.',
		SALES.REGION_NAME as REGION_NAME comment='The geographic region where the sale was made.',
		SALES.RETURN_FLAG as RETURN_FLAG comment='Indicates whether a sale was returned or not.',
		SALES.SALES_CHANNEL as SALES_CHANNEL comment='The sales channel through which the sale was made, indicating whether the sale was made directly to the customer, through a partner, or through an online platform.',
		SALES.SOURCE_SYSTEM as SOURCE_SYSTEM comment='The system from which the sales data originated,  Customer Relationship Management (CRM).

If there is any other source system other than CRM, its an Data Quality issue and needs to be addressed.',
		SALES.STATUS as STATUS comment='The current state of a sales opportunity, indicating whether it has been lost to a competitor, is still open and being pursued, or has been successfully closed and won.',
		SALES.CLOSE_DATE as CLOSE_DATE comment='Date on which the sale was closed.

CLOSE_DATE should not be earlier than order_date.',
		SALES.INGEST_TS as INGEST_TS comment='Timestamp when the sales data was ingested into the system.',
		SALES.ORDER_DATE as ORDER_DATE comment='Date on which the sales order was placed.

ORDER_DATE must be present for all sales rows.'
	)
	with extension (CA='{"tables":[{"name":"EMPLOYEE","dimensions":[{"name":"BATCH_ID"},{"name":"CATEGORY"},{"name":"DEPARTMENT_ID"},{"name":"DEPARTMENT_NAME"},{"name":"EMPLOYEE_NK"},{"name":"EMPLOYMENT_STATUS"},{"name":"EMPLOYMENT_TYPE"},{"name":"FIRST_NAME"},{"name":"IS_DELETED"},{"name":"LAST_NAME"},{"name":"LOCATION_CITY"},{"name":"LOCATION_COUNTRY"},{"name":"LOCATION_STATE"},{"name":"MARKET_AREA_CODE"},{"name":"MARKET_AREA_NAME"},{"name":"PHONE"},{"name":"RECORD_HASH"},{"name":"REGION_CODE"},{"name":"REGION_NAME"},{"name":"ROLE_TITLE"},{"name":"SOURCE_SYSTEM"},{"name":"WORK_EMAIL"}],"facts":[{"name":"AGE"},{"name":"COMMISSION_RATE"},{"name":"EMPLOYEE_ID"},{"name":"MANAGER_ID"},{"name":"SALARY_BASE_AMT"}],"time_dimensions":[{"name":"HIRE_DATE"},{"name":"INGEST_TS"},{"name":"TERMINATION_DATE"}]},{"name":"SALES","dimensions":[{"name":"BATCH_ID","sample_values":["CRMLOAD-5653","CRMLOAD-4550","CRMLOAD-8610"]},{"name":"CURRENCY","sample_values":["USD","INR","CAD"]},{"name":"CUSTOMER_ID","sample_values":["CUST-2317","CUST-9281","CUST-3388"]},{"name":"DEPARTMENT_ID","sample_values":["SLS"]},{"name":"DEPARTMENT_NAME","sample_values":["Sales"]},{"name":"IS_DELETED","sample_values":["False"]},{"name":"MARKET_AREA_CODE","sample_values":["US-WEST","LATAM-SOUTH","EU-WEST"]},{"name":"MARKET_AREA_NAME","sample_values":["United States - West","Europe - West","LATAM - South"]},{"name":"ORDER_ID","sample_values":["ORD-100054","ORD-100021","ORD-100011"]},{"name":"PRODUCT_ID","sample_values":["SKU-884","SKU-882","SKU-544"]},{"name":"RECORD_HASH","sample_values":["GikscJMyXHQfubj0","gNuQslqSS4zeYpSE","gdVFlFmJ44oKAgzZ"]},{"name":"REGION_CODE","sample_values":["NA","LATAM","APAC"]},{"name":"REGION_NAME","sample_values":["North America","Asia Pacific","Latin America"]},{"name":"RETURN_FLAG","sample_values":["FALSE","TRUE"]},{"name":"SALES_CHANNEL","sample_values":["Online","Partner","Direct"]},{"name":"SOURCE_SYSTEM","sample_values":["CRM"]},{"name":"STATUS","sample_values":["Lost","Open","Closed"]}],"facts":[{"name":"DISCOUNT_AMT","sample_values":["73.76","45.82","85.08"]},{"name":"QUANTITY","sample_values":["33.82","22.61","32.15"]},{"name":"SALES_ID","sample_values":["98","29","1"]},{"name":"SALES_REP_ID","sample_values":["219","290","95"]},{"name":"TAX_AMT","sample_values":["1438.09","2210.02","2062.54"]},{"name":"TOTAL_AMOUNT","sample_values":["15071.17","27350.13","598.58"]},{"name":"UNIT_PRICE","sample_values":["43.82","852.19","819.28"]}],"time_dimensions":[{"name":"CLOSE_DATE","sample_values":["2022-09-04","2024-08-29","2025-04-16"]},{"name":"INGEST_TS","sample_values":["2025-09-24T04:58:31.000+0000"]},{"name":"ORDER_DATE","sample_values":["2024-06-15","2022-09-16","2022-04-26"]}]}],"relationships":[{"name":"SALES_TO_EMPLOYEE"}],"verified_queries":[{"name":"Count employees with base salary less than 4000 or null, and total employee count","question":"Count employees with base salary less than 4000 or null, and total employee count","sql":"SELECT\\n  COUNT(\\n    CASE\\n      WHEN salary_base_amt < 4000\\n      OR salary_base_amt IS NULL THEN 1\\n    END\\n  ) AS employees_with_low_or_null_salary,\\n  COUNT(*) AS total_employee_count,\\n  COUNT(\\n    CASE\\n      WHEN salary_base_amt IS NULL THEN 1\\n    END\\n  ) AS employees_with_null_salary,\\n  AVG(salary_base_amt) AS avg_salary\\nFROM\\n  employee\\nWHERE\\n  hire_date <= CURRENT_DATE","use_as_onboarding_question":false,"verified_by":"ALFRED","verified_at":1765963922}]}');