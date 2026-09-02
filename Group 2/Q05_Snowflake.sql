USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Snowflake Query 2: Monthly Sales and Quantity by Geography

SELECT
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	g.GeographyKey,
	g.ContinentName,
	g.RegionCountryName,
	g.StateProvinceName,
	g.CityName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM snowflake.FactSales f
INNER JOIN snowflake.DimDate d
	ON f.DateKey = d.DateKey
INNER JOIN snowflake.DimStore s
	ON f.StoreKey = s.StoreKey
LEFT JOIN snowflake.DimGeography g
	ON s.GeographyKey = g.GeographyKey
GROUP BY
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	g.GeographyKey,
	g.ContinentName,
	g.RegionCountryName,
	g.StateProvinceName,
	g.CityName;