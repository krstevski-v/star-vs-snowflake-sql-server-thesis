USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 1 Star Query 3: Total Sales and Quantity by Geography

SELECT 
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM
	star.FactSales f 
	INNER JOIN star.DimStore s
	ON f.StoreKey = s.StoreKey
GROUP BY 
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName;
