USE ContosoRetailDW;

-- Чекор 1: Data validation на податоците од изворната база
-- Проверка на број на редици за сите релевантни табели


	SELECT 'FactSales' AS TableName, COUNT(*) AS row_count FROM dbo.FactSales
	UNION ALL 
	SELECT 'DimProduct', COUNT(*) FROM dbo.DimProduct
	UNION ALL
	SELECT 'DimProductSubcategory', COUNT(*) FROM dbo.DimProductSubcategory
	UNION ALL
	SELECT 'DimProductCategory', COUNT(*) FROM dbo.DimProductCategory
	UNION ALL
	SELECT 'DimStore', COUNT(*) FROM dbo.DimStore
	UNION ALL 
	SELECT 'DimGeography', COUNT(*) FROM dbo.DimGeography
	UNION ALL 
	SELECT 'DimDate', COUNT(*) FROM dbo.DimDate
	UNION ALL 
	SELECT 'DimPromotion', COUNT(*) FROM dbo.DimPromotion
	UNION ALL 
	SELECT 'DimChannel', COUNT(*) FROM dbo.DimChannel 
	ORDER BY TableName;


-- Чекор 2: Проверка на метадата за табелите
	
	SELECT
		TABLE_NAME,
		COLUMN_NAME,
		DATA_TYPE,
		CHARACTER_MAXIMUM_LENGTH,
		NUMERIC_PRECISION,
		NUMERIC_SCALE,
		IS_NULLABLE
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'dbo'
		AND TABLE_NAME IN (
			'FactSales',
			'DimProduct',
			'DimProductSubcategory',
			'DimProductCategory',
			'DimStore',
			'DimDate',
			'DimGeography',
			'DimPromotion',
			'DimChannel'
		)
	ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- Чекор 3: Проверка на NULL вредности за надворешните клучеви во Факт табелата
	SELECT
		SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS NullDateKey,
		SUM(CASE WHEN ChanneLKey IS NULL THEN 1 ELSE 0 END) AS NullChannelKey,
		SUM(CASE WHEN StoreKey IS NULL THEN 1 ELSE 0 END) AS NullStoreKey,
		SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END) AS NullProductKey,
		SUM(CASE WHEN PromotionKey IS NULL THEN 1 ELSE 0 END) AS NullPromotionKey
	FROM dbo.FactSales;

-- Чекор 4: Проверка за редици во Факт табелата кои што не постојат во табелите поврзани со надворешен клуч(Orphan records)
	SELECT 'Missing Date' AS Checkname, COUNT(*) AS MissingRows
	FROM dbo.FactSales f
	LEFT JOIN dbo.DimDate d
	ON f.DateKey = d.Datekey
	WHERE d.Datekey IS NULL

	UNION ALL

	SELECT 'Missing Channel' AS Checkname, COUNT(*) AS MissingRows
	FROM dbo.FactSales f
	LEFT JOIN dbo.DimChannel c
	ON f.ChannelKey = c.ChannelKey
	WHERE c.ChannelKey IS NULL

	UNION ALL

	SELECT 'Missing Store' AS Checkname, COUNT(*) AS MissingRows
	FROM dbo.FactSales f
	LEFT JOIN dbo.DimStore s
	ON f.StoreKey = s.StoreKey
	WHERE s.StoreKey IS NULL

	UNION ALL 

	SELECT 'Missing Product' AS Checkname, COUNT(*) AS MissingRows
	FROM dbo.FactSales f
	LEFT JOIN dbo.DimProduct p
	ON f.ProductKey = p.ProductKey
	WHERE p.ProductKey IS NULL

	UNION ALL

	SELECT 'Missing Promotion' AS Checkname, COUNT(*) AS MissingRows
	FROM dbo.FactSales f
	LEFT JOIN dbo.DimPromotion pr
	ON f.PromotionKey = pr.PromotionKey
	WHERE pr.PromotionKey IS NULL

-- Чекор 5: Проверка на fan-out кај snowflake за Product & Store хиерархии

	SELECT
		COUNT(*) AS BaseProductRows,
		COUNT(ps.ProductSubcategoryKey) AS MatchedSubcategories,
		COUNT(pc.ProductCategoryKey) AS MatchedCategories
	FROM dbo.DimProduct p
	LEFT JOIN dbo.DimProductSubcategory ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	LEFT JOIN dbo.DimProductCategory pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey;

	SELECT
		COUNT(*) AS BaseStoreRows,
		COUNT(g.GeographyKey) AS MatchedGeography,
		COUNT(*) - COUNT(g.GeographyKey) AS UnmatchedStores
	FROM dbo.DimStore s 
	LEFT JOIN dbo.DimGeography g
		ON s.GeographyKey = g.GeographyKey


-- Чекор 6: Проверка на грануларност и кардиналност во хиерархија

	SELECT
		pc.ProductCategoryName,
		COUNT(DISTINCT ps.ProductSubcategoryKey) AS SubcategoriesPerCategory,
		COUNT(DISTINCT p.ProductKey) as ProductsPerCategory
	FROM dbo.DimProductCategory pc
	INNER JOIN dbo.DimProductSubcategory ps ON pc.ProductCategoryKey = ps.ProductCategoryKey
	INNER JOIN dbo.DimProduct p ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
	GROUP BY pc.ProductCategoryName;


	SELECT
		g.ContinentName,
		COUNT(DISTINCT s.StoreKey) as StoresPerContinent
	FROM dbo.DimGeography g
	INNER JOIN DimStore s ON g.GeographyKey = s.GeographyKey
	GROUP BY g.ContinentName;