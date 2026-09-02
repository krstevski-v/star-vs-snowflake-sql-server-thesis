USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 4 Star 1: Total Sales by Product Category, Product Subcategory and Geography


SELECT
	--p.ProductCategoryKey,
	p.ProductCategoryName,
	--p.ProductSubcategoryKey,
	p.ProductSubcategoryName,
	--s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM 
	star.FactSales f
	INNER JOIN star.DimProduct p
	ON f.ProductKey = p.ProductKey
	INNER JOIN star.DimStore s
	ON f.StoreKey = s.StoreKey
GROUP BY
	p.ProductCategoryKey,
	p.ProductCategoryName,
	p.ProductSubcategoryKey,
	p.ProductSubcategoryName,
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName;