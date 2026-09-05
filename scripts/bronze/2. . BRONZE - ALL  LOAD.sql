EXEC bronze.load_bronze ;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME, @batch_end_time DATETIME ;
	BEGIN TRY
		SET @batch_start_time = GETDATE(); 
		PRINT'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
		PRINT'Loading Bronze Layer';
		PRINT'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';

		PRINT'=========================================';
		PRINT'Loading CRM Tables';
		PRINT'=========================================';

		SET @start_time = GETDATE() ;
		PRINT'>> Truncating Table: bronze.crm_cust_info ';
		TRUNCATE TABLE bronze.crm_cust_info ;  -- Truncating the Table first then Bulk Inserting the values
	
		PRINT'>> Inserting Data Into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info       -- Bulk Inserting Data from CSV files
		FROM 'C:\Users\baman\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,                      -- Inserting will start from 2nd row cuz 1st row was Header, hence Excluded
			FIELDTERMINATOR = ',',             -- Specifing the File Seperator or Delimiter 
			TABLOCK                            -- Locking at entire table while loading it
		);	
		SET @end_time = GETDATE() ;
		PRINT'>> Load Duration : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR ) + 'seconds';
		PRINT'------------------';

		-- Doing same process for rest of the tables below 
		SET @start_time = GETDATE() ;
		PRINT'>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info ;  

		PRINT'>> Loading Data into Table: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info      
		FROM 'C:\Users\baman\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE() ;
		PRINT'>> Load Duration : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR ) + 'seconds';
		PRINT'------------------';

		SET @start_time = GETDATE() ;
		PRINT'>> Truncating Table: bronze.crm_sales_details '
		TRUNCATE TABLE bronze.crm_sales_details ;  

		PRINT'>> Loading Data into Table: bronze.crm_sales_details '
		BULK INSERT bronze.crm_sales_details      
		FROM 'C:\Users\baman\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE() ;
		PRINT'>> Load Duration : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR ) + 'seconds';
		PRINT'------------------';

		PRINT'=========================================';
		PRINT'Loading ERP Tables';
		PRINT'=========================================';

		SET @start_time = GETDATE() ;
		PRINT'>> Truncating Table: bronze.erp_customer '
		TRUNCATE TABLE bronze.erp_customer ; 
	
		PRINT'>> Loading Data into Table: bronze.erp_customer '
		BULK INSERT bronze.erp_customer      
		FROM 'C:\Users\baman\Downloads\sql-data-warehouse-project\datasets\source_erp\CUST.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE() ;
		PRINT'>> Load Duration : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR ) + 'seconds';
		PRINT'------------------';

		PRINT'>> Truncating Table: bronze.erp_location  '
		TRUNCATE TABLE bronze.erp_location ; 
	
		PRINT'>> Loading Data into Table: bronze.erp_location  '
		BULK INSERT bronze.erp_location      
		FROM 'C:\Users\baman\Downloads\sql-data-warehouse-project\datasets\source_erp\LOC.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE() ;
		PRINT'>> Load Duration : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR ) + 'seconds';
		PRINT'------------------';

		SET @start_time = GETDATE() ;
		PRINT'>> Truncating Table: bronze.erp_px_cat   '
		TRUNCATE TABLE bronze.erp_px_cat ; 
	
		PRINT'>> Loading Data into Table: bronze.erp_px_cat   '
		BULK INSERT bronze.erp_px_cat     
		FROM 'C:\Users\baman\Downloads\sql-data-warehouse-project\datasets\source_erp\PX_CAT.csv'
		WITH(
			FIRSTROW = 2 ,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE() ;
		PRINT'>> Load Duration : ' + CAST(DATEDIFF(second,@start_time , @end_time) AS NVARCHAR ) + 'seconds';
		PRINT'------------------';

		SET @batch_end_time = GETDATE() ;
		PRINT'========================================='
		PRINT'~~ Loading of Bronze Layer is Completed'
		PRINT'~~ Total Load Duration : ' + CAST(DATEDIFF(second,@batch_start_time , @batch_end_time) AS NVARCHAR ) + 'seconds';
		PRINT'========================================='
	END TRY
	BEGIN CATCH
		PRINT'========================================='
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER : '
		PRINT'Error Message ' + ERROR_MESSAGE();
		PRINT'Error Number ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error Line ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT'Error Procedure ' + ERROR_PROCEDURE();
		PRINT'========================================='
	END CATCH
END
	