USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Star Query 2: Monthly Sales and Quantity by Geography

SELECT
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
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
GROUP BY
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName;