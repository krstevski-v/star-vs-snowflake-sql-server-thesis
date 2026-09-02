USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 4 Snowflake 2: Total Sales by Year, Product Category, Product Subcategory, Geography, Scenario and Channel


SELECT
	d.CalendarYear,
	pc.ProductCategoryName,
	ps.ProductSubcategoryName,
	g.ContinentName,
	g.RegionCountryName,
	g.StateProvinceName,
	g.CityName,
	c.ChannelName,
	pr.PromotionName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM 
	snowflake.FactSales f
	INNER JOIN snowflake.DimDate d
		ON f.DateKey = d.DateKey
	INNER JOIN snowflake.DimChannel c
		ON f.ChannelKey = c.ChannelKey
	INNER JOIN snowflake.DimPromotion pr
		ON f.PromotionKey = pr.PromotionKey
	INNER JOIN snowflake.DimStore s
		ON f.StoreKey = s.StoreKey
	LEFT JOIN snowflake.DimGeography g
		ON s.GeographyKey = g.GeographyKey
	INNER JOIN snowflake.DimProduct p
		ON f.ProductKey = p.ProductKey
	LEFT JOIN snowflake.DimProductSubcategory ps
		ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	LEFT JOIN snowflake.DimProductCategory pc
		ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY
	d.CalendarYear,
	pc.ProductCategoryKey,
	pc.ProductCategoryName,
	ps.ProductSubcategoryKey,
	ps.ProductSubcategoryName,
	g.GeographyKey,
	g.ContinentName,
	g.RegionCountryName,
	g.StateProvinceName,
	g.CityName,
	c.ChannelKey,
	c.ChannelName,
	pr.PromotionKey,
	pr.PromotionName;