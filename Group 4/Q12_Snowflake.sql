USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 4 Snowflake 1: Total Sales by Product Category, Product Subcategory and Geography


SELECT
	--pc.ProductCategoryKey,
	pc.ProductCategoryName,
	--ps.ProductSubcategoryKey,
	ps.ProductSubcategoryName,
	--g.GeographyKey,
	g.ContinentName,
	g.RegionCountryName,
	g.StateProvinceName,
	g.CityName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM 
	snowflake.FactSales f
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
	pc.ProductCategoryKey,
	pc.ProductCategoryName,
	ps.ProductSubcategoryKey,
	ps.ProductSubcategoryName,
	g.GeographyKey,
	g.ContinentName,
	g.RegionCountryName,
	g.StateProvinceName,
	g.CityName;