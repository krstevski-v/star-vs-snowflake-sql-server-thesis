USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Star Query 4: Daily Sales and Quantity by Geography for 2008

SELECT
	d.DateKey,
	d.FullDateLabel,
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM star.FactSales f
INNER JOIN star.DimDate d
	ON f.DateKey = d.DateKey
INNER JOIN star.DimStore s
	ON f.StoreKey = s.StoreKey
WHERE
	d.CalendarYear = 2008
GROUP BY
	d.DateKey,
	d.FullDateLabel,
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName;