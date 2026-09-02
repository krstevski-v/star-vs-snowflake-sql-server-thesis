USE ContosoRetailDW;
GO

SET NOCOUNT ON;
GO

-- Чекор 1: Бришење на постоечки податоци

PRINT 'Clearing existing data...';

-- Star Schema
	DELETE FROM star.FactSales;
	DELETE FROM star.DimProduct;
	DELETE FROM star.DimStore;
	DELETE FROM star.DimDate;
	DELETE FROM star.DimPromotion;
	DELETE FROM star.DimChannel;

-- Snowflake Schema
	DELETE FROM snowflake.FactSales;
	DELETE FROM snowflake.DimStore;
	DELETE FROM snowflake.DimGeography;
	DELETE FROM snowflake.DimProduct;
	DELETE FROM snowflake.DimProductSubcategory;
	DELETE FROM snowflake.DimProductCategory;
	DELETE FROM snowflake.DimDate;
	DELETE FROM snowflake.DimPromotion;
	DELETE FROM snowflake.DimChannel;

PRINT 'Existing data cleared.';
GO

-- Чекор 2: Полнење на димензиите во star schema

PRINT 'Loading star.DimDate...';

	INSERT INTO star.DimDate (
		DateKey,
		FullDateLabel,
		DateDescription,
		CalendarYear,
		CalendarYearLabel,
		CalendarHalfYear,
		CalendarHalfYearLabel,
		CalendarQuarter,
		CalendarQuarterLabel,
		CalendarMonth,
		CalendarMonthLabel,
		CalendarWeek,
		CalendarWeekLabel,
		CalendarDayOfWeek,
		CalendarDayOfWeekLabel,
		FiscalYear,
		FiscalYearLabel,
		FiscalHalfYear,
		FiscalHalfYearLabel,
		FiscalQuarter,
		FiscalQuarterLabel,
		FiscalMonth,
		FiscalMonthLabel,
		IsWorkDay,
		IsHoliday,
		HolidayName,
		EuropeSeason,
		NorthAmericaSeason,
		AsiaSeason
	)
	SELECT
		d.Datekey,
		d.FullDateLabel,
		d.DateDescription,
		d.CalendarYear,
		d.CalendarYearLabel,
		d.CalendarHalfYear,
		d.CalendarHalfYearLabel,
		d.CalendarQuarter,
		d.CalendarQuarterLabel,
		d.CalendarMonth,
		d.CalendarMonthLabel,
		d.CalendarWeek,
		d.CalendarWeekLabel,
		d.CalendarDayOfWeek,
		d.CalendarDayOfWeekLabel,
		d.FiscalYear,
		d.FiscalYearLabel,
		d.FiscalHalfYear,
		d.FiscalHalfYearLabel,
		d.FiscalQuarter,
		d.FiscalQuarterLabel,
		d.FiscalMonth,
		d.FiscalMonthLabel,
		d.IsWorkDay,
		d.IsHoliday,
		d.HolidayName,
		d.EuropeSeason,
		d.NorthAmericaSeason,
		d.AsiaSeason
	FROM dbo.DimDate d;
	GO


	PRINT 'Loading star.DimChannel...';

	INSERT INTO star.DimChannel (
		ChannelKey,
		ChannelLabel,
		ChannelName,
		ChannelDescription
	)
	SELECT
		c.ChannelKey,
		c.ChannelLabel,
		c.ChannelName,
		c.ChannelDescription
	FROM dbo.DimChannel c;
	GO


	PRINT 'Loading star.DimPromotion...';

	INSERT INTO star.DimPromotion (
		PromotionKey,
		PromotionLabel,
		PromotionName,
		PromotionDescription,
		DiscountPercent,
		PromotionType,
		PromotionCategory,
		StartDate,
		EndDate,
		MinQuantity,
		MaxQuantity
	)
	SELECT
		p.PromotionKey,
		p.PromotionLabel,
		p.PromotionName,
		p.PromotionDescription,
		p.DiscountPercent,
		p.PromotionType,
		p.PromotionCategory,
		p.StartDate,
		p.EndDate,
		p.MinQuantity,
		p.MaxQuantity
	FROM dbo.DimPromotion p;
	GO


	PRINT 'Loading star.DimProduct...';

	INSERT INTO star.DimProduct (
		ProductKey,
		ProductLabel,
		ProductName,
		ProductDescription,

		ProductSubcategoryKey,
		ProductSubcategoryLabel,
		ProductSubcategoryName,
		ProductSubcategoryDescription,

		ProductCategoryKey,
		ProductCategoryLabel,
		ProductCategoryName,
		ProductCategoryDescription,

		Manufacturer,
		BrandName,
		ClassID,
		ClassName,
		StyleID,
		StyleName,
		ColorID,
		ColorName,
		Size,
		SizeRange,
		UnitOfMeasureName,
		StockTypeName,
		UnitCost,
		UnitPrice,
		AvailableForSaleDate,
		StopSaleDate,
		ProductStatus
	)
	SELECT
		p.ProductKey,
		p.ProductLabel,
		p.ProductName,
		p.ProductDescription,

		p.ProductSubcategoryKey,
		ps.ProductSubcategoryLabel,
		ps.ProductSubcategoryName,
		ps.ProductSubcategoryDescription,

		pc.ProductCategoryKey,
		pc.ProductCategoryLabel,
		pc.ProductCategoryName,
		pc.ProductCategoryDescription,

		p.Manufacturer,
		p.BrandName,
		p.ClassID,
		p.ClassName,
		p.StyleID,
		p.StyleName,
		p.ColorID,
		p.ColorName,
		p.[Size],
		p.SizeRange,
		p.UnitOfMeasureName,
		p.StockTypeName,
		p.UnitCost,
		p.UnitPrice,
		p.AvailableForSaleDate,
		p.StopSaleDate,
		p.Status AS ProductStatus
	FROM dbo.DimProduct p
	LEFT JOIN dbo.DimProductSubcategory ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	LEFT JOIN dbo.DimProductCategory pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey;
	GO


	PRINT 'Loading star.DimStore...';

	INSERT INTO star.DimStore (
		StoreKey,
		GeographyKey,

		StoreManager,
		StoreType,
		StoreName,
		StoreDescription,
		StoreStatus,
		OpenDate,
		CloseDate,
		CloseReason,
		EmployeeCount,
		SellingAreaSize,
		LastRemodelDate,

		GeographyType,
		ContinentName,
		CityName,
		StateProvinceName,
		RegionCountryName
	)
	SELECT
		s.StoreKey,
		s.GeographyKey,

		s.StoreManager,
		s.StoreType,
		s.StoreName,
		s.StoreDescription,
		s.Status AS StoreStatus,
		s.OpenDate,
		s.CloseDate,
		s.CloseReason,
		s.EmployeeCount,
		s.SellingAreaSize,
		s.LastRemodelDate,

		g.GeographyType,
		g.ContinentName,
		g.CityName,
		g.StateProvinceName,
		g.RegionCountryName

		
	FROM dbo.DimStore s
	LEFT JOIN dbo.DimGeography g
		ON s.GeographyKey = g.GeographyKey;
	GO


	/* ============================================================
	   3. Полнење на факт табелата на star schema
	   ============================================================ */

	PRINT 'Loading star.FactSales...';

	INSERT INTO star.FactSales (
		SalesKey,
		DateKey,
		ChannelKey,
		StoreKey,
		ProductKey,
		PromotionKey,

		SalesQuantity,
		ReturnQuantity,
		ReturnAmount,
		DiscountQuantity,
		DiscountAmount,
		TotalCost,
		SalesAmount
	)
	SELECT
		f.SalesKey,
		f.DateKey,
		f.channelKey,
		f.StoreKey,
		f.ProductKey,
		f.PromotionKey,

		f.SalesQuantity,
		f.ReturnQuantity,
		f.ReturnAmount,
		f.DiscountQuantity,
		f.DiscountAmount,
		f.TotalCost,
		f.SalesAmount
	FROM dbo.FactSales f;
	GO	


-- Чекор 4: Полнење на димензиите на snowflake schema

	PRINT 'Loading snowflake.DimDate...';

	INSERT INTO snowflake.DimDate (
		DateKey,
		FullDateLabel,
		DateDescription,
		CalendarYear,
		CalendarYearLabel,
		CalendarHalfYear,
		CalendarHalfYearLabel,
		CalendarQuarter,
		CalendarQuarterLabel,
		CalendarMonth,
		CalendarMonthLabel,
		CalendarWeek,
		CalendarWeekLabel,
		CalendarDayOfWeek,
		CalendarDayOfWeekLabel,
		FiscalYear,
		FiscalYearLabel,
		FiscalHalfYear,
		FiscalHalfYearLabel,
		FiscalQuarter,
		FiscalQuarterLabel,
		FiscalMonth,
		FiscalMonthLabel,
		IsWorkDay,
		IsHoliday,
		HolidayName,
		EuropeSeason,
		NorthAmericaSeason,
		AsiaSeason
	)
	SELECT
		d.Datekey,
		d.FullDateLabel,
		d.DateDescription,
		d.CalendarYear,
		d.CalendarYearLabel,
		d.CalendarHalfYear,
		d.CalendarHalfYearLabel,
		d.CalendarQuarter,
		d.CalendarQuarterLabel,
		d.CalendarMonth,
		d.CalendarMonthLabel,
		d.CalendarWeek,
		d.CalendarWeekLabel,
		d.CalendarDayOfWeek,
		d.CalendarDayOfWeekLabel,
		d.FiscalYear,
		d.FiscalYearLabel,
		d.FiscalHalfYear,
		d.FiscalHalfYearLabel,
		d.FiscalQuarter,
		d.FiscalQuarterLabel,
		d.FiscalMonth,
		d.FiscalMonthLabel,
		d.IsWorkDay,
		d.IsHoliday,
		d.HolidayName,
		d.EuropeSeason,
		d.NorthAmericaSeason,
		d.AsiaSeason
	FROM dbo.DimDate d;
	GO


	PRINT 'Loading snowflake.DimChannel...';

	INSERT INTO snowflake.DimChannel (
		ChannelKey,
		ChannelLabel,
		ChannelName,
		ChannelDescription
	)
	SELECT
		c.ChannelKey,
		c.ChannelLabel,
		c.ChannelName,
		c.ChannelDescription
	FROM dbo.DimChannel c;
	GO


	PRINT 'Loading nowflake.DimPromotion...';

	INSERT INTO snowflake.DimPromotion (
		PromotionKey,
		PromotionLabel,
		PromotionName,
		PromotionDescription,
		DiscountPercent,
		PromotionType,
		PromotionCategory,
		StartDate,
		EndDate,
		MinQuantity,
		MaxQuantity
	)
	SELECT
		p.PromotionKey,
		p.PromotionLabel,
		p.PromotionName,
		p.PromotionDescription,
		p.DiscountPercent,
		p.PromotionType,
		p.PromotionCategory,
		p.StartDate,
		p.EndDate,
		p.MinQuantity,
		p.MaxQuantity
	FROM dbo.DimPromotion p;
	GO


	PRINT 'Loading snowflake.DimProductCategory...';

	INSERT INTO snowflake.DimProductCategory (
		ProductCategoryKey,
		ProductCategoryLabel,
		ProductCategoryName,
		ProductCategoryDescription
	)
	SELECT
		pc.ProductCategoryKey,
		pc.ProductCategoryLabel,
		pc.ProductCategoryName,
		pc.ProductCategoryDescription
	FROM dbo.DimProductCategory pc;
	GO


	PRINT 'Loading snowflake.DimProductSubcategory...';

	INSERT INTO snowflake.DimProductSubcategory (
		ProductSubcategoryKey,
		ProductSubcategoryLabel,
		ProductSubcategoryName,
		ProductSubcategoryDescription,
		ProductCategoryKey
	)
	SELECT
		ps.ProductSubcategoryKey,
		ps.ProductSubcategoryLabel,
		ps.ProductSubcategoryName,
		ps.ProductSubcategoryDescription,
		ps.ProductCategoryKey
	FROM dbo.DimProductSubcategory ps;
	GO


	PRINT 'Loading snowflake.DimProduct...';

	INSERT INTO snowflake.DimProduct (
		ProductKey,
		ProductLabel,
		ProductName,
		ProductDescription,
		ProductSubcategoryKey,

		Manufacturer,
		BrandName,
		ClassID,
		ClassName,
		StyleID,
		StyleName,
		ColorID,
		ColorName,
		Size,
		SizeRange,
		UnitOfMeasureName,
		StockTypeName,
		UnitCost,
		UnitPrice,
		AvailableForSaleDate,
		StopSaleDate,
		ProductStatus
	)
	SELECT
		p.ProductKey,
		p.ProductLabel,
		p.ProductName,
		p.ProductDescription,
		p.ProductSubcategoryKey,

		p.Manufacturer,
		p.BrandName,
		p.ClassID,
		p.ClassName,
		p.StyleID,
		p.StyleName,
		p.ColorID,
		p.ColorName,
		p.[Size],
		p.SizeRange,
		p.UnitOfMeasureName,
		p.StockTypeName,
		p.UnitCost,
		p.UnitPrice,
		p.AvailableForSaleDate,
		p.StopSaleDate,
		p.Status AS ProductStatus
	FROM dbo.DimProduct p;
	GO


	PRINT 'Loading snowflake.DimGeography...';

	INSERT INTO snowflake.DimGeography (
		GeographyKey,
		GeographyType,
		ContinentName,
		CityName,
		StateProvinceName,
		RegionCountryName
	)
	SELECT
		g.GeographyKey,
		g.GeographyType,
		g.ContinentName,
		g.CityName,
		g.StateProvinceName,
		g.RegionCountryName
	FROM dbo.DimGeography g;
	GO

	PRINT 'Loading snowflake.DimStore...';

	INSERT INTO snowflake.DimStore (
		StoreKey,
		GeographyKey,

		StoreManager,
		StoreType,
		StoreName,
		StoreDescription,
		StoreStatus,
		OpenDate,
		CloseDate,
		CloseReason,
		EmployeeCount,
		SellingAreaSize,
		LastRemodelDate
	)
	SELECT
		s.StoreKey,
		s.GeographyKey,

		s.StoreManager,
		s.StoreType,
		s.StoreName,
		s.StoreDescription,
		s.Status AS StoreStatus,
		s.OpenDate,
		s.CloseDate,
		s.CloseReason,
		s.EmployeeCount,
		s.SellingAreaSize,
		s.LastRemodelDate
	FROM dbo.DimStore s;
	GO


	/* ============================================================
	   5. Полнење на факт табелата на snowflake schema
	   ============================================================ */

	PRINT 'Loading snowflake.FactSales...';

	INSERT INTO snowflake.FactSales (
		SalesKey,
		DateKey,
		ChannelKey,
		StoreKey,
		ProductKey,
		PromotionKey,

		SalesQuantity,
		ReturnQuantity,
		ReturnAmount,
		DiscountQuantity,
		DiscountAmount,
		TotalCost,
		SalesAmount
	)
	SELECT
		f.SalesKey,
		f.DateKey,
		f.channelKey,
		f.StoreKey,
		f.ProductKey,
		f.PromotionKey,

		f.SalesQuantity,
		f.ReturnQuantity,
		f.ReturnAmount,
		f.DiscountQuantity,
		f.DiscountAmount,
		f.TotalCost,
		f.SalesAmount
	FROM dbo.FactSales f;
	GO

-- Чекор 6: Валидација на број на реидиц

PRINT 'Validating loaded row counts...';

	SELECT 
		'Source' AS ModelName,
		'FactSales' AS TableName,
		COUNT(*) AS NumRows
	FROM dbo.FactSales

	UNION ALL

	SELECT 'Star', 'FactSales', COUNT(*)
	FROM star.FactSales

	UNION ALL

	SELECT 'Snowflake', 'FactSales', COUNT(*)
	FROM snowflake.FactSales

	UNION ALL

	SELECT 'Source', 'DimProduct', COUNT(*)
	FROM dbo.DimProduct

	UNION ALL

	SELECT 'Star', 'DimProduct', COUNT(*)
	FROM star.DimProduct

	UNION ALL

	SELECT 'Snowflake', 'DimProduct', COUNT(*)
	FROM snowflake.DimProduct

	UNION ALL

	SELECT 'Source', 'DimStore', COUNT(*)
	FROM dbo.DimStore

	UNION ALL

	SELECT 'Star', 'DimStore', COUNT(*)
	FROM star.DimStore

	UNION ALL

	SELECT 'Snowflake', 'DimStore', COUNT(*)
	FROM snowflake.DimStore

	UNION ALL

	SELECT 'Source', 'DimDate', COUNT(*)
	FROM dbo.DimDate

	UNION ALL

	SELECT 'Star', 'DimDate', COUNT(*)
	FROM star.DimDate

	UNION ALL

	SELECT 'Snowflake', 'DimDate', COUNT(*)
	FROM snowflake.DimDate

	UNION ALL

	SELECT 'Source', 'DimPromotion', COUNT(*)
	FROM dbo.DimPromotion

	UNION ALL

	SELECT 'Star', 'DimPromotion', COUNT(*)
	FROM star.DimPromotion

	UNION ALL

	SELECT 'Snowflake', 'DimPromotion', COUNT(*)
	FROM snowflake.DimPromotion

	UNION ALL

	SELECT 'Source', 'DimChannel', COUNT(*)
	FROM dbo.DimChannel

	UNION ALL

	SELECT 'Star', 'DimChannel', COUNT(*)
	FROM star.DimChannel

	UNION ALL

	SELECT 'Snowflake', 'DimChannel', COUNT(*)
	FROM snowflake.DimChannel

	ORDER BY TableName, ModelName;
	GO


-- Чекор 7: Валидација на табели за snowflake schema


PRINT 'Validating snowflake-specific table row counts...';

	SELECT 
		'Source' AS ModelName,
		'DimProductCategory' AS TableName,
		COUNT(*) AS RowCountx
	FROM dbo.DimProductCategory

	UNION ALL

	SELECT 'Snowflake', 'DimProductCategory', COUNT(*)
	FROM snowflake.DimProductCategory

	UNION ALL

	SELECT 'Source', 'DimProductSubcategory', COUNT(*)
	FROM dbo.DimProductSubcategory

	UNION ALL

	SELECT 'Snowflake', 'DimProductSubcategory', COUNT(*)
	FROM snowflake.DimProductSubcategory

	UNION ALL

	SELECT 'Source', 'DimGeography', COUNT(*)
	FROM dbo.DimGeography

	UNION ALL

	SELECT 'Snowflake', 'DimGeography', COUNT(*)
	FROM snowflake.DimGeography

	ORDER BY TableName, ModelName;
	GO



-- Чекор 8: Валидација на метрики за факт табелата


	PRINT 'Validating FactSales baseline measures...';

	SELECT
		'Source' AS ModelName,
		COUNT(*) AS SalesRows,
		SUM(SalesAmount) AS TotalSalesAmount,
		SUM(TotalCost) AS TotalCost,
		SUM(SalesQuantity) AS TotalSalesQuantity,
		SUM(ReturnQuantity) AS TotalReturnQuantity,
		SUM(DiscountAmount) AS TotalDiscountAmount
	FROM dbo.FactSales

	UNION ALL

	SELECT
		'Star' AS ModelName,
		COUNT(*) AS SalesRows,
		SUM(SalesAmount) AS TotalSalesAmount,
		SUM(TotalCost) AS TotalCost,
		SUM(SalesQuantity) AS TotalSalesQuantity,
		SUM(ReturnQuantity) AS TotalReturnQuantity,
		SUM(DiscountAmount) AS TotalDiscountAmount
	FROM star.FactSales

	UNION ALL

	SELECT
		'Snowflake' AS ModelName,
		COUNT(*) AS SalesRows,
		SUM(SalesAmount) AS TotalSalesAmount,
		SUM(TotalCost) AS TotalCost,
		SUM(SalesQuantity) AS TotalSalesQuantity,
		SUM(ReturnQuantity) AS TotalReturnQuantity,
		SUM(DiscountAmount) AS TotalDiscountAmount
	FROM snowflake.FactSales;
	GO



--  9. Валидирање на денормализирани димензии во star schema
	PRINT 'Validating denormalized star dimensions...';

	SELECT 
		COUNT(*) AS StarProductRows,
		COUNT(DISTINCT ProductKey) AS DistinctProductKeys,
		COUNT(DISTINCT ProductCategoryName) AS DistinctProductCategories,
		COUNT(DISTINCT ProductSubcategoryName) AS DistinctProductSubcategories
	FROM star.DimProduct;
	GO


	SELECT 
		COUNT(*) AS StarStoreRows,
		COUNT(DISTINCT StoreKey) AS DistinctStoreKeys,
		COUNT(DISTINCT RegionCountryName) AS DistinctCountriesRegions,
		COUNT(DISTINCT GeographyKey) AS DistinctGeographies
	FROM star.DimStore;
	GO

	PRINT 'LOAD COMPLETED.';
	GO