USE ContosoRetailDW;
GO

SET NOCOUNT ON;
GO

-- Чекор 1: Креирање на шеми 

	IF NOT EXISTS (
		SELECT 1
		FROM sys.schemas 
		WHERE name = 'star'
	)
	BEGIN
		EXEC('CREATE SCHEMA star');
	END;
	GO

	IF NOT EXISTS (
		SELECT 1
		FROM sys.schemas
		WHERE name = 'snowflake'
	)
	BEGIN 
		EXEC('CREATE SCHEMA snowflake');
	END;
	GO

-- Чекор 2: Отстранување на веќе постоечки табели

-- Star Schema
	DROP TABLE IF EXISTS star.FactSales;
	DROP TABLE IF EXISTS star.DimProduct;
	DROP TABLE IF EXISTS star.DimStore;
	DROP TABLE IF EXISTS star.DimDate;
	DROP TABLE IF EXISTS star.DimPromotion;
	DROP TABLE IF EXISTS star.DimChannel;

-- Snowflake Schema
	DROP TABLE IF EXISTS snowflake.FactSales;
	DROP TABLE IF EXISTS snowflake.DimProduct;
	DROP TABLE IF EXISTS snowflake.DimProductSubcategory;
	DROP TABLE IF EXISTS snowflake.DimProductCategory;
	DROP TABLE IF EXISTS snowflake.DimStore;
	DROP TABLE IF EXISTS snowflake.DimGeography;
	DROP TABLE IF EXISTS snowflake.DimPromotion;
	DROP TABLE IF EXISTS snowflake.DimChannel;

-- Чекор 3: Креирање на табелите

-- Star Schema
	CREATE TABLE star.DimProduct ( 
		ProductKey INT NOT NULL,
		ProductLabel NVARCHAR(255),
		ProductName NVARCHAR(500),
		ProductDescription NVARCHAR(400),

		ProductSubcategoryKey INT,
		ProductSubcategoryLabel NVARCHAR(100),
		ProductSubcategoryName NVARCHAR(50),
		ProductSubcategoryDescription NVARCHAR(100),

		ProductCategoryKey INT,
		ProductCategoryLabel NVARCHAR(100),
		ProductCategoryName NVARCHAR(30),
		ProductCategoryDescription NVARCHAR(50),

		Manufacturer NVARCHAR(50),
		BrandName NVARCHAR(50),
		ClassID NVARCHAR(10),
		ClassName NVARCHAR(20),
		StyleID NVARCHAR(10),
		StyleName NVARCHAR(20),
		ColorID NVARCHAR(10),
		ColorName NVARCHAR(20),
		Size NVARCHAR(50),
		SizeRange NVARCHAR(50),
		UnitOfMeasureName NVARCHAR(40),
		StockTypeName NVARCHAR(40),
		UnitCost MONEY,
		UnitPrice MONEY,
		AvailableForSaleDate DATETIME,
		StopSaleDate DATETIME,
		ProductStatus NVARCHAR(7),

		CONSTRAINT PK_star_DimProduct
			PRIMARY KEY(ProductKey)
	);
	GO

	
	CREATE TABLE star.DimStore (
		StoreKey INT NOT NULL,
		GeographyKey INT NOT NULL,

		StoreManager INT,
		StoreType NVARCHAR(15),
		StoreName NVARCHAR(100) NOT NULL,
		StoreDescription NVARCHAR(300) NOT NULL,
		StoreStatus NVARCHAR(20) NOT NULL,
		OpenDate DATETIME NOT NULL,
		CloseDate DATETIME,
		CloseReason NVARCHAR(20),
		EmployeeCount INT,
		SellingAreaSize FLOAT,
		LastRemodelDate DATETIME,

		GeographyType NVARCHAR(50),
		ContinentName NVARCHAR(50),
		CityName NVARCHAR(100),
		StateProvinceName NVARCHAR(100),
		RegionCountryName NVARCHAR(100)

		CONSTRAINT PK_star_DimStore
			PRIMARY KEY(StoreKey)
	);

	GO

	CREATE TABLE star.DimDate (
		DateKey DATETIME NOT NULL,
		FullDateLabel NVARCHAR(20) NOT NULL,
		DateDescription NVARCHAR(20) NOT NULL,

		CalendarYear INT NOT NULL,
		CalendarYearLabel NVARCHAR(20) NOT NULL,
		CalendarHalfYear INT NOT NULL,
		CalendarHalfYearLabel NVARCHAR(20) NOT NULL,
		CalendarQuarter INT NOT NULL,
		CalendarQuarterLabel NVARCHAR(20) NULL,
		CalendarMonth INT NOT NULL,
		CalendarMonthLabel NVARCHAR(20) NOT NULL,
		CalendarWeek INT NOT NULL,
		CalendarWeekLabel NVARCHAR(20) NOT NULL,
		CalendarDayOfWeek INT NOT NULL,
		CalendarDayOfWeekLabel NVARCHAR(10) NOT NULL,

		FiscalYear INT NOT NULL,
		FiscalYearLabel NVARCHAR(20) NOT NULL,
		FiscalHalfYear INT NOT NULL,
		FiscalHalfYearLabel NVARCHAR(20) NOT NULL,
		FiscalQuarter INT NOT NULL,
		FiscalQuarterLabel NVARCHAR(20) NOT NULL,
		FiscalMonth INT NOT NULL,
		FiscalMonthLabel NVARCHAR(20) NOT NULL,

		IsWorkDay NVARCHAR(20) NOT NULL,
		IsHoliday INT NOT NULL,
		HolidayName NVARCHAR(20) NOT NULL,
		EuropeSeason NVARCHAR(50),
		NorthAmericaSeason NVARCHAR(50),
		AsiaSeason NVARCHAR(50)

		CONSTRAINT PK_star_DimDate
			PRIMARY KEY (DateKey)
	);
	GO

	CREATE TABLE star.DimPromotion (
		PromotionKey INT NOT NULL,
		PromotionLabel NVARCHAR(100),
		PromotionName NVARCHAR(100),
		PromotionDescription NVARCHAR(255),
		DiscountPercent FLOAT,
		PromotionType NVARCHAR(50),
		PromotionCategory NVARCHAR(50),
		StartDate DATETIME NOT NULL,
		EndDate DATETIME,
		MinQuantity INT,
		MaxQuantity INT

		CONSTRAINT PK_star_DimPromotion
			PRIMARY KEY (PromotionKey)
	);
	GO

	CREATE TABLE star.DimChannel (
		ChannelKey INT NOT NULL,
		ChannelLabel NVARCHAR(100) NOT NULL,
		ChannelName NVARCHAR(20) NULL,
		ChannelDescription NVARCHAR(50) NULL,

		CONSTRAINT PK_star_DimChannel
			PRIMARY KEY (ChannelKey)
	);
	GO	

	CREATE TABLE star.FactSales (
		SalesKey INT NOT NULL,
		DateKey DATETIME NOT NULL,
		Channelkey INT NOT NULL,
		StoreKey INT NOT NULL,
		ProductKey INT NOT NULL,
		PromotionKey INT NOT NULL,

		SalesQuantity INT NOT NULL,
		ReturnQuantity INT NOT NULL,
		ReturnAmount MONEY,
		DiscountQuantity INT,
		DiscountAmount MONEY,
		TotalCost MONEY NOT NULL,
		SalesAmount MONEY NOT NULL,

		CONSTRAINT PK_star_FactSales
			PRIMARY KEY (SalesKey),

		CONSTRAINT FK_star_FactSales_DimDate
			FOREIGN KEY (DateKey)
			REFERENCES star.DimDate(DateKey),

		CONSTRAINT FK_star_FactSales_DimChannel
			FOREIGN KEY (ChannelKey)
			REFERENCES star.DimChannel(ChannelKey),

		CONSTRAINT FK_star_FactSales_DimStore
			FOREIGN KEY (StoreKey)
			REFERENCES star.DimStore(StoreKey),

		CONSTRAINT FK_star_FactSales_DimProduct
			FOREIGN KEY (ProductKey)
			REFERENCES star.DimProduct(ProductKey),

		CONSTRAINT FK_star_DimPromotion
			FOREIGN KEY (PromotionKey)
			REFERENCES star.DimPromotion(PromotionKey)
	);


-- Snowflake Schema
	CREATE TABLE snowflake.DimProductCategory ( 
		ProductCategoryKey INT NOT NULL,
		ProductCategoryLabel NVARCHAR(100),
		ProductCategoryName NVARCHAR(30) NOT NULL,
		ProductCategoryDescription NVARCHAR(50) NOT NULL,

		CONSTRAINT PK_snowflake_DimProductCategory
			PRIMARY KEY(ProductCategoryKey)
	);
	GO

	CREATE TABLE snowflake.DimProductSubcategory ( 
	
		ProductSubcategoryKey INT NOT NULL,
		ProductSubcategoryLabel NVARCHAR(100),
		ProductSubcategoryName NVARCHAR(50) NOT NULL,
		ProductSubcategoryDescription NVARCHAR(100),
		ProductCategoryKey INT NULL,

		CONSTRAINT PK_snowflake_DimProductSubcategory
			PRIMARY KEY(ProductSubCategoryKey),

		CONSTRAINT FK_snowflake_DimProductSubcategory_DimProductCategory
			FOREIGN KEY (ProductCategoryKey)
			REFERENCES snowflake.DimProductCategory(ProductCategoryKey)
	);

	CREATE TABLE snowflake.DimProduct ( 
		ProductKey INT NOT NULL,
		ProductLabel NVARCHAR(255),
		ProductName NVARCHAR(500),
		ProductDescription NVARCHAR(400),
		ProductSubcategoryKey INT,

		Manufacturer NVARCHAR(50),
		BrandName NVARCHAR(50),
		ClassID NVARCHAR(10),
		ClassName NVARCHAR(20),
		StyleID NVARCHAR(10),
		StyleName NVARCHAR(20),
		ColorID NVARCHAR(10),
		ColorName NVARCHAR(20),
		Size NVARCHAR(50),
		SizeRange NVARCHAR(50),
		UnitOfMeasureName NVARCHAR(40),
		StockTypeName NVARCHAR(40),
		UnitCost MONEY,
		UnitPrice MONEY,
		AvailableForSaleDate DATETIME,
		StopSaleDate DATETIME,
		ProductStatus NVARCHAR(7),

		CONSTRAINT PK_snowflake_DimProduct
			PRIMARY KEY(ProductKey),

		CONSTRAINT FK_snowflake_DimProduct_DimProductSubcategory
			FOREIGN KEY (ProductSubcategoryKey)
			REFERENCES snowflake.DimProductSubcategory(ProductSubcategoryKey)
	);
	GO

	CREATE TABLE snowflake.DimGeography (
		GeographyKey INT NOT NULL,
		GeographyType NVARCHAR(50) NOT NULL,
		ContinentName NVARCHAR(50) NOT NULL,
		CityName NVARCHAR(100),
		StateProvinceName NVARCHAR(100),
		RegionCountryName NVARCHAR(100)

		CONSTRAINT PK_snowflake_DimGeography
			PRIMARY KEY (GeographyKey)

	);
	GO

	CREATE TABLE snowflake.DimStore (
		StoreKey INT NOT NULL,
		GeographyKey INT NOT NULL,

		StoreManager INT,
		StoreType NVARCHAR(15),
		StoreName NVARCHAR(100) NOT NULL,
		StoreDescription NVARCHAR(300) NOT NULL,
		StoreStatus NVARCHAR(20) NOT NULL,
		OpenDate DATETIME NOT NULL,
		CloseDate DATETIME,
		CloseReason NVARCHAR(20),
		EmployeeCount INT,
		SellingAreaSize FLOAT,
		LastRemodelDate DATETIME,

		CONSTRAINT PK_snowflake_DimStore
			PRIMARY KEY (StoreKey),

		CONSTRAINT FK_snowflake_DimStore_DimGeography
			FOREIGN KEY (GeographyKey)
			REFERENCES snowflake.DimGeography(GeographyKey)
	);

	CREATE TABLE snowflake.DimDate (
		DateKey DATETIME NOT NULL,
		FullDateLabel NVARCHAR(20) NOT NULL,
		DateDescription NVARCHAR(20) NOT NULL,

		CalendarYear INT NOT NULL,
		CalendarYearLabel NVARCHAR(20) NOT NULL,
		CalendarHalfYear INT NOT NULL,
		CalendarHalfYearLabel NVARCHAR(20) NOT NULL,
		CalendarQuarter INT NOT NULL,
		CalendarQuarterLabel NVARCHAR(20) NULL,
		CalendarMonth INT NOT NULL,
		CalendarMonthLabel NVARCHAR(20) NOT NULL,
		CalendarWeek INT NOT NULL,
		CalendarWeekLabel NVARCHAR(20) NOT NULL,
		CalendarDayOfWeek INT NOT NULL,
		CalendarDayOfWeekLabel NVARCHAR(10) NOT NULL,

		FiscalYear INT NOT NULL,
		FiscalYearLabel NVARCHAR(20) NOT NULL,
		FiscalHalfYear INT NOT NULL,
		FiscalHalfYearLabel NVARCHAR(20) NOT NULL,
		FiscalQuarter INT NOT NULL,
		FiscalQuarterLabel NVARCHAR(20) NOT NULL,
		FiscalMonth INT NOT NULL,
		FiscalMonthLabel NVARCHAR(20) NOT NULL,

		IsWorkDay NVARCHAR(20) NOT NULL,
		IsHoliday INT NOT NULL,
		HolidayName NVARCHAR(20) NOT NULL,
		EuropeSeason NVARCHAR(50),
		NorthAmericaSeason NVARCHAR(50),
		AsiaSeason NVARCHAR(50)

		CONSTRAINT PK_snowflake_DimDate
			PRIMARY KEY (DateKey)
	);
	GO

	CREATE TABLE snowflake.DimPromotion (
		PromotionKey INT NOT NULL,
		PromotionLabel NVARCHAR(100),
		PromotionName NVARCHAR(100),
		PromotionDescription NVARCHAR(255),
		DiscountPercent FLOAT,
		PromotionType NVARCHAR(50),
		PromotionCategory NVARCHAR(50),
		StartDate DATETIME NOT NULL,
		EndDate DATETIME,
		MinQuantity INT,
		MaxQuantity INT

		CONSTRAINT PK_snowflake_DimPromotion
			PRIMARY KEY (PromotionKey)
	);
	GO

	CREATE TABLE snowflake.DimChannel (
		ChannelKey INT NOT NULL,
		ChannelLabel NVARCHAR(100) NOT NULL,
		ChannelName NVARCHAR(20) NULL,
		ChannelDescription NVARCHAR(50) NULL,

		CONSTRAINT PK_snowflake_DimChannel
			PRIMARY KEY (ChannelKey)
	);
	GO	

	CREATE TABLE snowflake.FactSales (
		SalesKey INT NOT NULL,
		DateKey DATETIME NOT NULL,
		ChannelKey INT NOT NULL,
		StoreKey INT NOT NULL,
		ProductKey INT NOT NULL,
		PromotionKey INT NOT NULL,

		SalesQuantity INT NOT NULL,
		ReturnQuantity INT NOT NULL,
		ReturnAmount MONEY,
		DiscountQuantity INT,
		DiscountAmount MONEY,
		TotalCost MONEY,
		SalesAmount MONEY,

		CONSTRAINT PK_snowflake_FactSales
			PRIMARY KEY (SalesKey),

		CONSTRAINT FK_snowflake_FactSales_DimDate
			FOREIGN KEY (DateKey)
			REFERENCES snowflake.DimDate(DateKey),

		CONSTRAINT FK_snowflake_FactSales_DimChannel
			FOREIGN KEY (ChannelKey)
			REFERENCES snowflake.DimChannel(ChannelKey),

		CONSTRAINT FK_snowflake_FactSales_DimStore
			FOREIGN KEY (StoreKey)
			REFERENCES snowflake.DimStore(StoreKey),

		CONSTRAINT FK_snowflake_FactSales_DimProduct
			FOREIGN KEY (ProductKey)
			REFERENCES snowflake.DimProduct(ProductKey),

		CONSTRAINT FK_snowflake_DimPromotion
			FOREIGN KEY (PromotionKey)
			REFERENCES snowflake.DimPromotion(PromotionKey)
	);


-- Чекор 4: Валидација

	SELECT 
		s.name as SchemaName,
		t.name as TableName
	FROM sys.tables t
	JOIN sys.schemas s
		ON t.schema_id = s.schema_id
	WHERE s.name IN ('star', 'snowflake')
	ORDER BY s.name, t.name;
	